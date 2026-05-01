import 'package:bnu_lms_app/features/home/presentation/doctor/presentation/screens/doctor_home_screen.dart';
import 'package:bnu_lms_app/features/home/presentation/student/screen/home_screen.dart';
import 'package:bnu_lms_app/features/auth/presentation/screens/login_screen.dart';
import 'package:bnu_lms_app/shared/config/theme/app_theme.dart';
import 'package:bnu_lms_app/shared/providers/language_provider.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes_generator.dart';
import 'package:bnu_lms_app/shared/network/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const BNU(),
    ),
  );
}

class BNU extends StatelessWidget {
  const BNU({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Set to true to always show the Login screen for testing
  static const bool bypassAutoLogin = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.currentTheme,
      locale: Locale(languageProvider.currentLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: RoutesGenerator.getRoute,
      home: const SplashGate(),
    );
  }
}

class SplashGate extends StatelessWidget {
  const SplashGate({super.key});

  @override
  Widget build(BuildContext context) {
    if (BNU.bypassAutoLogin) {
      return const LoginScreen();
    }

    return FutureBuilder<String?>(
      future: tokenStorage.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final token = snapshot.data;
        if (token == null || token.isEmpty) {
          return const LoginScreen();
        }

        return FutureBuilder<String?>(
          future: tokenStorage.getRole(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final role = roleSnapshot.data;
            if (role == "Instructor" || role == "Doctor" || role == "TA") {
              return const DoctorHomeScreen();
            } else {
              return const HomeScreen();
            }
          },
        );
      },
    );
  }
}

