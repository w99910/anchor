import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/responsive.dart';
import '../../services/appointment_service.dart';
import '../../main.dart' show appointmentService;
import 'choose_therapist_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  List<Appointment> _upcomingAppointments = [];

  @override
  void initState() {
    super.initState();
    _upcomingAppointments = appointmentService.upcomingAppointments;
    appointmentService.addListener(_onAppointmentsChange);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                Text(
                  l10n.getHelp,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.connectWithProfessionals,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Upcoming appointments section
                _buildAppointmentsSection(context, l10n),

                // Emergency card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emergency_rounded,
                        color: Colors.red[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.inCrisis,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[700],
                                  ),
                            ),
                            Text(
                              l10n.callEmergencyServices,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red[700]),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red[700],
                        ),
                        child: Text(l10n.call),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Text(
                  l10n.services,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                _ServiceCard(
                  emoji: '🧠',
                  title: l10n.therapistSession,
                  subtitle: l10n.oneOnOneWithTherapist,
                  price: '${l10n.from} \$80',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChooseTherapistPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _ServiceCard(
                  emoji: '💬',
                  title: l10n.mentalHealthConsultation,
                  subtitle: l10n.generalWellnessGuidance,
                  price: '${l10n.from} \$50',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChooseTherapistPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),
                Text(
                  l10n.resources,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),

                _ResourceTile(
                  icon: Icons.article_outlined,
                  title: l10n.articles,
                  onTap: () {},
                ),
                _ResourceTile(
                  icon: Icons.headphones_outlined,
                  title: l10n.guidedMeditations,
                  onTap: () {},
                ),
                _ResourceTile(
                  icon: Icons.phone_outlined,
                  title: l10n.crisisHotlines,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildAppointmentsSection(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    if (_upcomingAppointments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, l10n.yourAppointments),
        const SizedBox(height: 12),
        ..._upcomingAppointments
            .map((appointment) => _AppointmentCard(appointment: appointment))
            .toList(),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const _AppointmentCard({required this.appointment});

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
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
      return l10n.today;
    } else if (appointmentDate == tomorrow) {
      return l10n.tomorrow;
    }
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
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
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.video_call_rounded,
              color: Colors.white,
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
                      _formatDate(context, appointment.date),
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
          FilledButton.tonal(
            onPressed: () {},
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(
                0,
                36,
              ), // Override the infinite width default
            ),
            child: Text(l10n.join),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ResourceTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(title),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
