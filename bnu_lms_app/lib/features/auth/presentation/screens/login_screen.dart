import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/routes_manager/routes.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../shared/widgets/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    // final textTheme = isLight ? AppLightTextStyles() : AppDarkTextStyles();

    return Scaffold(
      backgroundColor:
      isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),

              /// Logo
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: isLight ? Colors.white : ColorsManager.darkSurface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (isLight)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                clipBehavior: Clip.hardEdge, // IMPORTANT for perfect circle clipping
                child: Image.asset(
                  ImagesManager.bnuLogo,
                  fit: BoxFit.cover, // makes the logo fill all space
                ),
              ),


              SizedBox(height: 40.h),

              /// Title
              Text(
                localizations.welcomeBack,
                style: isLight
                    ? AppLightTextStyles.titleLarge
                    : AppDarkTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              /// Subtitle
              Text(
                "Sign in to your BNU Learn account to continue.",
                style: isLight
                    ? AppLightTextStyles.bodyMedium
                    : AppDarkTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.h),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// Email / Student ID
                    CustomTextFormField(
                      controller: emailController,
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: "Student ID or Email",
                      fillColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                      prefixIconColor: isLight
                          ? ColorsManager.grayDark
                          : ColorsManager.darkTextSecondary,
                      style: isLight
                          ? AppLightTextStyles.bodyMedium
                          : AppDarkTextStyles.bodyMedium,
                      validator: AppValidators.validateEmail,
                    ),

                    SizedBox(height: 16.h),

                    /// Password
                    CustomTextFormField(
                      controller: passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: "Password",
                      fillColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                      prefixIconColor: isLight
                          ? ColorsManager.grayDark
                          : ColorsManager.darkTextSecondary,
                      style: isLight
                          ? AppLightTextStyles.bodyMedium
                          : AppDarkTextStyles.bodyMedium,
                      validator: AppValidators.validatePassword,
                    ),

                    SizedBox(height: 16.h),

                    /// Fingerprint + Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.fingerprint,
                          size: 40.sp,
                          color: ColorsManager.blue,
                        ),

                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: isLight
                                ? AppLightTextStyles.titleMedium
                                : AppDarkTextStyles.titleMedium,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.main);
                        },
                        child: Text(
                          "Login",
                          style: AppLightTextStyles.labelLarge,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    SizedBox(height: 40.h),

                    /// Contact Support
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Need help? Contact Support",
                        style: isLight
                            ? AppLightTextStyles.bodySmall
                            : AppDarkTextStyles.bodySmall,
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
