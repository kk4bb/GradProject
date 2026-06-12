import 'package:bnu_lms_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bnu_lms_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:bnu_lms_app/shared/config/theme/app_theme.dart';
import 'package:bnu_lms_app/shared/providers/language_provider.dart';
import 'package:bnu_lms_app/shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'package:bnu_lms_app/shared/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
          BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        ],
        child: const BNU(),
      ),
    ),
  );
}

class BNU extends StatelessWidget {
  const BNU({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.currentTheme,
      locale: Locale(languageProvider.currentLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: Routes.login,
      onGenerateRoute: RoutesGenerator.getRoute,
    );
  }
}