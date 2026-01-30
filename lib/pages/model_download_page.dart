import 'package:flutter/material.dart';

import '../services/model_download_service.dart';

/// Page for downloading the AI model
class ModelDownloadPage extends StatefulWidget {
  final VoidCallback? onDownloadComplete;

  const ModelDownloadPage({super.key, this.onDownloadComplete});

  @override
  State<ModelDownloadPage> createState() => _ModelDownloadPageState();
}

class _ModelDownloadPageState extends State<ModelDownloadPage> {
  final ModelDownloadService _downloadService = ModelDownloadService();
  bool _initialized = false;
  bool _completedCallbackCalled = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    _downloadService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _downloadService.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (!mounted) return;
    setState(() {});

    // Navigate back if download is complete (defer to avoid navigator lock)
    if (_downloadService.isDownloaded &&
        widget.onDownloadComplete != null &&
        !_completedCallbackCalled) {
      _completedCallbackCalled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onDownloadComplete!();
        }
      });
    }
  }

  Future<void> _initialize() async {
    await _downloadService.initialize();
    setState(() {
      _initialized = true;
    });
  }

  Future<void> _startDownload() async {
    await _downloadService.downloadModel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Model'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Icon(
                Icons.smart_toy_outlined,
                size: 80,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'On-Device AI Chat',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Download the Llama 3.2 1B model to enable private, on-device AI conversations.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Model info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.memory, color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Llama 3.2 1B Instruct',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'SpinQuant INT4 • Optimized for mobile',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.storage, 'Size', '~1.1 GB'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.speed, 'Speed', '~20 tokens/sec'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.lock, 'Privacy', '100% on-device'),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Status and progress
              if (!_initialized)
                const Center(child: CircularProgressIndicator())
              else
                _buildStatusContent(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatusContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (_downloadService.status) {
      case ModelDownloadStatus.notDownloaded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _startDownload,
              icon: const Icon(Icons.download),
              label: const Text('Download Model'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Requires Wi-Fi recommended. Download size: ~1.1 GB',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case ModelDownloadStatus.checking:
        return const Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Checking model status...'),
            ],
          ),
        );

      case ModelDownloadStatus.downloading:
        final progress = _downloadService.downloadProgress;
        final downloadedMB = _downloadService.downloadedBytes / 1024 / 1024;
        final totalMB = _downloadService.totalBytes / 1024 / 1024;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              totalMB > 0
                  ? '${downloadedMB.toStringAsFixed(1)} / ${totalMB.toStringAsFixed(1)} MB'
                  : 'Downloading...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Please keep the app open during download',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case ModelDownloadStatus.downloaded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Model Ready',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Start Chatting'),
            ),
          ],
        );

      case ModelDownloadStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: colorScheme.error),
                  const SizedBox(height: 8),
                  Text(
                    'Download Failed',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_downloadService.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _downloadService.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _startDownload,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Download'),
            ),
          ],
        );
    }
  }
}
