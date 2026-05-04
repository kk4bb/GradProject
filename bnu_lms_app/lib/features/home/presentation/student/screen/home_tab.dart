import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/app_sizes.dart';
import '../../../../../shared/resources/assets_manager.dart';
import '../../../../../shared/routes_manager/routes.dart';
import '../widgets/home_header.dart';
import '../widgets/quck_access_list.dart';
import '../widgets/upcoming_items_list.dart';

import '../../../../../shared/network/repositories/student_repository.dart';
import '../data/models/student_dashboard_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final StudentRepository _studentRepository = StudentRepository();
  late Future<StudentDashboard> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _studentRepository.getDashboard();
  }

  List<Map<String, dynamic>> getCategoryItems(AppLocalizations localizations) {
    return [
      {
        'icon': IconsManager.calendar,
        'title': localizations.calendar,
        'route': Routes.calendar,
      },
      {
        'icon': IconsManager.quiz,
        'title': localizations.quizzes,
        'route': Routes.quizzes,
      },
      {
        'icon': IconsManager.grades,
        'title': localizations.grades,
        'route': Routes.grades,
      },
      {
        'icon': IconsManager.attendance,
        'title': localizations.attendance,
        'route': Routes.attendance,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;
    final categoryItems = getCategoryItems(localizations);

    return FutureBuilder<StudentDashboard>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final dashboard = snapshot.data!;

        final List<Map<String, dynamic>> mappedUpcomingItems = dashboard.upcomingItems.map((item) {
          return {
            'icon': item.type == 'Assignment' ? Icons.assignment : Icons.quiz,
            'title': item.title,
            'subtitle': '${item.courseTitle} - Due: ${item.dueDate.day}/${item.dueDate.month}',
          };
        }).toList();

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.horizontalPadding,
              vertical: AppSizes.verticalSectionSpacing,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(name: dashboard.fullName),
                  SizedBox(height: AppSizes.largeSpacing),
                  Text(
                    localizations.upcoming,
                    style: isLight
                        ? AppLightTextStyles.headlineMedium
                        : AppDarkTextStyles.headlineMedium,
                  ),
                  SizedBox(height: AppSizes.smallSpacing),
                  mappedUpcomingItems.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: Text('No upcoming items')),
                        )
                      : UpcomingItemsList(upcomingItems: mappedUpcomingItems),
                  SizedBox(height: AppSizes.largeSpacing),
                  Text(
                    localizations.quickAccess,
                    style: isLight
                        ? AppLightTextStyles.headlineMedium
                        : AppDarkTextStyles.headlineMedium,
                  ),
                  SizedBox(height: AppSizes.smallSpacing),
                  QuickAccessList(
                    categoryItem: categoryItems,
                    onItemTap: (route) {
                      Navigator.pushNamed(context, route);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
