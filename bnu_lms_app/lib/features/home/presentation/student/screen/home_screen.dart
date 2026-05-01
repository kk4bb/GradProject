
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/resources/assets_manager.dart';
import '../../../../courses/presentation/student/screens/courses_tab.dart';
import '../../../../forums/student/presentation/screens/forums_tab.dart';
import '../../../../profile/student/presentation/screens/profile_tab.dart';
import 'home_tab.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> tabs = [
    HomeTab(),
    CoursesTab(),
    ForumsTab(),
    ProfileTab(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, Routes.aiChat);
      },
        backgroundColor: Color(0xFF32C9E0),
        foregroundColor: Colors.white,
        child: ImageIcon(AssetImage(IconsManager.ai)),

        
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
