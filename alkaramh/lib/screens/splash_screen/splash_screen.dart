import 'package:alkaramh/screens/auth_screen/main_screen.dart';
import 'package:alkaramh/screens/bottom_navigation/bottom_navigation.dart';
import 'package:alkaramh/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:alkaramh/constants/image_deceleration.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to HomeScreen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen()), // Replace with your HomeScreen widget
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                splashScreenImage,
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 90),
            const CircularProgressIndicator(
              color: Color.fromARGB(255, 33, 226, 243),
            ),
          ],
        ),
      ),
    );
  }
}
