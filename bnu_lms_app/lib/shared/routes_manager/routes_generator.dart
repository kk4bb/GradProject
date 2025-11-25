
import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import '../../features/notification/presentation/screens/notifications_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';

class RoutesGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.main:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      case Routes.settings:
        return MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        );

        case Routes.notifications:
        return MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        );

        case Routes.login:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );

    // case Routes.onBoarding:
    //   return MaterialPageRoute(builder: (context) => const OnBoardingScreen(),);

    // case Routes.login:
    //   return MaterialPageRoute(
    //     builder: (context) => BlocProvider(
    //       create: (context) => serviceLocator<LoginCubit>(),
    //       child: const LoginScreen(),
    //     ),
    //   );

    // case Routes.register:
    //   return MaterialPageRoute(
    //     builder: (context) => BlocProvider(
    //       create: (context) => serviceLocator<RegisterCubit>(),
    //       child: const RegisterScreen(),
    //     ),
    //   );

      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('No Route Found'),
        ),
        body: const Center(
          child: Text('No Route Found'),
        ),
      ),
    );
  }
}