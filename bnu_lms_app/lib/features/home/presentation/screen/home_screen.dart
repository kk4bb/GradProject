
import 'package:bnu_lms_app/features/home/presentation/screen/home_tab.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../attendance/presentation/screens/courses_tab.dart';
import '../../../forums/presentation/screens/messages_tab.dart';
import '../../../profile/presentation/screens/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> tabs = [
    HomeTab(),
    CoursesTab(),
    MessagesTab(),
    ProfileTab(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(onPressed: () {},
        backgroundColor: ColorsManager.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.headphones),

        
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.home,
          ),
           BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(IconsManager.courses)),
            label: localizations.courses,
          ),
           BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(IconsManager.message)),
            label: localizations.forums,
          ),
           BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(IconsManager.profile)),
            label: localizations.profile,
          ),
        ],
      ),
    );
  }
}
