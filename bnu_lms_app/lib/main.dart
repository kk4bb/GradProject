import 'package:bnu_lms_app/shared/config/theme/app_theme.dart';
import 'package:bnu_lms_app/shared/providers/language_provider.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'features/home/presentation/screen/home_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeProvider.currentTheme,
        locale: Locale(languageProvider.currentLanguage),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: Routes.login,
        onGenerateRoute: RoutesGenerator.getRoute,
      ),
    );
  }
}