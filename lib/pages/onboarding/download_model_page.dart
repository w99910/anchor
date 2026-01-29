import 'package:flutter/material.dart';
import '../main_scaffold.dart';

class DownloadModelPage extends StatefulWidget {
  const DownloadModelPage({super.key});

  @override
  State<DownloadModelPage> createState() => _DownloadModelPageState();
}

class _DownloadModelPageState extends State<DownloadModelPage> {
  double _progress = 0.0;
  bool _isDownloading = false;
  bool _isComplete = false;

  void _startDownload() {
    setState(() {
      _isDownloading = true;
    });

    // Simulate download progress
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return false;
      setState(() {
        _progress += 0.02;
      });
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

  void _continue() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScaffold()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              _isComplete ? Icons.check_circle : Icons.cloud_download,
              size: 80,
              color: _isComplete
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              _isComplete
                  ? 'Setup Complete!'
                  : _isDownloading
                  ? 'Downloading AI Model...'
                  : 'Download AI Model',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _isComplete
                  ? 'You\'re all set to start your journey'
                  : 'The AI model enables offline chat and personalized responses',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            if (_isDownloading || _isComplete) ...[
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: 16),
              Text(
                '${(_progress * 100).toInt()}%',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            const SizedBox(height: 32),
            if (!_isDownloading && !_isComplete)
              FilledButton(
                onPressed: _startDownload,
                child: const Text('Download Now'),
              ),
            if (_isComplete)
              FilledButton(
                onPressed: _continue,
                child: const Text('Start Using Anchor'),
              ),
            if (!_isDownloading && !_isComplete) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: _continue,
                child: const Text('Skip for now'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
