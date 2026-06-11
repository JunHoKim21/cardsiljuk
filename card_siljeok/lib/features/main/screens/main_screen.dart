import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cards/screens/cards_screen.dart';
import '../../transactions/screens/transactions_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import 'settings_screen.dart';
import '../widgets/home_screen.dart';
import '../../sync/widgets/sync_status_bar.dart';
import 'package:card_siljeok/services/parser/providers/parser_provider.dart';
import '../../simulator/screens/simulator_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parserProvider).initialize();
    });
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionsScreen(),
    const AnalyticsScreen(),
    const SimulatorScreen(),
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
            icon: Icon(Icons.calculate_outlined, color: cs.onSurfaceVariant),
            selectedIcon: Icon(Icons.calculate, color: cs.secondary),
            label: '시뮬레이터',
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
