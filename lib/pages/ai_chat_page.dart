import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../services/llm_service.dart';
import '../services/model_download_service.dart';
import '../utils/responsive.dart';
import 'model_download_page.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _llmService = LlmService();
  final _downloadService = ModelDownloadService();

  String _mode = 'friend';
  final List<_Message> _messages = [];
  bool _isGenerating = false;
  String _currentResponse = '';
  bool _isCheckingModel = true;

  @override
  void initState() {
    super.initState();
    _llmService.addListener(_onServiceStatusChanged);
    _downloadService.addListener(_onServiceStatusChanged);
    _checkAndLoadModel();
  }

  Future<void> _checkAndLoadModel() async {
    debugPrint('_checkAndLoadModel called');
    debugPrint(
      'isReady: ${_llmService.isReady}, isLoading: ${_llmService.isLoading}',
    );

    setState(() => _isCheckingModel = true);

    // First check if model is downloaded
    await _downloadService.initialize();

    // If model is downloaded, load it
    if (_downloadService.isDownloaded) {
      if (!_llmService.isReady && !_llmService.isLoading) {
        await _llmService.loadModel();
      }
    }

    setState(() => _isCheckingModel = false);
  }

  void _openDownloadPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ModelDownloadPage(
          onDownloadComplete: () {
            Navigator.of(context).pop();
            _checkAndLoadModel();
          },
        ),
      ),
    );
  }

  void _onServiceStatusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _llmService.removeListener(_onServiceStatusChanged);
    _downloadService.removeListener(_onServiceStatusChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isGenerating) return;

    setState(() {
      _messages.add(_Message(text: text, isUser: true));
      _isGenerating = true;
      _currentResponse = '';
    });
    _messageController.clear();
    _scrollToBottom();

    // Allow UI to update and show typing indicator before starting inference
    // Wait for frame to render
    await Future(() async {
      final completer = Completer<void>();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        completer.complete();
      });
      await completer.future;
    });

    try {
      if (_llmService.isReady) {
        // Use real LLM inference
        final streamController = StreamController<String>();

        // Listen to streaming updates
        streamController.stream.listen((partialResponse) {
          if (mounted) {
            setState(() {
              _currentResponse = partialResponse;
            });
            _scrollToBottom();
          }
        });

        final response = await _llmService.generateResponse(
          prompt: text,
          mode: _mode,
          maxTokens: 256,
          temperature: 0.7,
          streamController: streamController,
        );

        await streamController.close();

        if (mounted) {
          setState(() {
            _messages.add(_Message(text: response, isUser: false));
            _isGenerating = false;
            _currentResponse = '';
          });
        }
      } else {
        // Fallback to mock response when model not loaded
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          final mockResponse = _mode == 'friend'
              ? "Thanks for sharing that with me! I'm here to listen 😊"
              : "Thank you for opening up. Let's explore that together. What do you think might be contributing to these feelings?";

          setState(() {
            _messages.add(_Message(text: mockResponse, isUser: false));
            _isGenerating = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            _Message(
              text: "I'm sorry, I encountered an issue. Please try again.",
              isUser: false,
              isError: true,
            ),
          );
          _isGenerating = false;
          _currentResponse = '';
        });
      }
      debugPrint('Error generating response: $e');
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: padding.copyWith(bottom: 8, top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chat',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (!_llmService.isReady) ...[
                          const SizedBox(height: 4),
                          _ModelStatusBadge(
                            status: _llmService.status,
                            backend: _llmService.activeBackend,
                          ),
                        ],
                      ],
                    ),
                  ),
                  _ModeToggle(
                    mode: _mode,
                    onChanged: (mode) => setState(() => _mode = mode),
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: _messages.isEmpty && !_isGenerating
                  ? _EmptyState(
                      mode: _mode,
                      isModelReady: _llmService.isReady,
                      isModelDownloaded: _downloadService.isDownloaded,
                      isCheckingModel: _isCheckingModel,
                      onLoadModel: _checkAndLoadModel,
                      onDownloadModel: _openDownloadPage,
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _messages.length + (_isGenerating ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isGenerating) {
                          // Show typing indicator or current response
                          return _TypingIndicator(
                            currentText: _currentResponse,
                          );
                        }
                        return _ChatBubble(message: _messages[index]);
                      },
                    ),
            ),

            // Input
            Container(
              padding: const EdgeInsets.all(16),
              child: ResponsiveCenter(
                maxWidth: 600,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textCapitalization: TextCapitalization.sentences,
                        enabled: !_isGenerating,
                        decoration: InputDecoration(
                          hintText: _isGenerating
                              ? 'Thinking...'
                              : 'Type a message...',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _isGenerating ? null : _send,
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.arrow_upward_rounded),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelStatusBadge extends StatelessWidget {
  final LlmModelStatus status;
  final LlmBackend backend;

  const _ModelStatusBadge({required this.status, required this.backend});

  (IconData, String, Color) _getReadyStatus(BuildContext context) {
    return switch (backend) {
      LlmBackend.nativeRunner => (Icons.memory, 'Native AI', Colors.green),
      LlmBackend.executorchFlutter => (
        Icons.auto_awesome,
        'AI Ready',
        Colors.green,
      ),
      LlmBackend.mockResponses => (
        Icons.chat_bubble_outline,
        'Demo mode',
        Colors.orange,
      ),
      LlmBackend.none => (
        Icons.cloud_off_outlined,
        'Offline',
        Theme.of(context).colorScheme.outline,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (icon, label, color) = switch (status) {
      LlmModelStatus.notLoaded => (
        Icons.cloud_off_outlined,
        'Offline mode',
        Theme.of(context).colorScheme.outline,
      ),
      LlmModelStatus.loading => (
        Icons.downloading_rounded,
        'Loading model...',
        Theme.of(context).colorScheme.primary,
      ),
      LlmModelStatus.error => (
        Icons.error_outline,
        'Model error',
        Theme.of(context).colorScheme.error,
      ),
      LlmModelStatus.ready => _getReadyStatus(context),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final String mode;
  final ValueChanged<String> onChanged;

  const _ModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeChip(
            label: 'Friend',
            isSelected: mode == 'friend',
            onTap: () => onChanged('friend'),
          ),
          _ModeChip(
            label: 'Therapist',
            isSelected: mode == 'therapist',
            onTap: () => onChanged('therapist'),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String mode;
  final bool isModelReady;
  final bool isModelDownloaded;
  final bool isCheckingModel;
  final VoidCallback onLoadModel;
  final VoidCallback onDownloadModel;

  const _EmptyState({
    required this.mode,
    required this.isModelReady,
    required this.isModelDownloaded,
    required this.isCheckingModel,
    required this.onLoadModel,
    required this.onDownloadModel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                mode == 'friend' ? '👋' : '🧠',
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              mode == 'friend' ? 'Chat with a friend' : 'Guided conversation',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              mode == 'friend'
                  ? 'I\'m here to listen. Share anything on your mind.'
                  : 'Explore your thoughts with guided therapeutic dialogue.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (isCheckingModel) ...[
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                'Checking model...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ] else if (!isModelDownloaded) ...[
              // Model not downloaded - show download option
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.download_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Download AI Model',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get the Llama 3.2 1B model for private, on-device AI chat',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '~1.1 GB download',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: onDownloadModel,
                      icon: const Icon(Icons.download),
                      label: const Text('Download Model'),
                    ),
                  ],
                ),
              ),
            ] else if (!isModelReady) ...[
              // Model downloaded but not loaded
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.memory,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AI model ready',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Load the model to start chatting',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: onLoadModel,
                      child: const Text('Load Model'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final String currentText;

  const _TypingIndicator({required this.currentText});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(
            20,
          ).copyWith(bottomLeft: const Radius.circular(4)),
        ),
        child: currentText.isEmpty
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDot(context, 0),
                  const SizedBox(width: 4),
                  _buildDot(context, 1),
                  const SizedBox(width: 4),
                  _buildDot(context, 2),
                ],
              )
            : Text(
                currentText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(
              0.3 + (0.7 * ((value + index * 0.33) % 1)),
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  final bool isError;

  _Message({required this.text, required this.isUser, this.isError = false});
}

class _ChatBubble extends StatelessWidget {
  final _Message message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).colorScheme.primary
              : message.isError
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : null,
            bottomLeft: !message.isUser ? const Radius.circular(4) : null,
          ),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: message.isUser
                ? Theme.of(context).colorScheme.onPrimary
                : message.isError
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
