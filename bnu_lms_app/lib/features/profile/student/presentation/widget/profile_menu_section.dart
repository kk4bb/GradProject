import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';


class ProfileMenuItem {
  final String icon;
  final String label;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class ProfileMenuSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuItem> items;

  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: REdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: isLight
                ? AppLightTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            )
                : AppDarkTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                MenuItemRow(item: items[i]),
                if (i < items.length - 1)
                  Divider(
                    height: 1,
                    indent: 70.w,
                    endIndent: 16.w,
                    color: isLight
                        ? ColorsManager.grayMedium.withValues(alpha: 0.2)
                        : ColorsManager.darkTextSecondary.withValues(alpha: 0.2),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class MenuItemRow extends StatelessWidget {
  final ProfileMenuItem item;

  const MenuItemRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isLight
                    ? ColorsManager.lightBlueAccent
                    : ColorsManager.darkBackground,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Image.asset(
                  item.icon,
                  width: 22.w,
                  height: 22.w,
                  color: ColorsManager.blue,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                item.label,
                style: isLight
                    ? AppLightTextStyles.labelMedium.copyWith(
                  color: ColorsManager.black,
                  fontWeight: FontWeight.w500,
                )
                    : AppDarkTextStyles.labelMedium.copyWith(
                  color: ColorsManager.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: ColorsManager.grayMedium,
            ),
          ],
        ),
      ),
    );
  }
}