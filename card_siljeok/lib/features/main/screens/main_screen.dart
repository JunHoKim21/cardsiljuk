import 'package:flutter/material.dart';
import '../../cards/screens/cards_screen.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import 'settings_screen.dart';
import '../widgets/home_screen.dart';
import '../../sync/widgets/sync_status_bar.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionsScreen(),
    const AnalyticsScreen(),
    const CardsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SyncStatusBar(),
            Expanded(child: _screens[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: cs.surface,
        indicatorColor: cs.secondaryContainer.withValues(alpha: 0.6),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: cs.onSurfaceVariant),
            selectedIcon: Icon(Icons.home, color: cs.secondary),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined, color: cs.onSurfaceVariant),
            selectedIcon: Icon(Icons.list_alt, color: cs.secondary),
            label: '내역',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline, color: cs.onSurfaceVariant),
            selectedIcon: Icon(Icons.pie_chart, color: cs.secondary),
            label: '통계',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined, color: cs.onSurfaceVariant),
            selectedIcon: Icon(Icons.credit_card, color: cs.secondary),
            label: '카드',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: cs.onSurfaceVariant),
            selectedIcon: Icon(Icons.settings, color: cs.secondary),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
