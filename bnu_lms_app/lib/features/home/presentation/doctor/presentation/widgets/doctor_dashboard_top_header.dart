import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import 'doctor_dashboard_header.dart';

class DoctorDashboardTopHeader extends StatelessWidget {
  const DoctorDashboardTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DoctorDashboardHeader(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}