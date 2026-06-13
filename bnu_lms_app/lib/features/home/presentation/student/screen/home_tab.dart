import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/app_sizes.dart';
import '../../../../../shared/resources/assets_manager.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../../../shared/routes_manager/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/home_header.dart';
import '../widgets/student_hero_card.dart';
import '../widgets/student_action_list.dart';

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
      // {
      //   'icon': IconsManager.courses,
      //   'title': localizations.courses,
      //   'route': Routes.courses,
      // },
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
      // {
      //   'icon': IconsManager.gate,
      //   'title': localizations.entrance,
      //   'route': Routes.entrance,
      // },
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
    // final localizations = AppLocalizations.of(context)!;

    // Get category items with localized titles
    // final categoryItems = getCategoryItems(localizations);

    final currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.verticalSectionSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              SizedBox(height: AppSizes.largeSpacing),
              
              // Greeting Section
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  String name = 'Student';
                  if (state is AuthSuccess) {
                    name = state.auth.firstName;
                  }
                  return Text(
                    'Good Morning, $name',
                    style: isLight
                        ? AppLightTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w900)
                        : AppDarkTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w900),
                  );
                },
              ),
              SizedBox(height: 6),
              Text(
                'Ready to conquer your academic goals today?',
                style: TextStyle(
                  color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),

              // Date Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFF1F5F9) : ColorsManager.darkSurface,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: isLight ? const Color(0xFF64748B) : ColorsManager.darkTextSecondary,
                    ),
                    SizedBox(width: 8),
                    Text(
                      currentDate,
                      style: TextStyle(
                        fontSize: 12, 
                        color: isLight ? const Color(0xFF64748B) : ColorsManager.darkTextSecondary, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Hero Card (Upcoming Deadline)
              const StudentHeroCard(),
              
              SizedBox(height: 32),

              // Action List Cards
              const StudentActionList(),
              
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
