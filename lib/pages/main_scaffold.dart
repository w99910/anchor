import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../utils/responsive.dart';
import 'home_page.dart';
import 'journaling/journaling_page.dart';
import 'ai_chat_page.dart';
import 'mental_state/mental_state_page.dart';
import 'help/help_page.dart';
import 'settings_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    JournalingPage(),
    AiChatPage(),
    MentalStatePage(),
    HelpPage(),
    SettingsPage(),
  ];

  List<_NavItem> _getNavItems(AppLocalizations l10n) => [
    _NavItem(Icons.home_outlined, Icons.home_rounded, l10n.home),
    _NavItem(Icons.edit_note_outlined, Icons.edit_note_rounded, l10n.journal),
    _NavItem(
      Icons.chat_bubble_outline_rounded,
      Icons.chat_bubble_rounded,
      l10n.chat,
    ),
    _NavItem(Icons.insights_outlined, Icons.insights_rounded, l10n.insights),
    _NavItem(Icons.support_outlined, Icons.support_rounded, l10n.help),
    _NavItem(Icons.settings_outlined, Icons.settings_rounded, l10n.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navItems = _getNavItems(l10n);
    final isWide =
        Responsive.isTablet(context) || Responsive.isDesktop(context);

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => _currentIndex = index),
              labelType: NavigationRailLabelType.all,
              destinations: navItems.map((item) {
                return NavigationRailDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon),
                  label: Text(item.label),
                );
              }).toList(),
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: _pages[_currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: navItems.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem(this.icon, this.selectedIcon, this.label);
}
