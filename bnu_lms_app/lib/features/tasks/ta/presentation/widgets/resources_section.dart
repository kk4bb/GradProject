import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';

class ResourcesSection extends StatelessWidget {
  const ResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildResourceCard(context, Icons.menu_book_rounded, 'Syllabus')),
        SizedBox(width: 16.w),
        Expanded(child: _buildResourceCard(context, Icons.people_alt_rounded, 'Student List')),
      ],
    );
  }

  Widget _buildResourceCard(BuildContext context, IconData icon, String label) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = Color(0xFF2FBAD7);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        children: [
          Icon(icon, color: cyan, size: 32.sp),
          SizedBox(height: 12.h),
          Text(
            label,
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium)
                .copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}