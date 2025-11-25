
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/language_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/app_sizes.dart';
import 'category_box.dart';

class QuickAccessList extends StatelessWidget {
  const QuickAccessList({super.key, required this.categoryItem});
  final List<Map<String, dynamic>> categoryItem;

  @override
  Widget build(BuildContext context) {
    // Get theme and language
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    var languageCubit = Provider.of<LanguageProvider>(context);
    final currentLang = languageCubit.currentLanguage;

    return Padding(
      padding: REdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPadding,
          vertical: AppSizes.verticalSectionSpacing
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1,
        ),
        itemCount: categoryItem.length,
        itemBuilder: (context, index) {
          final item = categoryItem[index];
          return CategoryBox(
            imagePath: item['icon'],
            title: item['title'],
            isLight: isLight,
            isArabic: currentLang == 'ar',
          );
        },
      ),
    );
  }
}