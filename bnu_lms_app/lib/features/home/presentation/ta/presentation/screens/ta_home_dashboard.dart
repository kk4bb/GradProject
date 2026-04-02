import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';
import '../../../../../../shared/resources/app_sizes.dart';


import '../../../doctor/presentation/widgets/doctor_dashboard_header.dart';
import '../widgets/ta_stats_grid.dart';
import '../widgets/urgent_actions_section.dart';
import '../widgets/todays_schedule_section.dart';

class TaHomeDashboard extends StatelessWidget {
  const TaHomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Reused Header (This keeps the white container + date pill look)
          // We can use the DoctorDashboardTopHeader directly if the text inside
          // isn't hardcoded to "Dr.". If it is, we wrap DoctorDashboardHeader manually.
          const _TaHeaderWrapper(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // 2. Stats Grid (Labs, Grading, Forums)
              const TaStatsGrid(),

              SizedBox(height: AppSizes.largeSpacing),

              // 3. Urgent Actions (Red/Blue cards)
              const UrgentActionsSection(),

              SizedBox(height: AppSizes.mediumSpacing),

              // 4. Timeline Schedule
              const TodaysScheduleSection(),

              SizedBox(height: 40.h), // Bottom padding
            ],
          ),
        ],
      ),
    );
  }
}

// Local wrapper to replicate the visual style of DoctorDashboardTopHeader
// but allowing us to swap the inner content if needed.
class _TaHeaderWrapper extends StatelessWidget {
  const _TaHeaderWrapper();

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Container(
      height: 170.h,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 24.w,
        right: 24.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: isLight
            ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reuse the internal content widget (Avatar + Name)
          // Ideally, this widget accepts a name parameter.
          // If not, creates a TaDashboardHeader similar to DoctorDashboardHeader.
          const DoctorDashboardHeader(),

          SizedBox(height: 14.h),

          // Date Pill (Cyan for TA)
          Container(
            padding: REdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFE0F7FA) : ColorsManager.darkBlue, // Cyan tint
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 16.sp,
                  color: const Color(0xFF2FBAD7), // TA Cyan
                ),
                SizedBox(width: 6.w),
                // We can fetch dynamic date here later
                Text(
                  'Tuesday, 24 Oct 2023',
                  style: isLight
                      ? TextStyle(fontSize: 12.sp, color: Colors.black87, fontWeight: FontWeight.w500)
                      : TextStyle(fontSize: 12.sp, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}