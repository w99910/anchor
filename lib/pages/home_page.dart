import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import '../services/appointment_service.dart';
import '../services/database_service.dart';
import '../main.dart' show appointmentService;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Appointment> _upcomingAppointments = [];

  // Stats data
  int _journalEntriesThisWeek = 0;
  int _chatSessionsThisWeek = 0;
  double _avgMood = 0.0;
  int _streak = 0;
  String _stressLevel = 'Unknown';

  // Previous week data for trends
  int _prevWeekJournalEntries = 0;
  double _prevWeekAvgMood = 0.0;
  int _prevWeekChatSessions = 0;
  String _prevWeekStressLevel = 'Unknown';

  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _upcomingAppointments = appointmentService.upcomingAppointments;
    appointmentService.addListener(_onAppointmentsChange);
    _loadStats();
  }

  @override
  void dispose() {
    appointmentService.removeListener(_onAppointmentsChange);
    super.dispose();
  }

  void _onAppointmentsChange() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _upcomingAppointments = appointmentService.upcomingAppointments;
          });
        }
      });
    }
  }

  Future<void> _loadStats() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final startOfPrevWeek = startOfWeekDate.subtract(const Duration(days: 7));

    // Load journal entries
    final journalEntries = await _databaseService.getJournalEntries();

    // Filter entries for this week and last week
    final thisWeekEntries = journalEntries
        .where(
          (e) =>
              e.createdAt.isAfter(startOfWeekDate) ||
              (e.createdAt.year == startOfWeekDate.year &&
                  e.createdAt.month == startOfWeekDate.month &&
                  e.createdAt.day == startOfWeekDate.day),
        )
        .toList();

    final prevWeekEntries = journalEntries
        .where(
          (e) =>
              e.createdAt.isAfter(startOfPrevWeek) &&
              e.createdAt.isBefore(startOfWeekDate),
        )
        .toList();

    // Calculate average mood (convert emoji to number)
    double calculateAvgMood(List<JournalEntry> entries) {
      if (entries.isEmpty) return 0.0;
      double total = 0;
      for (final entry in entries) {
        total += _moodToNumber(entry.mood);
      }
      return total / entries.length;
    }

    // Calculate stress level from entries
    String calculateStressLevel(List<JournalEntry> entries) {
      if (entries.isEmpty) return 'Unknown';
      final avgMood = calculateAvgMood(entries);
      if (avgMood >= 4) return 'Low';
      if (avgMood >= 3) return 'Medium';
      return 'High';
    }

    // Calculate streak (consecutive days with entries)
    int calculateStreak() {
      if (journalEntries.isEmpty) return 0;

      int streak = 0;
      DateTime checkDate = DateTime(now.year, now.month, now.day);

      // Group entries by date
      final entriesByDate = <String, bool>{};
      for (final entry in journalEntries) {
        final dateKey =
            '${entry.createdAt.year}-${entry.createdAt.month}-${entry.createdAt.day}';
        entriesByDate[dateKey] = true;
      }

      // Check today first, if no entry today, start from yesterday
      final todayKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      if (!entriesByDate.containsKey(todayKey)) {
        checkDate = checkDate.subtract(const Duration(days: 1));
      }

      // Count consecutive days
      while (true) {
        final dateKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
        if (entriesByDate.containsKey(dateKey)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }

      return streak;
    }

    // Load chat messages and count unique sessions (by day)
    final chatMessages = await _databaseService.getChatMessages();

    int countChatSessions(DateTime start, DateTime end) {
      final sessionDays = <String>{};
      for (final msg in chatMessages) {
        if (msg.isUser &&
            msg.createdAt.isAfter(start) &&
            msg.createdAt.isBefore(end)) {
          final dateKey =
              '${msg.createdAt.year}-${msg.createdAt.month}-${msg.createdAt.day}';
          sessionDays.add(dateKey);
        }
      }
      return sessionDays.length;
    }

    if (mounted) {
      setState(() {
        _journalEntriesThisWeek = thisWeekEntries.length;
        _prevWeekJournalEntries = prevWeekEntries.length;
        _avgMood = calculateAvgMood(thisWeekEntries);
        _prevWeekAvgMood = calculateAvgMood(prevWeekEntries);
        _stressLevel = calculateStressLevel(thisWeekEntries);
        _prevWeekStressLevel = calculateStressLevel(prevWeekEntries);
        _streak = calculateStreak();
        _chatSessionsThisWeek = countChatSessions(
          startOfWeekDate,
          now.add(const Duration(days: 1)),
        );
        _prevWeekChatSessions = countChatSessions(
          startOfPrevWeek,
          startOfWeekDate,
        );
      });
    }
  }

  double _moodToNumber(String mood) {
    // Map mood emojis to numbers (1-5 scale)
    switch (mood) {
      case '😊':
        return 5.0;
      case '🙂':
        return 4.0;
      case '😐':
        return 3.0;
      case '😔':
        return 2.0;
      case '😢':
        return 1.0;
      default:
        return 3.0; // Default to neutral
    }
  }

  String _numberToMoodEmoji(double value) {
    // Convert average mood number back to nearest emoji
    if (value >= 4.5) return '😊';
    if (value >= 3.5) return '🙂';
    if (value >= 2.5) return '😐';
    if (value >= 1.5) return '😔';
    return '😢';
  }

  String _formatMoodTrend() {
    if (_prevWeekAvgMood == 0) return 'New';
    final diff = _avgMood - _prevWeekAvgMood;
    if (diff > 0) return '+${diff.toStringAsFixed(1)}';
    if (diff < 0) return diff.toStringAsFixed(1);
    return '0';
  }

  String _formatJournalTrend() {
    final diff = _journalEntriesThisWeek - _prevWeekJournalEntries;
    if (diff > 0) return '+$diff';
    if (diff < 0) return '$diff';
    return '0';
  }

  String _formatChatTrend() {
    final diff = _chatSessionsThisWeek - _prevWeekChatSessions;
    if (diff > 0) return '+$diff';
    if (diff < 0) return '$diff';
    return '0';
  }

  String _formatStressTrend() {
    if (_prevWeekStressLevel == 'Unknown') return 'New';
    if (_stressLevel == _prevWeekStressLevel) return 'Stable';

    final stressLevels = {'Low': 1, 'Medium': 2, 'High': 3, 'Unknown': 2};
    final current = stressLevels[_stressLevel] ?? 2;
    final previous = stressLevels[_prevWeekStressLevel] ?? 2;

    if (current < previous) return 'Improved';
    return 'Worsened';
  }

  bool _isStressTrendPositive() {
    final trend = _formatStressTrend();
    return trend == 'Improved' || trend == 'Stable' || trend == 'New';
  }

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: ResponsiveCenter(
            maxWidth: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildGreeting(context),
                const SizedBox(height: 32),
                _buildQuickMood(context),

                // Upcoming appointments section
                _buildAppointmentsSection(context),

                const SizedBox(height: 32),
                _buildSectionTitle(context, 'This Week'),
                const SizedBox(height: 16),
                _buildStats(context),
                const SizedBox(height: 32),
                _buildStreakCard(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection(BuildContext context) {
    if (_upcomingAppointments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        _buildSectionTitle(context, 'Upcoming Appointments'),
        const SizedBox(height: 16),
        ..._upcomingAppointments.take(3).map((appointment) {
          return _AppointmentCard(appointment: appointment);
        }).toList(),
      ],
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'How are you today?',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildQuickMood(BuildContext context) {
    final moods = [
      ('😊', 'Great'),
      ('🙂', 'Good'),
      ('😐', 'Okay'),
      ('😔', 'Low'),
      ('😢', 'Sad'),
    ];

    return Row(
      children: moods.map((mood) {
        return Expanded(
          child: _MoodButton(emoji: mood.$1, label: mood.$2),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _StatTile(
                value: _avgMood > 0 ? _numberToMoodEmoji(_avgMood) : '--',
                label: 'Avg. Mood',
                trend: _formatMoodTrend(),
                isPositive: _avgMood >= _prevWeekAvgMood,
                isEmoji: _avgMood > 0,
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _StatTile(
                value: '$_journalEntriesThisWeek',
                label: 'Journal Entries',
                trend: _formatJournalTrend(),
                isPositive: _journalEntriesThisWeek >= _prevWeekJournalEntries,
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _StatTile(
                value: '$_chatSessionsThisWeek',
                label: 'Chat Sessions',
                trend: _formatChatTrend(),
                isPositive: _chatSessionsThisWeek >= _prevWeekChatSessions,
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _StatTile(
                value: _stressLevel,
                label: 'Stress Level',
                trend: _formatStressTrend(),
                isPositive: _isStressTrendPositive(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    if (_streak == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('✨', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start your streak!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Write a journal entry to begin',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('🔥', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_streak day${_streak == 1 ? '' : ''} streak!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _streak >= 7
                      ? 'Amazing consistency! Keep it up!'
                      : 'Keep the momentum going',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;

  const _MoodButton({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final String trend;
  final bool isPositive;
  final bool isEmoji;

  const _StatTile({
    required this.value,
    required this.label,
    required this.trend,
    required this.isPositive,
    this.isEmoji = false,
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
          Text(
            value,
            style: isEmoji
                ? const TextStyle(fontSize: 28)
                : Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trend,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isPositive ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentCard({required this.appointment});

  String _formatDate(DateTime date) {
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
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final appointmentDate = DateTime(date.year, date.month, date.day);

    if (appointmentDate == DateTime(now.year, now.month, now.day)) {
      return 'Today';
    } else if (appointmentDate == tomorrow) {
      return 'Tomorrow';
    }
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.video_call_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.therapistName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(appointment.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appointment.time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (appointment.paymentMethod == 'crypto')
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF627EEA), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.diamond_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
