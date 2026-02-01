import 'package:flutter/foundation.dart';

/// A simple notifier to signal when journal entries have been updated.
/// Used to refresh the journal list when entries are created/modified from
/// pages that don't directly return to the journal page.
class JournalNotifier extends ChangeNotifier {
  static final JournalNotifier _instance = JournalNotifier._internal();
  factory JournalNotifier() => _instance;
  JournalNotifier._internal();

  /// Notify listeners that journal entries have been updated.
  /// Call this after creating, editing, or deleting a journal entry.
  void notifyJournalUpdated() {
    notifyListeners();
  }
}

/// Global instance for easy access
final journalNotifier = JournalNotifier();
