import 'package:bnu_lms_app/features/quizzes/presentation/widgets/quiz_details/description_box.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/app_sizes.dart';
import '../widgets/quiz_details/double_divider.dart';
import '../widgets/quiz_details/info_item.dart';

class QuizDetailsScreen extends StatelessWidget {
  const QuizDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.quizDetails,
          style: isLight
              ? AppLightTextStyles.headlineLarge
              : AppDarkTextStyles.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 358.w,
                decoration: BoxDecoration(
                  color: isLight
                      ? ColorsManager.white
                      : ColorsManager.darkSurface,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Chapter 3: Function',
                            style: isLight
                                ? AppLightTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )
                                : AppDarkTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          ),
                          Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppSizes.radius,
                              ),
                              color: isLight
                                  ? Color(0xFFE3F6EC)
                                  : Color(0xFF1D3C2B),
                            ),
                            child: Text(
                              'Not Started',
                              style:
                                  (isLight
                                          ? AppLightTextStyles.labelMedium
                                                .copyWith(
                                                  color: isLight
                                                      ? Color(0xFF1B5E20)
                                                      : Color(0xFF4CE483),
                                                  fontWeight: FontWeight.w600,
                                                )
                                          : AppDarkTextStyles.labelMedium)
                                      .copyWith(
                                        color: isLight
                                            ? Color(0xFF1B5E20)
                                            : Color(0xFF4CE483),
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'CS-101 - Dr. A. Smith',
                        style: isLight
                            ? AppLightTextStyles.bodyMedium
                            : AppDarkTextStyles.bodyMedium,
                      ),

                      SizedBox(height: AppSizes.largeSpacing),
                      const DoubleDivider(),
                      SizedBox(height: AppSizes.mediumSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: InfoItem(
                              title: 'Due Date',
                              value: 'Oct 28, 2024',
                              isLight: isLight,
                            ),
                          ),
                          Expanded(
                            child: InfoItem(
                              title: 'Duration',
                              value: '25',
                              isLight: isLight,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.largeSpacing),
                      const DoubleDivider(),
                      SizedBox(height: AppSizes.mediumSpacing),
                      Row(
                        children: [
                          Expanded(
                            child: InfoItem(
                              title: 'Questions',
                              value: '25',
                              isLight: isLight,
                            ),
                          ),
                          Expanded(
                            child: InfoItem(
                              title: 'Attempts',
                              value: '1 of 2 left',
                              isLight: isLight,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.largeSpacing),
                      Divider(color: ColorsManager.grayMedium, height: 1),
                      SizedBox(height: AppSizes.mediumSpacing),
                      InfoItem(
                        title: 'Difficulty',
                        value: 'Intermediate',
                        isLight: isLight,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.largeSpacing),
              DescriptionBox(),
              SizedBox(height: AppSizes.largeSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rules & Instructions',
                      style: isLight
                          ? AppLightTextStyles.headlineMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          : AppDarkTextStyles.headlineMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                    Row(
                      children: [
                        ImageIcon(AssetImage(IconsManager.check)),
                        SizedBox(width: AppSizes.smallSpacing),
                        Expanded(
                          child: Text(
                            'You must complete the quiz in a single'
                            'session once started.',
                            style: isLight
                                ? AppLightTextStyles.bodyMedium
                                : AppDarkTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.largeSpacing),
                    Row(
                      children: [
                        ImageIcon(AssetImage(IconsManager.clock)),
                        SizedBox(width: AppSizes.smallSpacing),
                        Expanded(
                          child: Text(
                            'The quiz is timed. The timer will not stop if'
                            'you navigate away from the page.',
                            style: isLight
                                ? AppLightTextStyles.bodyMedium
                                : AppDarkTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.largeSpacing),
                    Row(
                      children: [
                        ImageIcon(AssetImage(IconsManager.arrowRight)),
                        SizedBox(width: AppSizes.smallSpacing),
                        Expanded(
                          child: Text(
                            'No backtracking is allowed. You cannot'
                            'return to previous questions.',
                            style: isLight
                                ? AppLightTextStyles.bodyMedium
                                : AppDarkTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.largeSpacing),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomElevatedButton(label: 'Start Quiz', onTap: () {},),
              )
            ],
          ),
        ),
      ),
    );
  }
}
