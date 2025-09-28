import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/screens/posts/posts_screen.dart';
import 'package:flutter_test_dev/screens/home/user_profile/profile_icon_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    
    final tabs = <Widget>[
      PostsScreen(),
      Center(child: Text(loc.tab2)),
      Center(child: Text(loc.tab3)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.homeTitle),
        actions: const [
          ProfileIconButton(),
        ],
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: loc.tabHome),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: loc.tabSearch),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: loc.tabSettings),
        ],
      ),
    );
  }
}


