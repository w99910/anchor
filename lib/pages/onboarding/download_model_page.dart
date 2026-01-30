import 'package:flutter/material.dart';
import '../../main.dart' show setOnboardingComplete;
import '../../services/llm_service.dart';
import '../../utils/responsive.dart';
import '../main_scaffold.dart';

class DownloadModelPage extends StatefulWidget {
  const DownloadModelPage({super.key});

  @override
  State<DownloadModelPage> createState() => _DownloadModelPageState();
}

class _DownloadModelPageState extends State<DownloadModelPage>
    with SingleTickerProviderStateMixin {
  final _llmService = LlmService();
  late AnimationController _pulseController;
  String _statusMessage =
      'Download the AI model for offline chat and personalized responses';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Listen to LLM service status changes
    _llmService.addListener(_onServiceStatusChanged);

    // Check if model is already available
    _checkModelAvailability();
  }

  Future<void> _checkModelAvailability() async {
    final isAvailable = await _llmService.isModelAvailable();
    if (isAvailable && mounted) {
      setState(() {
        _statusMessage = 'AI model found! Ready to set up.';
      });
    }
  }

  void _onServiceStatusChanged() {
    if (!mounted) return;

    setState(() {
      switch (_llmService.status) {
        case LlmModelStatus.loading:
          _statusMessage = 'Setting up AI model...';
          break;
        case LlmModelStatus.ready:
          _statusMessage = 'AI model ready!';
          break;
        case LlmModelStatus.error:
          _statusMessage = _llmService.errorMessage ?? 'Error loading model';
          break;
        case LlmModelStatus.notLoaded:
          _statusMessage =
              'Download the AI model for offline chat and personalized responses';
          break;
      }
    });
  }

  @override
  void dispose() {
    _llmService.removeListener(_onServiceStatusChanged);
    _pulseController.dispose();
    super.dispose();
  }

  void _startDownload() async {
    // Start loading the model
    await _llmService.loadModel();
  }

  void _continue() async {
    // Mark onboarding as complete
    await setOnboardingComplete();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScaffold(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _llmService.isLoading;
    final isReady = _llmService.isReady;
    final hasError = _llmService.status == LlmModelStatus.error;
    final progress = _llmService.loadProgress;

    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = isLoading
                      ? 1.0 + (_pulseController.value * 0.05)
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isReady
                            ? Colors.green.withOpacity(0.1)
                            : hasError
                            ? Colors.red.withOpacity(0.1)
                            : Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(
                        isReady
                            ? Icons.check_rounded
                            : hasError
                            ? Icons.error_outline_rounded
                            : Icons.auto_awesome_rounded,
                        size: 64,
                        color: isReady
                            ? Colors.green
                            : hasError
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              Text(
                isReady
                    ? 'All set!'
                    : hasError
                    ? 'Setup incomplete'
                    : isLoading
                    ? 'Setting up...'
                    : 'One last step',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isReady
                    ? 'You\'re ready to start your journey'
                    : _statusMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              if (isLoading || isReady) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              const Spacer(flex: 3),

              if (!isLoading && !isReady) ...[
                FilledButton(
                  onPressed: _startDownload,
                  child: const Text('Download'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _continue,
                  child: const Text('Skip for now'),
                ),
              ],

              if (hasError) ...[
                FilledButton(
                  onPressed: _startDownload,
                  child: const Text('Retry'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _continue,
                  child: const Text('Continue without AI'),
                ),
              ],

              if (isReady)
                FilledButton(
                  onPressed: _continue,
                  child: const Text('Get Started'),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
