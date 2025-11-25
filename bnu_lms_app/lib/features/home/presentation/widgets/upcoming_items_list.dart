import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';


import '../../../../shared/providers/language_provider.dart';
import '../../../../shared/providers/theme_provider.dart';
import 'content_box.dart';

class UpcomingItemsList extends StatelessWidget {
  const UpcomingItemsList({super.key, required this.upcomingItems});
  final List<Map<String, dynamic>> upcomingItems;

  @override
  Widget build(BuildContext context) {
    // Get theme and language
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    var languageCubit = context.watch<LanguageProvider>();
    final currentLang = languageCubit.currentLanguage;
    return ListView.separated(
      padding: EdgeInsets.zero,
      // Add this line
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: upcomingItems.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = upcomingItems[index];
        return Slidable(
          key: ValueKey(index),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            // dismissible: DismissiblePane(onDismissed: () {
            //   setState(() {
            //     // upcomingItems.removeAt(index);
            //   });
            // }),
            children: [
              SlidableAction(
                onPressed: (context) {
                  // setState(() {
                  //   upcomingItems.removeAt(index);
                  // });
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                borderRadius: BorderRadius.circular(18.r),
              ),
            ],
          ),
          child: ContentBox(
            isLight: isLight,
            isArabic: currentLang == 'ar',
            icon: item['icon'],
            title: item['title'],
            subtitle: item['subtitle'],
          ),
        );
      },
    );
  }
}
