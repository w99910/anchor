import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../utils/responsive.dart';
import 'create_journal_page.dart';

class JournalingPage extends StatefulWidget {
  const JournalingPage({super.key});

  @override
  State<JournalingPage> createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  final _databaseService = DatabaseService();
  List<JournalEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() => _isLoading = true);
    try {
      final entries = await _databaseService.getJournalEntries();
      if (mounted) {
        setState(() {
          _entries = entries;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading journal entries: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _navigateToCreate() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateJournalPage()),
    );
    // Reload entries if a new one was created
    if (result == true) {
      _loadEntries();
    }
  }

  Future<void> _navigateToEntry(JournalEntry entry) async {
    if (entry.isEditable) {
      // Open for editing
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => CreateJournalPage(entry: entry)),
      );
      // Reload entries if the entry was updated
      if (result == true) {
        _loadEntries();
      }
    } else {
      // Show finalized entry details
      _showFinalizedEntryDetails(entry);
    }
  }

  void _showFinalizedEntryDetails(JournalEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FinalizedEntrySheet(entry: entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: padding.copyWith(bottom: 0),
              sliver: SliverToBoxAdapter(
                child: ResponsiveCenter(
                  maxWidth: 600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Journal',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: _navigateToCreate,
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: const Text('New'),
                            style: FilledButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_entries.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.book_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No journal entries yet',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the + button to create your first entry',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: padding.copyWith(top: 0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (index == _entries.length) {
                      return const SizedBox(height: 100);
                    }
                    final entry = _entries[index];
                    return ResponsiveCenter(
                      maxWidth: 600,
                      child: _JournalCard(
                        entry: entry,
                        onTap: () => _navigateToEntry(entry),
                      ),
                    );
                  }, childCount: _entries.length + 1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JournalCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback? onTap;

  const _JournalCard({required this.entry, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDraft = entry.isDraft;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(entry.mood, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.title,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            entry.formattedDate,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isDraft
                            ? entry.preview
                            : (entry.summary ?? entry.preview),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDraft
                                  ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withOpacity(0.5)
                                  : Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isDraft
                                      ? Icons.edit_note_rounded
                                      : Icons.auto_awesome_rounded,
                                  size: 12,
                                  color: isDraft
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isDraft ? 'Draft' : 'Finalized',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: isDraft
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.primary
                                            : Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Emotion badge for finalized entries
                          if (!isDraft && entry.emotionStatus != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getEmotionColor(
                                  entry.emotionStatus!,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                entry.emotionStatus!,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: _getEmotionColor(
                                        entry.emotionStatus!,
                                      ),
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      'motivated': Colors.amber.shade700,
      'grateful': Colors.pink,
      'hopeful': Colors.lightGreen,
      'overwhelmed': Colors.red,
    };
    return emotionColors[emotion.toLowerCase()] ?? Colors.purple;
  }
}

class _FinalizedEntrySheet extends StatelessWidget {
  final JournalEntry entry;

  const _FinalizedEntrySheet({required this.entry});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            entry.mood,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.formattedDate,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              if (entry.emotionStatus != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getEmotionColor(
                                      entry.emotionStatus!,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    entry.emotionStatus!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: _getEmotionColor(
                                            entry.emotionStatus!,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Risk Status
                    if (entry.riskStatus != null) ...[
                      _SectionCard(
                        icon: _getRiskIcon(entry.riskStatus!),
                        iconColor: _getRiskColor(entry.riskStatus!),
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
                                  entry.riskStatus!,
                                ).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                entry.riskStatus!.toUpperCase(),
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: _getRiskColor(entry.riskStatus!),
                                      letterSpacing: 0.5,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _getRiskDescription(entry.riskStatus!),
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
                      const SizedBox(height: 16),
                    ],

                    // AI Summary
                    if (entry.summary != null) ...[
                      _SectionCard(
                        icon: Icons.auto_awesome_rounded,
                        iconColor: Colors.amber,
                        title: 'AI Summary',
                        child: Text(
                          entry.summary!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(height: 1.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Action Items
                    if (entry.actionItems != null &&
                        entry.actionItems!.isNotEmpty) ...[
                      _SectionCard(
                        icon: Icons.lightbulb_outline_rounded,
                        iconColor: Colors.green,
                        title: 'Suggested Actions',
                        child: Column(
                          children: entry.actionItems!
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(height: 1.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Original Entry
                    _SectionCard(
                      icon: Icons.article_outlined,
                      iconColor: Theme.of(context).colorScheme.primary,
                      title: 'Original Entry',
                      child: Text(
                        entry.content,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
      'motivated': Colors.amber.shade700,
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

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
