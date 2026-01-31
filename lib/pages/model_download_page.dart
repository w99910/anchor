import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/model_download_service.dart';

/// Page for downloading the AI model
class ModelDownloadPage extends StatefulWidget {
  final VoidCallback? onDownloadComplete;
  final bool
  forceShowModelSelection; // When true, show model selection even if model is downloaded

  const ModelDownloadPage({
    super.key,
    this.onDownloadComplete,
    this.forceShowModelSelection = false,
  });

  @override
  State<ModelDownloadPage> createState() => _ModelDownloadPageState();
}

class _ModelDownloadPageState extends State<ModelDownloadPage> {
  final ModelDownloadService _downloadService = ModelDownloadService();
  bool _initialized = false;
  bool _completedCallbackCalled = false;
  bool _showModelSelection = false;

  @override
  void initState() {
    super.initState();
    // Set initial state based on forceShowModelSelection before adding listener
    _showModelSelection = widget.forceShowModelSelection;
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
    // But only if not in change model flow (forceShowModelSelection)
    if (_downloadService.isDownloaded &&
        widget.onDownloadComplete != null &&
        !_completedCallbackCalled &&
        !widget.forceShowModelSelection) {
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
      // Show model selection if:
      // - device can use advanced model AND (model not downloaded OR forced to show selection)
      _showModelSelection =
          _downloadService.canUseAdvancedModel &&
          (!_downloadService.isDownloaded || widget.forceShowModelSelection);
    });
  }

  Future<void> _startDownload() async {
    await _downloadService.downloadModel();
  }

  Future<void> _selectModel(ModelType type) async {
    await _downloadService.setModelType(type);
    setState(() {
      _showModelSelection = false;
    });
  }

  void _changeModel() {
    setState(() {
      _showModelSelection = true;
    });
  }

  Future<void> _switchModel() async {
    // Delete current model and prepare for new download
    await _downloadService.deleteModel();
    setState(() {
      _showModelSelection = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiModel),
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
                l10n.onDeviceAiChat,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _showModelSelection
                    ? l10n.choosePreferredAiModel
                    : l10n.downloadModelDescription,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Model selection or info card
              if (_showModelSelection && _downloadService.canUseAdvancedModel)
                _buildModelSelection()
              else
                _buildModelInfoCard(),

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

  Widget _buildModelSelection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final downloadedType = _downloadService.downloadedModelType;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.selectModel,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Advanced Model Option
        _ModelOptionCard(
          type: ModelType.advanced,
          name: _downloadService.getModelName(ModelType.advanced),
          size: _downloadService.getModelSize(ModelType.advanced),
          description: _downloadService.getModelDescription(ModelType.advanced),
          isSelected: _downloadService.currentModelType == ModelType.advanced,
          isRecommended: true,
          isCurrent: downloadedType == ModelType.advanced,
          onTap: downloadedType == ModelType.advanced
              ? null
              : () => _selectModel(ModelType.advanced),
        ),

        const SizedBox(height: 12),

        // Compact Model Option
        _ModelOptionCard(
          type: ModelType.compact,
          name: _downloadService.getModelName(ModelType.compact),
          size: _downloadService.getModelSize(ModelType.compact),
          description: _downloadService.getModelDescription(ModelType.compact),
          isSelected: _downloadService.currentModelType == ModelType.compact,
          isRecommended: false,
          isCurrent: downloadedType == ModelType.compact,
          onTap: downloadedType == ModelType.compact
              ? null
              : () => _selectModel(ModelType.compact),
        ),

        const SizedBox(height: 16),

        Text(
          l10n.deviceHasEnoughRam,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModelInfoCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
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
                        _downloadService.selectedModelName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _downloadService.useAdvancedModel
                            ? l10n.moreCapableBetterResponses
                            : l10n.lightweightFastResponses,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                // Show change button if device can use advanced model
                if (_downloadService.canUseAdvancedModel &&
                    !_downloadService.isDownloading)
                  TextButton(
                    onPressed: _downloadService.isDownloaded
                        ? _switchModel
                        : _changeModel,
                    child: Text(
                      _downloadService.isDownloaded
                          ? l10n.switchText
                          : l10n.change,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.storage,
              l10n.size,
              l10n.downloadSize(_downloadService.selectedModelSize),
            ),

            const SizedBox(height: 8),
            _buildInfoRow(Icons.lock, l10n.privacy, l10n.privateOnDevice),
          ],
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
    final l10n = AppLocalizations.of(context)!;

    // If showing model selection, don't show download button
    if (_showModelSelection) {
      return const SizedBox.shrink();
    }

    switch (_downloadService.status) {
      case ModelDownloadStatus.notDownloaded:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _startDownload,
              icon: const Icon(Icons.download),
              label: Text(l10n.downloadModel),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.requiresWifiDownloadSize(_downloadService.selectedModelSize),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case ModelDownloadStatus.checking:
        return Center(
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(l10n.checkingModelStatus),
            ],
          ),
        );

      case ModelDownloadStatus.downloading:
        final progress = _downloadService.downloadProgress;
        final downloadedMB = _downloadService.downloadedBytes / 1024 / 1024;
        final totalMB = _downloadService.totalBytes / 1024 / 1024;

        // Ensure progress is a valid value between 0 and 1
        final safeProgress = progress.isNaN || progress.isInfinite
            ? 0.0
            : progress.clamp(0.0, 1.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: safeProgress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Text(
              '${(safeProgress * 100).toStringAsFixed(1)}%',
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
                  : l10n.downloading,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.keepAppOpenDuringDownload,
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
                    l10n.modelReady,
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
              child: Text(l10n.startChatting),
            ),
            // Show switch model option if device can use both models
            if (_downloadService.canUseAdvancedModel) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _switchModel,
                icon: const Icon(Icons.swap_horiz),
                label: Text(l10n.switchToDifferentModel),
              ),
            ],
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
                    l10n.downloadFailed,
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
              label: Text(l10n.retryDownload),
            ),
          ],
        );
    }
  }
}

/// Card widget for model selection option
class _ModelOptionCard extends StatelessWidget {
  final ModelType type;
  final String name;
  final String size;
  final String description;
  final bool isSelected;
  final bool isRecommended;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _ModelOptionCard({
    required this.type,
    required this.name,
    required this.size,
    required this.description,
    required this.isSelected,
    required this.isRecommended,
    this.isCurrent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDisabled = onTap == null;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.surfaceContainerHighest
              : isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent
                ? colorScheme.outline
                : isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected && !isCurrent ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCurrent
                    ? colorScheme.surfaceContainerHigh
                    : isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type == ModelType.advanced ? Icons.auto_awesome : Icons.speed,
                color: isCurrent
                    ? colorScheme.onSurfaceVariant
                    : isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDisabled
                              ? colorScheme.onSurface.withValues(alpha: 0.6)
                              : isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.current,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ] else if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            l10n.recommended,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDisabled
                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                          : isSelected
                          ? colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.8,
                            )
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCurrent ? l10n.currentlyInUse : l10n.downloadSize(size),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isCurrent
                          ? colorScheme.primary
                          : isDisabled
                          ? colorScheme.outline.withValues(alpha: 0.6)
                          : isSelected
                          ? colorScheme.onPrimaryContainer.withValues(
                              alpha: 0.6,
                            )
                          : colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            if (!isCurrent)
              Radio<ModelType>(
                value: type,
                groupValue: isSelected ? type : null,
                onChanged: isDisabled ? null : (_) => onTap?.call(),
                activeColor: colorScheme.primary,
              )
            else
              Icon(Icons.check_circle, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
