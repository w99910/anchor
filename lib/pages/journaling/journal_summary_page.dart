import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/ethstorage_config.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database_service.dart';
import '../../services/ethstorage_service.dart';
import '../../services/journal_notifier.dart';
import '../../utils/confetti_overlay.dart';
import '../../utils/responsive.dart';

class JournalSummaryPage extends StatefulWidget {
  /// If true, pops with result `true` to signal the journal list should refresh
  final bool returnResult;

  /// Journal entry ID for EthStorage upload
  final int? entryId;

  /// AI-generated analysis results (optional - for finalized entries)
  final String? summary;
  final String? emotionStatus;
  final List<String>? actionItems;
  final String? riskStatus; // "high", "medium", "low"

  const JournalSummaryPage({
    super.key,
    this.returnResult = false,
    this.entryId,
    this.summary,
    this.emotionStatus,
    this.actionItems,
    this.riskStatus,
  });

  @override
  State<JournalSummaryPage> createState() => _JournalSummaryPageState();
}

class _JournalSummaryPageState extends State<JournalSummaryPage> {
  final EthStorageService _ethStorageService = EthStorageService();
  final DatabaseService _databaseService = DatabaseService();
  late final ConfettiController _confettiController;

  bool _isUploadingToEthStorage = false;
  String? _ethStorageTxHash;
  String? _ethStorageError;

  bool get _hasAiAnalysis =>
      widget.summary != null ||
      widget.emotionStatus != null ||
      widget.actionItems != null;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    // Celebrate when entry is saved with AI analysis
    if (_hasAiAnalysis) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _uploadToEthStorage() async {
    if (widget.entryId == null || !_hasAiAnalysis) return;

    setState(() {
      _isUploadingToEthStorage = true;
      _ethStorageError = null;
    });

    try {
      // Check configuration first
      final isConfigured = await _ethStorageService.checkConfiguration();
      if (!isConfigured) {
        setState(() {
          _ethStorageError =
              _ethStorageService.lastError ??
              'EthStorage not configured. Add ETHSTORAGE_PRIVATE_KEY to .env file.';
          _isUploadingToEthStorage = false;
        });
        return;
      }

      // Create the summary data
      final data = JournalSummaryData(
        entryId: widget.entryId!,
        summary: widget.summary ?? '',
        emotionStatus: widget.emotionStatus ?? 'Unknown',
        actionItems: widget.actionItems ?? [],
        riskStatus: widget.riskStatus ?? 'low',
        walletAddress: _ethStorageService.walletAddress,
      );

      // Upload to EthStorage
      final result = await _ethStorageService.uploadJournalSummary(data);

      // Save the tx hash to the database
      await _databaseService.updateEthStorageTxHash(
        widget.entryId!,
        result.txHash,
      );

      setState(() {
        _ethStorageTxHash = result.txHash;
        _isUploadingToEthStorage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.successfullyUploaded),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.view,
              onPressed: () => _openExplorer(result.explorerUrl),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _ethStorageError = e.toString();
        _isUploadingToEthStorage = false;
      });
    }
  }

  Future<void> _openExplorer(String url) async {
    final uri = Uri.parse(url);
    debugPrint('Opening explorer URL: $url');
    try {
      // Try to launch directly - canLaunchUrl can return false on Android 11+
      // even when a browser is available
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        debugPrint('Failed to launch URL: $url');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.couldNotOpenBrowser(url),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorOpeningUrl(e.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: ResponsiveCenter(
              maxWidth: 500,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 48,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 32),

                          Text(
                            _hasAiAnalysis
                                ? AppLocalizations.of(context)!.entryFinalized
                                : AppLocalizations.of(context)!.entrySaved,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _hasAiAnalysis
                                ? AppLocalizations.of(context)!.entryAnalyzed
                                : AppLocalizations.of(context)!.draftSaved,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),

                          const SizedBox(height: 32),

                          // AI Analysis Results
                          if (_hasAiAnalysis) ...[
                            // Risk Status
                            if (widget.riskStatus != null)
                              _AnalysisCard(
                                icon: _getRiskIcon(widget.riskStatus!),
                                iconColor: _getRiskColor(widget.riskStatus!),
                                title: AppLocalizations.of(
                                  context,
                                )!.riskAssessment,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRiskColor(
                                          widget.riskStatus!,
                                        ).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        widget.riskStatus!.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: _getRiskColor(
                                                widget.riskStatus!,
                                              ),
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _getRiskDescription(
                                          context,
                                          widget.riskStatus!,
                                        ),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (widget.riskStatus != null)
                              const SizedBox(height: 12),

                            // Emotion Status
                            if (widget.emotionStatus != null)
                              _AnalysisCard(
                                icon: Icons.mood_rounded,
                                iconColor: _getEmotionColor(
                                  widget.emotionStatus!,
                                ),
                                title: AppLocalizations.of(
                                  context,
                                )!.emotionalState,
                                child: Text(
                                  widget.emotionStatus!,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: _getEmotionColor(
                                          widget.emotionStatus!,
                                        ),
                                      ),
                                ),
                              ),

                            if (widget.emotionStatus != null)
                              const SizedBox(height: 12),

                            // Summary
                            if (widget.summary != null)
                              _AnalysisCard(
                                icon: Icons.summarize_rounded,
                                iconColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                title: AppLocalizations.of(context)!.aiSummary,
                                child: Text(
                                  widget.summary!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                                ),
                              ),

                            if (widget.summary != null)
                              const SizedBox(height: 12),

                            // Action Items
                            if (widget.actionItems != null &&
                                widget.actionItems!.isNotEmpty)
                              _AnalysisCard(
                                icon: Icons.lightbulb_outline_rounded,
                                iconColor: Colors.amber,
                                title: AppLocalizations.of(
                                  context,
                                )!.suggestedActions,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widget.actionItems!
                                      .map(
                                        (item) => Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 8,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.arrow_right_rounded,
                                                size: 20,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  item,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                          ] else ...[
                            // Draft saved info
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardTheme.color,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outline.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.edit_note_rounded,
                                        size: 20,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.of(context)!.draftMode,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.draftModeDescription,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          height: 1.5,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // EthStorage Upload Section
                  if (_hasAiAnalysis && widget.entryId != null) ...[
                    _buildEthStorageSection(context),
                    const SizedBox(height: 12),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        // Notify journal page to refresh
                        journalNotifier.notifyJournalUpdated();

                        if (widget.returnResult) {
                          Navigator.pop(context, true);
                        } else {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.done),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          CelebrationConfetti(controller: _confettiController),
        ],
      ),
    );
  }

  Widget _buildEthStorageSection(BuildContext context) {
    // Already uploaded
    if (_ethStorageTxHash != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cloud_done_rounded,
                  color: Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.storedOnEthStorage,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'TX: ${_ethStorageTxHash!.substring(0, 10)}...${_ethStorageTxHash!.substring(_ethStorageTxHash!.length - 8)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _openExplorer(
                    EthStorageConfig.getExplorerTxUrl(_ethStorageTxHash!),
                  ),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text(AppLocalizations.of(context)!.view),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Error state
    if (_ethStorageError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.ethStorageConfigRequired,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _ethStorageError!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _uploadToEthStorage,
              icon: const Icon(Icons.refresh, size: 16),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    // Upload button
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _isUploadingToEthStorage ? null : _uploadToEthStorage,
        icon: _isUploadingToEthStorage
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.cloud_upload_outlined),
        label: Text(
          _isUploadingToEthStorage
              ? AppLocalizations.of(context)!.uploadingToEthStorage
              : AppLocalizations.of(context)!.storeOnEthStorage,
        ),
      ),
    );
  }

  Color _getEmotionColor(String emotion) {
    final emotionColors = {
      'happy': Colors.green,
      'content': Colors.teal,
      'peaceful': Colors.cyan,
      'neutral': Colors.grey,
      'sad': Colors.blue,
      'upset': Colors.indigo,
      'frustrated': Colors.orange,
      'anxious': Colors.deepOrange,
      'reflective': Colors.purple,
      'motivated': Colors.amber,
      'grateful': Colors.pink,
      'hopeful': Colors.lightGreen,
      'overwhelmed': Colors.red,
    };
    return emotionColors[emotion.toLowerCase()] ?? Colors.purple;
  }

  Color _getRiskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return Colors.green;
    }
  }

  IconData _getRiskIcon(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      case 'low':
      default:
        return Icons.check_circle_rounded;
    }
  }

  String _getRiskDescription(BuildContext context, String risk) {
    final l10n = AppLocalizations.of(context)!;
    switch (risk.toLowerCase()) {
      case 'high':
        return l10n.riskHighDesc;
      case 'medium':
        return l10n.riskMediumDesc;
      case 'low':
      default:
        return l10n.riskLowDesc;
    }
  }
}

class _AnalysisCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _AnalysisCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
