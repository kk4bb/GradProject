import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/network/token_storage.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/assets_manager.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/routes_manager/routes.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';
import '../../../../shared/widgets/validators.dart';
import '../../data/auth_repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController(text: "john.doe@example.com");
  final TextEditingController passwordController =
      TextEditingController(text: "Password123!");
  final _formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _authRepository.login(
          emailController.text.trim(),
          passwordController.text,
        );

        await tokenStorage.saveToken(response.token);
        await tokenStorage.saveRole(response.role);

        if (mounted) {
          final String role = response.role;
          if (role == "Instructor" || role == "Doctor" || role == "TA") {
            Navigator.pushReplacementNamed(context, Routes.doctorDashboard);
          } else {
            Navigator.pushReplacementNamed(context, Routes.main);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60.0),

              /// Logo
              Container(
                width: 120.0,
                height: 120.0,
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
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  ImagesManager.bnuLogo,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40.0),

              /// Title
              Text(
                localizations.welcomeBack,
                style: isLight
                    ? AppLightTextStyles.titleLarge
                    : AppDarkTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8.0),

              /// Subtitle
              Text(
                "Sign in to your BNU Learn account to continue.",
                style: isLight
                    ? AppLightTextStyles.bodyMedium
                    : AppDarkTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40.0),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// Email / Student ID
                    CustomTextFormField(
                      controller: emailController,
                      prefixIcon: const Icon(Icons.person_outline),
                      hintText: "Student ID or Email",
                      fillColor:
                          isLight ? ColorsManager.white : ColorsManager.darkSurface,
                      prefixIconColor: isLight
                          ? ColorsManager.grayDark
                          : ColorsManager.darkTextSecondary,
                      style: isLight
                          ? AppLightTextStyles.bodyMedium
                          : AppDarkTextStyles.bodyMedium,
                      validator: AppValidators.validateEmail,
                    ),

                    const SizedBox(height: 16.0),

                    /// Password
                    CustomTextFormField(
                      controller: passwordController,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: "Password",
                      fillColor:
                          isLight ? ColorsManager.white : ColorsManager.darkSurface,
                      prefixIconColor: isLight
                          ? ColorsManager.grayDark
                          : ColorsManager.darkTextSecondary,
                      style: isLight
                          ? AppLightTextStyles.bodyMedium
                          : AppDarkTextStyles.bodyMedium,
                      validator: AppValidators.validatePassword,
                    ),

                    const SizedBox(height: 16.0),

                    /// Fingerprint + Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.fingerprint,
                          size: 40.0,
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

                    const SizedBox(height: 32.0),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                "Login",
                                style: AppLightTextStyles.labelLarge,
                              ),
                      ),
                    ),

                    const SizedBox(height: 16.0),

                    const SizedBox(height: 40.0),

                    const SizedBox(height: 20.0),
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
