import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/splash_screen.dart';

class MainController {
  Widget getInitialScreen() {
    return const SplashScreen();
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }
}
