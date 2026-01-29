import 'package:flutter/material.dart';
import '../../main.dart' show setOnboardingComplete;
import '../../utils/responsive.dart';
import '../main_scaffold.dart';

class DownloadModelPage extends StatefulWidget {
  const DownloadModelPage({super.key});

  @override
  State<DownloadModelPage> createState() => _DownloadModelPageState();
}

class _DownloadModelPageState extends State<DownloadModelPage>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  bool _isDownloading = false;
  bool _isComplete = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startDownload() {
    setState(() => _isDownloading = true);

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return false;
      setState(() => _progress += 0.02);
      if (_progress >= 1.0) {
        setState(() {
          _isComplete = true;
          _isDownloading = false;
        });
        return false;
      }
      return true;
    });
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
                  final scale = _isDownloading
                      ? 1.0 + (_pulseController.value * 0.05)
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: _isComplete
                            ? Colors.green.withOpacity(0.1)
                            : Theme.of(
                                context,
                              ).colorScheme.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Icon(
                        _isComplete
                            ? Icons.check_rounded
                            : Icons.auto_awesome_rounded,
                        size: 64,
                        color: _isComplete
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              Text(
                _isComplete
                    ? 'All set!'
                    : _isDownloading
                    ? 'Setting up...'
                    : 'One last step',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isComplete
                    ? 'You\'re ready to start your journey'
                    : 'Download the AI model for offline chat and personalized responses',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              if (_isDownloading || _isComplete) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${(_progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              const Spacer(flex: 3),

              if (!_isDownloading && !_isComplete) ...[
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

              if (_isComplete)
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
