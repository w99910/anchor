import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/ai_settings_service.dart';
import '../services/database_service.dart';
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
  final _databaseService = DatabaseService();
  final _aiSettings = AiSettingsService();

  String _mode = 'friend';
  final List<ChatMessage> _messages = [];
  bool _isGenerating = false;
  String _currentResponse = '';
  bool _isCheckingModel = true;
  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();
    _llmService.addListener(_onServiceStatusChanged);
    _downloadService.addListener(_onServiceStatusChanged);
    _aiSettings.addListener(_onServiceStatusChanged);
    _initializeSettings();
    // Start with fresh chat - don't load old messages
    // _loadMessages();
    setState(() => _isLoadingMessages = false);
    _checkAndLoadModel();
  }

  Future<void> _initializeSettings() async {
    await _aiSettings.initialize();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoadingMessages = true);
    try {
      final messages = await _databaseService.getChatMessages(mode: _mode);
      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
          _isLoadingMessages = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
      if (mounted) {
        setState(() => _isLoadingMessages = false);
      }
    }
  }

  Future<void> _checkAndLoadModel() async {
    debugPrint('_checkAndLoadModel called');
    debugPrint(
      'isReady: ${_llmService.isReady}, isLoading: ${_llmService.isLoading}',
    );

    if (!mounted) return;
    setState(() => _isCheckingModel = true);

    // First check if model is downloaded
    await _downloadService.initialize();

    // If model is downloaded, load it
    if (_downloadService.isDownloaded) {
      if (!_llmService.isReady && !_llmService.isLoading) {
        await _llmService.loadModel();
      }
    }

    if (!mounted) return;
    setState(() => _isCheckingModel = false);
  }

  void _openDownloadPage({bool forChangeModel = false}) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ModelDownloadPage(
              forceShowModelSelection: forChangeModel,
              onDownloadComplete: () async {
                Navigator.of(context).pop();
                // Wait for the model to load after download
                await _checkAndLoadModel();
              },
            ),
          ),
        )
        .then((_) {
          // When returning from download page (even without downloading),
          // refresh the model state to ensure we use the current downloaded model
          _checkAndLoadModel();
        });
  }

  void _onServiceStatusChanged() {
    if (mounted) {
      // Defer setState to avoid calling it during build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _llmService.removeListener(_onServiceStatusChanged);
    _downloadService.removeListener(_onServiceStatusChanged);
    _aiSettings.removeListener(_onServiceStatusChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isGenerating || _isCheckingModel) return;

    // Check if model is still loading
    if (_llmService.isLoading) {
      debugPrint('Model is still loading, waiting...');
      return;
    }

    // Create and save user message
    final userMessage = ChatMessage(text: text, isUser: true, mode: _mode);

    setState(() {
      _messages.add(userMessage);
      _isGenerating = true;
      _currentResponse = '';
    });
    _messageController.clear();
    _scrollToBottom();

    // Save user message to database
    await _databaseService.insertChatMessage(userMessage);

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

        // Build chat history from previous messages (exclude the current one we just added)
        final chatHistory = _messages
            .where((m) => !m.isError && m != userMessage)
            .map(
              (m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'content': m.text,
              },
            )
            .toList();

        final response = await _llmService.generateResponse(
          prompt: text,
          mode: _mode,
          chatHistory: chatHistory,
          maxTokens: 1024,
          temperature: 0.7,
          streamController: streamController,
        );

        await streamController.close();

        if (mounted) {
          final aiMessage = ChatMessage(
            text: response,
            isUser: false,
            mode: _mode,
          );
          setState(() {
            _messages.add(aiMessage);
            _isGenerating = false;
            _currentResponse = '';
          });
          // Save AI response to database
          await _databaseService.insertChatMessage(aiMessage);
        }
      } else {
        // Fallback to mock response when model not loaded
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          final mockResponse = _mode == 'friend'
              ? "Thanks for sharing that with me! I'm here to listen 😊"
              : "Thank you for opening up. Let's explore that together. What do you think might be contributing to these feelings?";

          final aiMessage = ChatMessage(
            text: mockResponse,
            isUser: false,
            mode: _mode,
          );
          setState(() {
            _messages.add(aiMessage);
            _isGenerating = false;
          });
          // Save AI response to database
          await _databaseService.insertChatMessage(aiMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = ChatMessage(
          text: "I'm sorry, I encountered an issue. Please try again.",
          isUser: false,
          isError: true,
          mode: _mode,
        );
        setState(() {
          _messages.add(errorMessage);
          _isGenerating = false;
          _currentResponse = '';
        });
        // Save error message to database
        await _databaseService.insertChatMessage(errorMessage);
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
    final l10n = AppLocalizations.of(context)!;

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
                          l10n.chat,
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
                  // Show change model button if using on-device and can use advanced model
                  if (!_aiSettings.isCloudProvider &&
                      _downloadService.canUseAdvancedModel &&
                      _downloadService.isDownloaded)
                    IconButton(
                      onPressed: () => _openDownloadPage(forChangeModel: true),
                      icon: const Icon(Icons.swap_horiz_rounded),
                      tooltip: l10n.changeModelTooltip(
                        _downloadService.selectedModelName,
                      ),
                    ),
                  _ModeToggle(
                    mode: _mode,
                    onChanged: (mode) {
                      setState(() {
                        _mode = mode;
                        _messages
                            .clear(); // Clear messages when switching modes
                      });
                    },
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: _isLoadingMessages
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty && !_isGenerating
                  ? _EmptyState(
                      mode: _mode,
                      isModelReady: _llmService.isReady,
                      isModelDownloaded: _downloadService.isDownloaded,
                      isCheckingModel: _isCheckingModel,
                      isModelLoading: _llmService.isLoading,
                      isCloudProvider: _aiSettings.isCloudProvider,
                      modelName: _downloadService.selectedModelName,
                      modelSize: _downloadService.selectedModelSize,
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
                        enabled:
                            !_isGenerating &&
                            !_isCheckingModel &&
                            !_llmService.isLoading,
                        decoration: InputDecoration(
                          hintText: _isGenerating
                              ? l10n.thinking
                              : (_isCheckingModel || _llmService.isLoading)
                              ? l10n.loadingModel
                              : l10n.typeMessage,
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
                      onPressed:
                          (_isGenerating ||
                              _isCheckingModel ||
                              _llmService.isLoading)
                          ? null
                          : _send,
                      icon: (_isGenerating || _llmService.isLoading)
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
    final l10n = AppLocalizations.of(context)!;
    return switch (backend) {
      LlmBackend.nativeRunner => (Icons.memory, l10n.nativeAi, Colors.green),
      LlmBackend.executorchFlutter => (
        Icons.auto_awesome,
        l10n.aiReady,
        Colors.green,
      ),
      LlmBackend.geminiCloud => (
        Icons.cloud_rounded,
        l10n.cloudAi,
        Colors.blue,
      ),
      LlmBackend.mockResponses => (
        Icons.chat_bubble_outline,
        l10n.demoMode,
        Colors.orange,
      ),
      LlmBackend.none => (
        Icons.cloud_off_outlined,
        l10n.offline,
        Theme.of(context).colorScheme.outline,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (icon, label, color) = switch (status) {
      LlmModelStatus.notLoaded => (
        Icons.cloud_off_outlined,
        l10n.offlineMode,
        Theme.of(context).colorScheme.outline,
      ),
      LlmModelStatus.loading => (
        Icons.downloading_rounded,
        l10n.loadingModel,
        Theme.of(context).colorScheme.primary,
      ),
      LlmModelStatus.error => (
        Icons.error_outline,
        l10n.modelError,
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
    final l10n = AppLocalizations.of(context)!;
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
            label: l10n.friend,
            isSelected: mode == 'friend',
            onTap: () => onChanged('friend'),
          ),
          _ModeChip(
            label: l10n.therapist,
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
  final bool isModelLoading;
  final bool isCloudProvider;
  final String modelName;
  final String modelSize;
  final VoidCallback onLoadModel;
  final VoidCallback onDownloadModel;

  const _EmptyState({
    required this.mode,
    required this.isModelReady,
    required this.isModelDownloaded,
    required this.isCheckingModel,
    required this.isModelLoading,
    required this.isCloudProvider,
    required this.modelName,
    required this.modelSize,
    required this.onLoadModel,
    required this.onDownloadModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // If using cloud provider, show ready state
    if (isCloudProvider) {
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
                mode == 'friend'
                    ? l10n.chatWithFriend
                    : l10n.guidedConversation,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                mode == 'friend'
                    ? l10n.friendEmptyStateDescription
                    : l10n.therapistEmptyStateDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_rounded,
                      size: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.usingCloudAi,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

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
              mode == 'friend' ? l10n.chatWithFriend : l10n.guidedConversation,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              mode == 'friend'
                  ? l10n.friendEmptyStateDescription
                  : l10n.therapistEmptyStateDescription,
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
                l10n.checkingModel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ] else if (isModelLoading) ...[
              // Model is loading
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.loadingAiModel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.preparingModelForChat,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
                      l10n.downloadAiModel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.getModelForPrivateChat(modelName),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.downloadSize(modelSize),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: onDownloadModel,
                      icon: const Icon(Icons.download),
                      label: Text(l10n.downloadModel),
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
                      l10n.aiModelReady,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.loadModelToStartChatting,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonal(
                      onPressed: onLoadModel,
                      child: Text(l10n.loadModel),
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

class _TypingIndicator extends StatefulWidget {
  final String currentText;

  const _TypingIndicator({required this.currentText});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: widget.currentText.isEmpty
            ? AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDot(context, 0),
                      const SizedBox(width: 4),
                      _buildDot(context, 1),
                      const SizedBox(width: 4),
                      _buildDot(context, 2),
                    ],
                  );
                },
              )
            : Text(
                widget.currentText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
      ),
    );
  }

  Widget _buildDot(BuildContext context, int index) {
    // Stagger the animation for each dot
    final offset = index * 0.2;
    final value = (_controller.value + offset) % 1.0;
    // Sine wave for smooth pulsing
    final opacity = 0.3 + 0.7 * ((sin(value * 2 * pi) + 1) / 2);

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

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
