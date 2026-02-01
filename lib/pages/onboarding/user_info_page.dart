import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/user_info_service.dart';
import '../../utils/responsive.dart';
import 'personalized_questions_page.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _nameController = TextEditingController();
  String? _selectedGenderKey;
  int? _selectedYear;

  List<int> get _years {
    final currentYear = DateTime.now().year;
    return List.generate(80, (index) => currentYear - index - 13);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canContinue =>
      _nameController.text.isNotEmpty &&
      _selectedGenderKey != null &&
      _selectedYear != null;

  Future<void> _continue() async {
    if (_canContinue) {
      // Save user info
      await UserInfoService().saveUserInfo(
        name: _nameController.text.trim(),
        gender: _selectedGenderKey!,
        birthYear: _selectedYear!,
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PersonalizedQuestionsPage()),
      );
    }
  }

  String _getGenderLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'male':
        return l10n.male;
      case 'female':
        return l10n.female;
      case 'nonBinary':
        return l10n.nonBinary;
      case 'preferNotToSay':
        return l10n.preferNotToSay;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final genderKeys = ['male', 'female', 'nonBinary', 'preferNotToSay'];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveCenter(
            maxWidth: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  l10n.aboutYou,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.helpPersonalizeExperience,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 48),

                _buildLabel(context, l10n.whatShouldWeCallYou),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: l10n.enterNameOrNickname,
                  ),
                ),
                const SizedBox(height: 24),

                _buildLabel(context, l10n.birthYear),
                const SizedBox(height: 8),
                _YearSelector(
                  years: _years,
                  selectedYear: _selectedYear,
                  onChanged: (year) => setState(() => _selectedYear = year),
                ),
                const SizedBox(height: 24),

                _buildLabel(context, l10n.gender),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: genderKeys.map((key) {
                    final isSelected = _selectedGenderKey == key;
                    return ChoiceChip(
                      label: Text(_getGenderLabel(context, key)),
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => _selectedGenderKey = key),
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _canContinue ? _continue : null,
                    child: Text(l10n.continueText),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
    );
  }
}

class _YearSelector extends StatelessWidget {
  final List<int> years;
  final int? selectedYear;
  final ValueChanged<int> onChanged;

  const _YearSelector({
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => _showYearPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedYear?.toString() ?? l10n.selectYear,
                style: TextStyle(
                  color: selectedYear != null
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.selectBirthYear,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];
                  final isSelected = year == selectedYear;
                  return ListTile(
                    title: Text(
                      year.toString(),
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : null,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      onChanged(year);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
