import 'package:bnu_lms_app/features/home/presentation/ta/presentation/screens/ta_home_dashboard.dart';
import 'package:flutter/material.dart';


import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/resources/assets_manager.dart';
import '../../../../../courses/presentation/doctor/presentation/screens/doctor_courses_tab.dart';
import '../../../../../forums/presentation/student/presentation/screens/forums_tab.dart';
import '../../../../../profile/doctor/presentation/screens/doctor_profile_tab.dart';
import '../../../../../tasks/ta/presentation/screens/ta_tasks_tab.dart';

class TaHomeScreen extends StatefulWidget {
  const TaHomeScreen({super.key});

  @override
  State<TaHomeScreen> createState() => _TaHomeScreenState();
}

class _TaHomeScreenState extends State<TaHomeScreen> {
  int selectedIndex = 0;


  final List<Widget> tabs = [
    TaHomeDashboard(),
    DoctorCoursesTab(),
    TaTasksTab(),
    ForumsTab(),
    DoctorProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: tabs[selectedIndex],
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
            icon: const ImageIcon(AssetImage(IconsManager.dashboard)),
            label: localizations.home,
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(AssetImage(IconsManager.courses)),
            label: localizations.courses,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.task_alt_sharp),
            label: localizations.tasks,
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