
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
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF5F5F5) : ColorsManager.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),

              /// Logo with circular background
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(20.w),
                child: Image.asset(
                  ImagesManager.bnuLogo,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 40.h),

              /// Title
              Text(
                localizations.welcomeBack,
                style: isLight
                    ? AppLightTextStyles.loginTitle
                    : AppDarkTextStyles.loginTitle,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              /// Subtitle
              Text(
                'Sign in to your BNU Learn account to continue.',
                style: isLight
                    ? AppLightTextStyles.loginSubtitle
                    : AppDarkTextStyles.loginSubtitle,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 40.h),

              /// Student ID or Email Input
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      style: isLight
                          ? AppLightTextStyles.loginInputHint
                          : AppDarkTextStyles.loginInputHint,
                      prefixIconColor: ColorsManager.grayDark,
                      controller: emailController,
                      hintText: 'Student ID or Email',
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: AppValidators.validateEmail,
                    ),

                    SizedBox(height: 16.h),

                    /// Password Input
                    CustomTextFormField(
                      style: isLight
                          ? AppLightTextStyles.loginInputHint
                          : AppDarkTextStyles.loginInputHint,
                      prefixIconColor: ColorsManager.grayDark,
                      controller: passwordController,
                      isPassword: true,
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: AppValidators.validatePassword,
                    ),

                    SizedBox(height: 16.h),

                    /// Fingerprint and Forgot Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Fingerprint Icon
                        Icon(
                          Icons.fingerprint,
                          size: 40.sp,
                          color: ColorsManager.blue,
                        ),

                        // Forgot Password
                        TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: isLight
                                ? AppLightTextStyles.forgotPassword
                                : AppDarkTextStyles.forgotPassword,
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
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, Routes.main);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// Login with University SSO Button
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 56.h,
                    //   child: OutlinedButton(
                    //     style: OutlinedButton.styleFrom(
                    //       side: BorderSide(
                    //         color: ColorsManager.blue,
                    //         width: 2.w,
                    //       ),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(16.r),
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       // Handle SSO login
                    //     },
                    //     child: Text(
                    //       'Login with University SSO',
                    //       style: TextStyle(
                    //         fontSize: 16.sp,
                    //         fontWeight: FontWeight.w600,
                    //         color: ColorsManager.blue,
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 40.h),

                    /// Contact Support
                    TextButton(
                      onPressed: () {
                        // Handle contact support
                      },
                      child: Text(
                        'Need help? Contact Support',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorsManager.grayDark,
                        ),
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