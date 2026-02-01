import 'package:anchor/pages/help/help_page.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/database_service.dart';
import '../../utils/confetti_overlay.dart';
import '../../utils/responsive.dart';

class Gad7ResultsPage extends StatefulWidget {
  final Map<int, int> answers;

  const Gad7ResultsPage({super.key, required this.answers});

  @override
  State<Gad7ResultsPage> createState() => _Gad7ResultsPageState();
}

class _Gad7ResultsPageState extends State<Gad7ResultsPage> {
  final _databaseService = DatabaseService();
  late final ConfettiController _confettiController;
  bool _saved = false;

  int get _score {
    if (widget.answers.isEmpty) return 0;
    final total = widget.answers.values.reduce((a, b) => a + b);
    return total;
  }

  String _getStatus(AppLocalizations l10n) {
    if (_score <= 4) return l10n.minimalAnxiety;
    if (_score <= 9) return l10n.mildAnxiety;
    if (_score <= 14) return l10n.moderateAnxiety;
    return l10n.severeAnxiety;
  }

  // For database storage (English only)
  String get _statusForDb {
    if (_score <= 4) return 'Minimal anxiety';
    if (_score <= 9) return 'Mild anxiety';
    if (_score <= 14) return 'Moderate anxiety';
    return 'Severe anxiety';
  }

  Color get _statusColor {
    if (_score <= 4) return Colors.green;
    if (_score <= 9) return Colors.lightGreen;
    if (_score <= 14) return Colors.amber;
    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _saveResult();
    // Celebrate for minimal or mild anxiety
    if (_score <= 9) {
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

  Future<void> _saveResult() async {
    if (_saved) return;
    final result = AssessmentResult(
      type: 'gad7',
      score: _score,
      status: _statusForDb,
      answers: widget.answers,
    );
    await _databaseService.insertAssessmentResult(result);
    _saved = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: ResponsiveCenter(
              maxWidth: 500,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),

                  // Score display
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusColor.withOpacity(0.1),
                      border: Border.all(color: _statusColor, width: 6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_score',
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _statusColor,
                              ),
                        ),
                        Text(
                          _getStatus(l10n),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: _statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    l10n.gad7ResultsTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getDescription(l10n),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Recommendations
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.suggestions,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._getRecommendations(l10n).map(
                          (rec) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    rec,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  FilledButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: Text(l10n.done),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpPage()),
                      );
                    },
                    child: Text(l10n.talkToProfessional),
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

  String _getDescription(AppLocalizations l10n) {
    if (_score <= 4) {
      return l10n.gad7DescMinimal;
    }
    if (_score <= 9) {
      return l10n.gad7DescMild;
    }
    if (_score <= 14) {
      return l10n.gad7DescModerate;
    }
    return l10n.gad7DescSevere;
  }

  List<String> _getRecommendations(AppLocalizations l10n) {
    return [
      l10n.recPracticeMindfulness,
      l10n.recPhysicalActivity,
      l10n.recHealthySleep,
      l10n.recTalkToFriends,
    ];
  }
}
