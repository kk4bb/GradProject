import 'package:bnu_lms_app/features/quizzes/presentation/widgets/quiz_details/description_box.dart';
import 'package:bnu_lms_app/shared/config/theme/app_dark_text_styles.dart';
import 'package:bnu_lms_app/shared/config/theme/app_light_text_styles.dart';
import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:bnu_lms_app/shared/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/network/repositories/quiz_repository.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/app_sizes.dart';
import '../../data/models/quiz_model.dart';
import '../widgets/quiz_details/double_divider.dart';
import '../widgets/quiz_details/info_item.dart';

class QuizDetailsScreen extends StatefulWidget {
  final int quizId;

  const QuizDetailsScreen({required this.quizId, super.key});

  @override
  State<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  final QuizRepository _quizRepository = QuizRepository();
  late Future<QuizTake> _quizFuture;

  @override
  void initState() {
    super.initState();
    _quizFuture = _quizRepository.takeQuiz(widget.quizId);
  }

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
      body: FutureBuilder<QuizTake>(
        future: _quizFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final quiz = snapshot.data!;

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 358.0,
                    decoration: BoxDecoration(
                      color: isLight
                          ? ColorsManager.white
                          : ColorsManager.darkSurface,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                quiz.title,
                                style: isLight
                                    ? AppLightTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                      )
                                    : AppDarkTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.radius,
                                  ),
                                  color: isLight
                                      ? const Color(0xFFE3F6EC)
                                      : const Color(0xFF1D3C2B),
                                ),
                                child: Text(
                                  'Not Started',
                                  style:
                                      (isLight
                                              ? AppLightTextStyles.labelMedium
                                                    .copyWith(
                                                      color: isLight
                                                          ? const Color(0xFF1B5E20)
                                                          : const Color(0xFF4CE483),
                                                      fontWeight: FontWeight.w600,
                                                    )
                                              : AppDarkTextStyles.labelMedium)
                                          .copyWith(
                                            color: isLight
                                                ? const Color(0xFF1B5E20)
                                                : const Color(0xFF4CE483),
                                            fontWeight: FontWeight.w600,
                                          ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Available Quiz',
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
                                  value: 'TBD',
                                  isLight: isLight,
                                ),
                              ),
                              Expanded(
                                child: InfoItem(
                                  title: 'Duration',
                                  value: '--',
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
                                  value: quiz.questions.length.toString(),
                                  isLight: isLight,
                                ),
                              ),
                              Expanded(
                                child: InfoItem(
                                  title: 'Attempts',
                                  value: '1 of 1',
                                  isLight: isLight,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.largeSpacing),
                          const Divider(color: ColorsManager.grayMedium, height: 1),
                          SizedBox(height: AppSizes.mediumSpacing),
                          InfoItem(
                            title: 'Difficulty',
                            value: 'Mixed',
                            isLight: isLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.largeSpacing),
                  const DescriptionBox(),
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
                            const ImageIcon(AssetImage(IconsManager.check)),
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
                            const ImageIcon(AssetImage(IconsManager.clock)),
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
                            const ImageIcon(AssetImage(IconsManager.arrowRight)),
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
                    child: CustomElevatedButton(
                      label: 'Start Quiz',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.quizQuestions,
                          arguments: {'quiz': quiz},
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

