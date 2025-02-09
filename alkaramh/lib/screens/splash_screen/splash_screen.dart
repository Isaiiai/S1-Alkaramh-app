import 'package:alkaramh/screens/auth_screen/main_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:alkaramh/screens/bottom_navigation/bottom_navigation.dart';
import 'package:alkaramh/screens/home_screen/home_screen.dart';
import 'package:alkaramh/services/google_services.dart';
import 'package:flutter/material.dart';
import 'package:alkaramh/constants/image_deceleration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
   await Future.delayed(const Duration(seconds: 3));
    bool isLoggedIn = await GoogleServices.isUserLoggedIn();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: [
            Center(
              child: Image.asset(
                splashScreenImage,
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 80),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
