import 'package:bnu_lms_app/features/courses/presentation/doctor/presentation/screens/doctor_courses_tab.dart';
import 'package:bnu_lms_app/features/home/presentation/doctor/presentation/screens/doctor_home_dashboard.dart';
import 'package:bnu_lms_app/features/profile/doctor/presentation/screens/doctor_profile_tab.dart';
import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/resources/assets_manager.dart';

import '../../../../../forums/student/presentation/screens/forums_tab.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {

  int selectedIndex = 0;


  final List<Widget> tabs = const [
    DoctorHomeDashboard(),
    DoctorCoursesTab(),
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