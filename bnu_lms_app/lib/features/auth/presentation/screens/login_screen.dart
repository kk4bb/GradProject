// lib/features/auth/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();

    return Scaffold(
      backgroundColor: isLight
          ? ColorsManager.lightBackground
          : ColorsManager.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
              // 1. Logo and Title
              const LoginHeader(),

              SizedBox(height: 40),

              // 2. Form Card — BlocConsumer lives here
              const LoginForm(),

              SizedBox(height: 40),

              // 3. Footer
              const LoginFooter(),
            ],
          ),
        ),
      ),
    );
  }
}