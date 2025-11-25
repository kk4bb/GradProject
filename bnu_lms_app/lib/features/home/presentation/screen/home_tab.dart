
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/app_sizes.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../widgets/home_header.dart';
import '../widgets/quck_access_list.dart';
import '../widgets/upcoming_items_list.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Sample data for upcoming items
  final List<Map<String, dynamic>> upcomingItems = [
    {
      'icon': Icons.assignment,
      'title': 'Assignment Due',
      'subtitle': 'Mathematics - Chapter 5',
    },
    {
      'icon': Icons.video_library,
      'title': 'Live Class',
      'subtitle': 'Physics - Thermodynamics',
    },
    {
      'icon': Icons.quiz,
      'title': 'Quiz Tomorrow',
      'subtitle': 'English Literature',
    },
    {
      'icon': Icons.book,
      'title': 'Reading Material',
      'subtitle': 'History - World War II',
    },
  ];

  List<Map<String, dynamic>> getCategoryItems(AppLocalizations localizations) {
    return [
      {
        'icon': IconsManager.courses,
        'title': localizations.courses,
      },
      {
        'icon': IconsManager.calendar,
        'title': localizations.calendar,
      },
      {
        'icon': IconsManager.quiz,
        'title': localizations.quiz,
      },
      {
        'icon': IconsManager.grades,
        'title': localizations.grades,
      },
      {
        'icon': IconsManager.attendance,
        'title': localizations.attendance,
      },
      {
        'icon': IconsManager.gate,
        'title': localizations.entrance,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Get theme and language state inside build method
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    // var languageCubit = context.watch<LanguageCubit>();
    // final currentLang = languageCubit.state;

    // Get localization
    final localizations = AppLocalizations.of(context)!;

    // Get category items with localized titles
    final categoryItems = getCategoryItems(localizations);

    return SafeArea(
      child: Padding(
        padding: REdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.verticalSectionSpacing),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              SizedBox(height: AppSizes.largeSpacing),
              Text(
                localizations.upcoming,
                style: isLight
                    ? AppLightTextStyles.sectionTitle
                    : AppDarkTextStyles.sectionTitle,
              ),
              SizedBox(height: AppSizes.smallSpacing),
              UpcomingItemsList(upcomingItems: upcomingItems),
              SizedBox(height: AppSizes.largeSpacing),
              Text(
                localizations.quickAccess,
                style: isLight
                    ? AppLightTextStyles.sectionTitle
                    : AppDarkTextStyles.sectionTitle,
              ),
              SizedBox(height: AppSizes.smallSpacing),
              QuickAccessList(categoryItem: categoryItems),
            ],
          ),
        ),
      ),
    );
  }
}