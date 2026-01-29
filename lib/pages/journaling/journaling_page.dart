import 'package:flutter/material.dart';
import 'create_journal_page.dart';

class JournalingPage extends StatelessWidget {
  const JournalingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Quick Journal Button
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateJournalPage()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_note,
                      size: 40,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write a new entry',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                          Text(
                            'Express your thoughts and feelings',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Entries
          Text(
            'Recent Entries',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Sample journal entries
          _JournalEntryCard(
            title: 'Feeling grateful today',
            preview:
                'Had a wonderful day with family. The weather was perfect and...',
            date: 'Today, 2:30 PM',
            mood: '😊',
            isLocked: false,
            isEditable: true,
          ),
          _JournalEntryCard(
            title: 'Work reflections',
            preview:
                'The project meeting went better than expected. I\'m proud of...',
            date: 'Yesterday, 9:15 PM',
            mood: '💪',
            isLocked: false,
            isEditable: true,
          ),
          _JournalEntryCard(
            title: 'Weekend thoughts',
            preview:
                'Spent time reading and relaxing. Sometimes doing nothing is...',
            date: 'Jan 25, 2026',
            mood: '😌',
            isLocked: true,
            isEditable: false,
          ),
          _JournalEntryCard(
            title: 'Challenging day',
            preview:
                'Things didn\'t go as planned, but I learned some valuable...',
            date: 'Jan 22, 2026',
            mood: '🤔',
            isLocked: true,
            isEditable: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateJournalPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Entry'),
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final String title;
  final String preview;
  final String date;
  final String mood;
  final bool isLocked;
  final bool isEditable;

  const _JournalEntryCard({
    required this.title,
    required this.preview,
    required this.date,
    required this.mood,
    required this.isLocked,
    required this.isEditable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to view/edit entry
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(mood, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isLocked)
                    Icon(
                      Icons.lock,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  if (isEditable)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Editable',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                preview,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
