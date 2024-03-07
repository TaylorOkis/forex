import 'package:flutter/material.dart';
import 'package:forex/screens/home_screen.dart';
import 'package:forex/screens/splash_screen.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.id:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case HomeScreen.id:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return const Scaffold(
          backgroundColor: Colors.redAccent,
          body: Center(
              child: Text(
            "Page not found!",
            style: TextStyle(color: Colors.white),
          )));
    });
  }
}
