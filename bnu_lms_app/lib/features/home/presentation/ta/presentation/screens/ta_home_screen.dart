import 'package:bnu_lms_app/features/home/presentation/ta/presentation/screens/ta_home_dashboard.dart';
import 'package:flutter/material.dart';


import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/resources/assets_manager.dart';
import '../../../../../courses/presentation/doctor/presentation/screens/doctor_courses_tab.dart';
import '../../../../../forums/presentation/student/presentation/screens/forums_tab.dart';
import '../../../../../profile/doctor/presentation/screens/doctor_profile_tab.dart';
import '../../../../../../shared/di/injection.dart';
import '../../../../../profile/presentation/cubit/profile_cubit.dart';

class TaHomeScreen extends StatefulWidget {
  const TaHomeScreen({super.key});

  @override
  State<TaHomeScreen> createState() => _TaHomeScreenState();
}

class _TaHomeScreenState extends State<TaHomeScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Pre-fetch profile so avatar is ready for header immediately
    Future.microtask(() => getIt<ProfileCubit>().fetchProfile());
  }


  final List<Widget> tabs = [
    TaHomeDashboard(),
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