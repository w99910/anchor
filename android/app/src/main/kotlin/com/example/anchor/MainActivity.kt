package com.example.anchor

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.BufferedReader
import java.io.InputStreamReader
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.anchor/llm"
    private val STREAM_CHANNEL = "com.example.anchor/llm_stream"
    private val TAG = "LlamaRunner"
    private var llamaProcess: Process? = null
    private var eventSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // EventChannel for streaming output
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, STREAM_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d(TAG, "Stream listener attached")
                }
                
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Log.d(TAG, "Stream listener cancelled")
                }
            }
        )
        
        // MethodChannel for commands
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "runLlamaStream" -> {
                    val modelPath = call.argument<String>("modelPath")
                    val tokenizerPath = call.argument<String>("tokenizerPath")
                    val prompt = call.argument<String>("prompt")
                    val maxSeqLen = call.argument<Int>("maxSeqLen") ?: 256
                    
                    if (modelPath == null || tokenizerPath == null || prompt == null) {
                        result.error("INVALID_ARGS", "Missing required arguments", null)
                        return@setMethodCallHandler
                    }
                    
                    // Return immediately, output will come via EventChannel
                    result.success(true)
                    runLlamaStreaming(modelPath, tokenizerPath, prompt, maxSeqLen)
                }
                "runLlama" -> {
                    val modelPath = call.argument<String>("modelPath")
                    val tokenizerPath = call.argument<String>("tokenizerPath")
                    val prompt = call.argument<String>("prompt")
                    val maxSeqLen = call.argument<Int>("maxSeqLen") ?: 256
                    
                    if (modelPath == null || tokenizerPath == null || prompt == null) {
                        result.error("INVALID_ARGS", "Missing required arguments", null)
                        return@setMethodCallHandler
                    }
                    
                    runLlamaInference(modelPath, tokenizerPath, prompt, maxSeqLen, result)
                }
                "isModelLoaded" -> {
                    result.success(llamaProcess != null && llamaProcess!!.isAlive)
                }
                "stopLlama" -> {
                    llamaProcess?.destroy()
                    llamaProcess = null
                    result.success(true)
                }
                "getNativeLibPath" -> {
                    val execPath = getExecutablePath()
                    result.success(if (File(execPath).exists()) execPath else null)
                }
                "isNativeRunnerAvailable" -> {
                    val nativeLibDir = applicationInfo.nativeLibraryDir
                    val sourcePath = "$nativeLibDir/libllama_main.so"
                    val sourceExists = File(sourcePath).exists()
                    Log.d(TAG, "isNativeRunnerAvailable: checking $sourcePath -> $sourceExists")
                    result.success(sourceExists)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun getExecutablePath(): String {
        val nativeLibDir = applicationInfo.nativeLibraryDir
        return "$nativeLibDir/libllama_main.so"
    }
    
    private fun ensureExecutable(): String? {
        val nativeLibDir = applicationInfo.nativeLibraryDir
        val executablePath = "$nativeLibDir/libllama_main.so"
        val executableFile = File(executablePath)
        
        Log.d(TAG, "Checking for binary at: $executablePath")
        
        if (!executableFile.exists()) {
            Log.e(TAG, "libllama_main.so not found at $executablePath")
            val dir = File(nativeLibDir)
            if (dir.exists()) {
                Log.d(TAG, "Contents of $nativeLibDir: ${dir.listFiles()?.map { it.name }}")
            }
            return null
        }
        
        Log.d(TAG, "Executable ready at $executablePath")
        return executablePath
    }
    
    private fun sendStreamEvent(type: String, data: String) {
        mainHandler.post {
            eventSink?.success(mapOf("type" to type, "data" to data))
        }
    }
    
    private fun sendStreamError(error: String) {
        mainHandler.post {
            eventSink?.error("LLAMA_ERROR", error, null)
        }
    }
    
    private fun sendStreamEnd() {
        mainHandler.post {
            eventSink?.endOfStream()
        }
    }
    
    private fun runLlamaStreaming(
        modelPath: String,
        tokenizerPath: String,
        prompt: String,
        maxSeqLen: Int
    ) {
        thread {
            try {
                val llamaMainPath = ensureExecutable()
                
                if (llamaMainPath == null) {
                    sendStreamError("llama_main binary not found")
                    return@thread
                }
                
                if (!File(modelPath).exists()) {
                    sendStreamError("Model file not found: $modelPath")
                    return@thread
                }
                
                if (!File(tokenizerPath).exists()) {
                    sendStreamError("Tokenizer file not found: $tokenizerPath")
                    return@thread
                }
                
                Log.d(TAG, "Running Llama inference (streaming)")
                sendStreamEvent("status", "loading")
                
                val command = arrayOf(
                    llamaMainPath,
                    "-model_path", modelPath,
                    "-tokenizer_path", tokenizerPath,
                    "-prompt", prompt,
                    "-max_new_tokens", maxSeqLen.toString()
                )
                
                val processBuilder = ProcessBuilder(*command)
                processBuilder.environment()["LD_LIBRARY_PATH"] = applicationInfo.nativeLibraryDir
                processBuilder.redirectErrorStream(true)
                processBuilder.directory(filesDir)
                
                llamaProcess = processBuilder.start()
                sendStreamEvent("status", "generating")
                
                val generatedText = StringBuilder()
                
                // Start a heartbeat thread to keep UI responsive
                val heartbeatThread = thread {
                    try {
                        while (llamaProcess?.isAlive == true) {
                            Thread.sleep(100) // Send heartbeat every 100ms
                            sendStreamEvent("heartbeat", "")
                        }
                    } catch (e: InterruptedException) {
                        // Thread interrupted, exit gracefully
                    }
                }
                
                val reader = BufferedReader(InputStreamReader(llamaProcess!!.inputStream))
                val fullOutput = StringBuilder()
                var line: String?
                
                // Read all output
                while (reader.readLine().also { line = it } != null) {
                    fullOutput.append(line).append("\n")
                    Log.d(TAG, "Output: $line")
                }
                
                // Parse the complete output to extract assistant response
                val outputStr = fullOutput.toString()
                
                // Find the assistant's response between markers
                val assistantStart = outputStr.lastIndexOf("<|start_header_id|>assistant<|end_header_id|>")
                if (assistantStart != -1) {
                    var response = outputStr.substring(assistantStart + "<|start_header_id|>assistant<|end_header_id|>".length)
                    
                    // Find end of response
                    val eotIndex = response.indexOf("<|eot_id|>")
                    if (eotIndex != -1) {
                        response = response.substring(0, eotIndex)
                    }
                    
                    // Clean up: remove log lines and timestamps
                    val cleanedLines = response.split("\n").mapNotNull { l ->
                        var cleaned = l
                        // Remove embedded log timestamps
                        val logMatch = Regex("""[IEW]\s+\d{2}:\d{2}:\d{2}\.\d+.*""").find(cleaned)
                        if (logMatch != null) {
                            cleaned = cleaned.substring(0, logMatch.range.first)
                        }
                        // Skip pure log lines
                        if (cleaned.matches(Regex("""^[IEW]\s+\d{2}:\d{2}.*""")) ||
                            cleaned.contains("executorch:") ||
                            cleaned.startsWith("PyTorchObserver") ||
                            cleaned.contains("Reached to the end of generation")) {
                            null
                        } else {
                            cleaned.trim()
                        }
                    }.filter { it.isNotEmpty() }
                    
                    val finalResponse = cleanedLines.joinToString(" ").trim()
                    generatedText.append(finalResponse)
                    
                    if (finalResponse.isNotEmpty()) {
                        sendStreamEvent("token", finalResponse)
                        Log.d(TAG, "Final response: $finalResponse")
                    }
                }
                
                val exitCode = llamaProcess!!.waitFor()
                llamaProcess = null
                heartbeatThread.interrupt() // Stop heartbeat
                
                Log.d(TAG, "Llama exited with code: $exitCode")
                
                val finalText = generatedText.toString().trim()
                if (exitCode == 0) {
                    sendStreamEvent("done", finalText)
                } else {
                    sendStreamError("Llama exited with code $exitCode")
                }
                
            } catch (e: Exception) {
                Log.e(TAG, "Exception running Llama: ${e.message}", e)
                sendStreamError(e.message ?: "Unknown error")
            }
        }
    }
    
    private fun runLlamaInference(
        modelPath: String,
        tokenizerPath: String,
        prompt: String,
        maxSeqLen: Int,
        result: MethodChannel.Result
    ) {
        thread {
            try {
                val llamaMainPath = ensureExecutable()
                
                if (llamaMainPath == null) {
                    mainHandler.post {
                        result.error("BINARY_NOT_FOUND", 
                            "llama_main binary not found.", null)
                    }
                    return@thread
                }
                
                if (!File(modelPath).exists()) {
                    mainHandler.post {
                        result.error("MODEL_NOT_FOUND", "Model file not found: $modelPath", null)
                    }
                    return@thread
                }
                
                if (!File(tokenizerPath).exists()) {
                    mainHandler.post {
                        result.error("TOKENIZER_NOT_FOUND", "Tokenizer file not found: $tokenizerPath", null)
                    }
                    return@thread
                }
                
                Log.d(TAG, "Running Llama inference")
                
                val command = arrayOf(
                    llamaMainPath,
                    "-model_path", modelPath,
                    "-tokenizer_path", tokenizerPath,
                    "-prompt", prompt,
                    "-max_new_tokens", maxSeqLen.toString()
                )
                
                val processBuilder = ProcessBuilder(*command)
                processBuilder.environment()["LD_LIBRARY_PATH"] = applicationInfo.nativeLibraryDir
                processBuilder.redirectErrorStream(true)
                processBuilder.directory(filesDir)
                
                llamaProcess = processBuilder.start()
                
                val reader = BufferedReader(InputStreamReader(llamaProcess!!.inputStream))
                val output = StringBuilder()
                var line: String?
                
                while (reader.readLine().also { line = it } != null) {
                    Log.d(TAG, "Output: $line")
                    output.append(line).append("\n")
                }
                
                val exitCode = llamaProcess!!.waitFor()
                llamaProcess = null
                
                Log.d(TAG, "Llama exited with code: $exitCode")
                
                mainHandler.post {
                    if (exitCode == 0) {
                        result.success(output.toString())
                    } else {
                        result.error("LLAMA_ERROR", "Llama exited with code $exitCode", output.toString())
                    }
                }
                
            } catch (e: Exception) {
                Log.e(TAG, "Exception running Llama: ${e.message}", e)
                mainHandler.post {
                    result.error("EXCEPTION", e.message, e.stackTraceToString())
                }
            }
        }
    }
    
    override fun onDestroy() {
        llamaProcess?.destroy()
        super.onDestroy()
    }
}
