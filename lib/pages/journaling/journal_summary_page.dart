import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/ethstorage_service.dart';
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

  bool _isUploadingToEthStorage = false;
  String? _ethStorageTxHash;
  String? _ethStorageError;

  bool get _hasAiAnalysis =>
      widget.summary != null ||
      widget.emotionStatus != null ||
      widget.actionItems != null;

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

      setState(() {
        _ethStorageTxHash = result.txHash;
        _isUploadingToEthStorage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully uploaded to EthStorage!'),
            action: SnackBarAction(
              label: 'View',
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
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
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
                        _hasAiAnalysis ? 'Entry Finalized' : 'Entry Saved',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _hasAiAnalysis
                            ? 'Your journal entry has been analyzed'
                            : 'Your draft has been saved',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                            title: 'Risk Assessment',
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
                                    _getRiskDescription(widget.riskStatus!),
                                    style: Theme.of(context).textTheme.bodySmall
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
                            iconColor: _getEmotionColor(widget.emotionStatus!),
                            title: 'Emotional State',
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
                            iconColor: Theme.of(context).colorScheme.primary,
                            title: 'AI Summary',
                            child: Text(
                              widget.summary!,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(height: 1.5),
                            ),
                          ),

                        if (widget.summary != null) const SizedBox(height: 12),

                        // Action Items
                        if (widget.actionItems != null &&
                            widget.actionItems!.isNotEmpty)
                          _AnalysisCard(
                            icon: Icons.lightbulb_outline_rounded,
                            iconColor: Colors.amber,
                            title: 'Suggested Actions',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.actionItems!
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
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
                                    'Draft Mode',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'You can continue editing this entry for up to 3 days. When ready, finalize it to get AI-powered insights.',
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
                    if (widget.returnResult) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  child: const Text('Done'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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
                  'Stored on EthStorage',
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
                    'https://explorer.beta.testnet.l2.quarkchain.io/tx/$_ethStorageTxHash',
                  ),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('View'),
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
                    'EthStorage Configuration Required',
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
              label: const Text('Retry'),
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
              ? 'Uploading to EthStorage...'
              : 'Store on EthStorage (Testnet)',
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

  String _getRiskDescription(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return 'Consider reaching out to a mental health professional';
      case 'medium':
        return 'Some concerns detected - monitor your wellbeing';
      case 'low':
      default:
        return 'No significant concerns detected';
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
