import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/resources/colors_manager.dart';

class TabItem extends StatelessWidget {
  const TabItem({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // var themeCubit = context.watch<ThemeCubit>();
    // final isLight = themeCubit.isLightTheme();
    return Tab(
      height: 44.h,
      child: Container(
        padding: REdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: ColorsManager.blue.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Center(
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}