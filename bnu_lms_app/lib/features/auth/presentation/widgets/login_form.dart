// lib/features/auth/presentation/widgets/login_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/routes_manager/routes.dart';
import '../../../../shared/widgets/custom_elevated_button.dart';
import '../../../../shared/di/injection.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../domain/entities/auth_entity.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  /// Role-based navigation after successful login
  void _navigateByRole(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.student:
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.main, (route) => false);
      case UserRole.instructor:
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.doctorDashboard, (route) => false);
      case UserRole.ta:
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.taDashboard, (route) => false);
      case UserRole.unknown:
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.main, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    const cyan = ColorsManager.blue;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Pre-fetch the profile immediately after successful login so the avatar is ready across all screens!
          getIt<ProfileCubit>().fetchProfile();
          _navigateByRole(context, state.auth.role);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorsManager.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color:
                  isLight ? Colors.white : ColorsManager.darkSurface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: isLight
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Email Field ──────────────────────────────────────────────
                Text(
                  'University Email',
                  style: (isLight
                          ? AppLightTextStyles.titleMedium
                          : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'name@university.edu',
                  prefixIcon: Icons.email_outlined,
                  isLight: isLight,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // ── Password Field ───────────────────────────────────────────
                Text(
                  'Password',
                  style: (isLight
                          ? AppLightTextStyles.titleMedium
                          : AppDarkTextStyles.titleMedium)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  isLight: isLight,
                  isObscure: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: ColorsManager.grayMedium,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (v.length < 6) return 'Password too short';
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // ── Options Row ──────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _rememberMe = !_rememberMe),
                      child: Row(
                        children: [
                          Icon(
                            _rememberMe
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: _rememberMe
                                ? cyan
                                : ColorsManager.grayMedium,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Remember Me',
                            style: TextStyle(
                              fontSize: 13,
                              color: isLight
                                  ? ColorsManager.black
                                  : ColorsManager.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // ── Login Button ─────────────────────────────────────────────
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.blue,
                        ),
                      )
                    : CustomElevatedButton(
                        label: 'Login',
                        onTap: () => _onLoginPressed(context),
                        backgroundColor: cyan,
                        suffixIcon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                        radius: 30,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required bool isLight,
    bool isObscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide:
          BorderSide(color: ColorsManager.grayMedium.withValues(alpha: 0.2)),
    );

    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
          color: isLight ? ColorsManager.black : ColorsManager.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            TextStyle(color: ColorsManager.grayMedium, fontSize: 14),
        prefixIcon:
            Icon(prefixIcon, color: ColorsManager.grayMedium, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isLight
            ? Colors.grey.shade50
            : ColorsManager.darkBackground,
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        enabledBorder: border,
        focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: ColorsManager.blue)),
        errorBorder: border.copyWith(
            borderSide: const BorderSide(color: ColorsManager.red)),
        focusedErrorBorder: border.copyWith(
            borderSide: const BorderSide(color: ColorsManager.red)),
      ),
    );
  }
}