import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Model for mental health assessment results (PHQ-9, GAD-7)
class AssessmentResult {
  final int? id;
  final String type; // 'phq9' or 'gad7'
  final int score;
  final String status; // e.g., 'Minimal depression', 'Mild anxiety'
  final Map<int, int> answers; // Question index -> answer value
  final DateTime createdAt;

  AssessmentResult({
    this.id,
    required this.type,
    required this.score,
    required this.status,
    required this.answers,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Get display name for the assessment type
  String get displayType {
    switch (type) {
      case 'phq9':
        return 'Depression';
      case 'gad7':
        return 'Anxiety';
      default:
        return type;
    }
  }

  /// Get color based on score severity
  Color get statusColor {
    if (type == 'phq9') {
      // PHQ-9 thresholds
      if (score <= 4) return Colors.green;
      if (score <= 9) return Colors.lightGreen;
      if (score <= 14) return Colors.amber;
      if (score <= 19) return Colors.orange;
      return Colors.red;
    } else {
      // GAD-7 thresholds
      if (score <= 4) return Colors.green;
      if (score <= 9) return Colors.lightGreen;
      if (score <= 14) return Colors.amber;
      return Colors.red;
    }
  }

  /// Format the date for display
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final resultDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (resultDate == today) {
      return 'Today';
    } else if (resultDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[createdAt.month - 1]} ${createdAt.day}';
    }
  }

  Map<String, dynamic> toMap() {
    // Convert answers map to a string format: "0:1,1:2,2:0,..."
    final answersStr = answers.entries
        .map((e) => '${e.key}:${e.value}')
        .join(',');
    return {
      'id': id,
      'type': type,
      'score': score,
      'status': status,
      'answers': answersStr,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AssessmentResult.fromMap(Map<String, dynamic> map) {
    // Parse answers string back to map
    final answersStr = map['answers'] as String?;
    final answers = <int, int>{};
    if (answersStr != null && answersStr.isNotEmpty) {
      for (final pair in answersStr.split(',')) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          answers[int.parse(parts[0])] = int.parse(parts[1]);
        }
      }
    }
    return AssessmentResult(
      id: map['id'] as int?,
      type: map['type'] as String,
      score: map['score'] as int,
      status: map['status'] as String,
      answers: answers,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

/// Model for chat messages
class ChatMessage {
  final int? id;
  final String text;
  final bool isUser;
  final bool isError;
  final String mode; // 'friend' or 'therapist'
  final DateTime createdAt;

  ChatMessage({
    this.id,
    required this.text,
    required this.isUser,
    this.isError = false,
    required this.mode,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'is_user': isUser ? 1 : 0,
      'is_error': isError ? 1 : 0,
      'mode': mode,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int?,
      text: map['text'] as String,
      isUser: (map['is_user'] as int) == 1,
      isError: (map['is_error'] as int) == 1,
      mode: map['mode'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

/// Model for journal entries
class JournalEntry {
  final int? id;
  final String content;
  final String mood;
  final DateTime createdAt;
  final DateTime? lockedAt; // null means still editable (draft)

  // AI-generated analysis (populated when user finalizes the entry)
  final String? summary;
  final String? emotionStatus; // e.g., "Happy", "Anxious", "Reflective"
  final List<String>? actionItems;
  final String?
  riskStatus; // "high", "medium", "low" - mental health risk assessment

  // EthStorage transaction hash (populated after uploading to blockchain)
  final String? ethstorageTxHash;

  JournalEntry({
    this.id,
    required this.content,
    required this.mood,
    DateTime? createdAt,
    this.lockedAt,
    this.summary,
    this.emotionStatus,
    this.actionItems,
    this.riskStatus,
    this.ethstorageTxHash,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Whether this entry is a draft (not yet finalized with AI analysis)
  bool get isDraft => lockedAt == null;

  /// Whether this entry has been finalized with AI analysis
  bool get isFinalized => lockedAt != null;

  /// Check if the entry is still editable (draft and within 3 days of creation)
  bool get isEditable {
    if (lockedAt != null) return false; // Finalized entries are never editable
    final now = DateTime.now();
    final editableUntil = createdAt.add(const Duration(days: 3));
    return now.isBefore(editableUntil);
  }

  /// Generate a title from the content (first line or first few words)
  String get title {
    final firstLine = content.split('\n').first.trim();
    if (firstLine.length <= 40) return firstLine;
    return '${firstLine.substring(0, 37)}...';
  }

  /// Generate a preview from the content
  String get preview {
    final cleanContent = content.replaceAll('\n', ' ').trim();
    if (cleanContent.length <= 100) return cleanContent;
    return '${cleanContent.substring(0, 97)}...';
  }

  /// Format the date for display
  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[createdAt.month - 1]} ${createdAt.day}';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'mood': mood,
      'created_at': createdAt.toIso8601String(),
      'locked_at': lockedAt?.toIso8601String(),
      'summary': summary,
      'emotion_status': emotionStatus,
      'action_items': actionItems?.join('|||'), // Store as delimited string
      'risk_status': riskStatus,
      'ethstorage_tx_hash': ethstorageTxHash,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    final actionItemsStr = map['action_items'] as String?;
    return JournalEntry(
      id: map['id'] as int?,
      content: map['content'] as String,
      mood: map['mood'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      lockedAt: map['locked_at'] != null
          ? DateTime.parse(map['locked_at'] as String)
          : null,
      summary: map['summary'] as String?,
      emotionStatus: map['emotion_status'] as String?,
      actionItems: actionItemsStr != null && actionItemsStr.isNotEmpty
          ? actionItemsStr.split('|||')
          : null,
      riskStatus: map['risk_status'] as String?,
      ethstorageTxHash: map['ethstorage_tx_hash'] as String?,
    );
  }

  JournalEntry copyWith({
    int? id,
    String? content,
    String? mood,
    DateTime? createdAt,
    DateTime? lockedAt,
    String? summary,
    String? emotionStatus,
    List<String>? actionItems,
    String? riskStatus,
    String? ethstorageTxHash,
    bool clearLockedAt = false,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      createdAt: createdAt ?? this.createdAt,
      lockedAt: clearLockedAt ? null : (lockedAt ?? this.lockedAt),
      summary: summary ?? this.summary,
      emotionStatus: emotionStatus ?? this.emotionStatus,
      actionItems: actionItems ?? this.actionItems,
      riskStatus: riskStatus ?? this.riskStatus,
      ethstorageTxHash: ethstorageTxHash ?? this.ethstorageTxHash,
    );
  }
}

/// Singleton database service for managing local SQLite storage
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'anchor.db');

    debugPrint('DatabaseService: Initializing database at $path');

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('DatabaseService: Creating tables (version $version)...');

    // Create chat_messages table
    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        is_user INTEGER NOT NULL,
        is_error INTEGER NOT NULL DEFAULT 0,
        mode TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Create journal_entries table with AI analysis fields
    await db.execute('''
      CREATE TABLE journal_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        mood TEXT NOT NULL,
        created_at TEXT NOT NULL,
        locked_at TEXT,
        summary TEXT,
        emotion_status TEXT,
        action_items TEXT,
        risk_status TEXT,
        ethstorage_tx_hash TEXT
      )
    ''');

    // Create assessment_results table for PHQ-9 and GAD-7 results
    await db.execute('''
      CREATE TABLE assessment_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        score INTEGER NOT NULL,
        status TEXT NOT NULL,
        answers TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    debugPrint('DatabaseService: Tables created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint(
      'DatabaseService: Upgrading from version $oldVersion to $newVersion',
    );

    if (oldVersion < 2) {
      // Add AI analysis columns to journal_entries
      await db.execute('ALTER TABLE journal_entries ADD COLUMN summary TEXT');
      await db.execute(
        'ALTER TABLE journal_entries ADD COLUMN emotion_status TEXT',
      );
      await db.execute(
        'ALTER TABLE journal_entries ADD COLUMN action_items TEXT',
      );
      debugPrint('DatabaseService: Added AI analysis columns');
    }

    if (oldVersion < 3) {
      // Add risk_status column to journal_entries
      await db.execute(
        'ALTER TABLE journal_entries ADD COLUMN risk_status TEXT',
      );
      debugPrint('DatabaseService: Added risk_status column');
    }

    if (oldVersion < 4) {
      // Add ethstorage_tx_hash column to journal_entries
      await db.execute(
        'ALTER TABLE journal_entries ADD COLUMN ethstorage_tx_hash TEXT',
      );
      debugPrint('DatabaseService: Added ethstorage_tx_hash column');
    }

    if (oldVersion < 5) {
      // Create assessment_results table for PHQ-9 and GAD-7 results
      await db.execute('''
        CREATE TABLE assessment_results (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          score INTEGER NOT NULL,
          status TEXT NOT NULL,
          answers TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');
      debugPrint('DatabaseService: Created assessment_results table');
    }
  }

  // ==================== Chat Message Operations ====================

  /// Insert a new chat message
  Future<int> insertChatMessage(ChatMessage message) async {
    final db = await database;
    final id = await db.insert('chat_messages', message.toMap());
    debugPrint('DatabaseService: Inserted chat message with id $id');
    return id;
  }

  /// Get all chat messages for a specific mode, ordered by creation time
  Future<List<ChatMessage>> getChatMessages({String? mode}) async {
    final db = await database;

    List<Map<String, dynamic>> maps;
    if (mode != null) {
      maps = await db.query(
        'chat_messages',
        where: 'mode = ?',
        whereArgs: [mode],
        orderBy: 'created_at ASC',
      );
    } else {
      maps = await db.query('chat_messages', orderBy: 'created_at ASC');
    }

    debugPrint('DatabaseService: Retrieved ${maps.length} chat messages');
    return maps.map((map) => ChatMessage.fromMap(map)).toList();
  }

  /// Delete all chat messages for a specific mode
  Future<int> clearChatMessages({String? mode}) async {
    final db = await database;
    int count;
    if (mode != null) {
      count = await db.delete(
        'chat_messages',
        where: 'mode = ?',
        whereArgs: [mode],
      );
    } else {
      count = await db.delete('chat_messages');
    }
    debugPrint('DatabaseService: Deleted $count chat messages');
    return count;
  }

  // ==================== Journal Entry Operations ====================

  /// Insert a new journal entry
  Future<int> insertJournalEntry(JournalEntry entry) async {
    final db = await database;
    final id = await db.insert('journal_entries', entry.toMap());
    debugPrint('DatabaseService: Inserted journal entry with id $id');
    return id;
  }

  /// Get all journal entries, ordered by creation time (newest first)
  Future<List<JournalEntry>> getJournalEntries() async {
    final db = await database;
    final maps = await db.query('journal_entries', orderBy: 'created_at DESC');

    debugPrint('DatabaseService: Retrieved ${maps.length} journal entries');
    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }

  /// Get a specific journal entry by ID
  Future<JournalEntry?> getJournalEntry(int id) async {
    final db = await database;
    final maps = await db.query(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return JournalEntry.fromMap(maps.first);
  }

  /// Update a journal entry
  Future<int> updateJournalEntry(JournalEntry entry) async {
    if (entry.id == null) {
      throw ArgumentError('Cannot update entry without id');
    }

    final db = await database;
    final count = await db.update(
      'journal_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
    debugPrint('DatabaseService: Updated journal entry ${entry.id}');
    return count;
  }

  /// Delete a journal entry
  Future<int> deleteJournalEntry(int id) async {
    final db = await database;
    final count = await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('DatabaseService: Deleted journal entry $id');
    return count;
  }

  /// Finalize a journal entry with AI analysis results
  /// This locks the entry and stores the AI-generated summary, emotion, action items, and risk status
  Future<int> finalizeJournalEntry({
    required int id,
    required String summary,
    required String emotionStatus,
    required List<String> actionItems,
    required String riskStatus,
  }) async {
    final db = await database;
    final count = await db.update(
      'journal_entries',
      {
        'locked_at': DateTime.now().toIso8601String(),
        'summary': summary,
        'emotion_status': emotionStatus,
        'action_items': actionItems.join('|||'),
        'risk_status': riskStatus,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('DatabaseService: Finalized journal entry $id');
    return count;
  }

  /// Lock a journal entry without AI analysis
  /// This simply locks the entry so it can no longer be edited
  Future<int> lockJournalEntry(int id) async {
    final db = await database;
    final count = await db.update(
      'journal_entries',
      {'locked_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('DatabaseService: Locked journal entry $id');
    return count;
  }

  /// Update the EthStorage transaction hash for a journal entry
  Future<int> updateEthStorageTxHash(int id, String txHash) async {
    final db = await database;
    final count = await db.update(
      'journal_entries',
      {'ethstorage_tx_hash': txHash},
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('DatabaseService: Updated EthStorage tx hash for entry $id');
    return count;
  }

  /// Get only draft (non-finalized) journal entries
  Future<List<JournalEntry>> getDraftJournalEntries() async {
    final db = await database;
    final maps = await db.query(
      'journal_entries',
      where: 'locked_at IS NULL',
      orderBy: 'created_at DESC',
    );

    debugPrint(
      'DatabaseService: Retrieved ${maps.length} draft journal entries',
    );
    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }

  /// Get only finalized journal entries
  Future<List<JournalEntry>> getFinalizedJournalEntries() async {
    final db = await database;
    final maps = await db.query(
      'journal_entries',
      where: 'locked_at IS NOT NULL',
      orderBy: 'created_at DESC',
    );

    debugPrint(
      'DatabaseService: Retrieved ${maps.length} finalized journal entries',
    );
    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }

  // ==================== Assessment Result Operations ====================

  /// Insert a new assessment result (PHQ-9 or GAD-7)
  Future<int> insertAssessmentResult(AssessmentResult result) async {
    final db = await database;
    final id = await db.insert('assessment_results', result.toMap());
    debugPrint('DatabaseService: Inserted assessment result with id $id');
    return id;
  }

  /// Get all assessment results, ordered by creation time (newest first)
  Future<List<AssessmentResult>> getAssessmentResults({String? type}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (type != null) {
      maps = await db.query(
        'assessment_results',
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'created_at DESC',
      );
    } else {
      maps = await db.query('assessment_results', orderBy: 'created_at DESC');
    }

    debugPrint('DatabaseService: Retrieved ${maps.length} assessment results');
    return maps.map((map) => AssessmentResult.fromMap(map)).toList();
  }

  /// Get a specific assessment result by ID
  Future<AssessmentResult?> getAssessmentResult(int id) async {
    final db = await database;
    final maps = await db.query(
      'assessment_results',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return AssessmentResult.fromMap(maps.first);
  }

  /// Delete an assessment result
  Future<int> deleteAssessmentResult(int id) async {
    final db = await database;
    final count = await db.delete(
      'assessment_results',
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('DatabaseService: Deleted assessment result $id');
    return count;
  }

  /// Get the latest assessment result for a specific type
  Future<AssessmentResult?> getLatestAssessmentResult(String type) async {
    final db = await database;
    final maps = await db.query(
      'assessment_results',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'created_at DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return AssessmentResult.fromMap(maps.first);
  }

  /// Close the database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
