import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/auth_screen/signin_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                // Image
                Center(
                  child: Image.asset(
                    mainScreenImage, // Replace with your image path
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 60),
                // Title
                Text(
                  "Let's Buy the products with\njust a tap",
                  textAlign: TextAlign.center,
                  style: MyTextTheme.headline.copyWith(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  "Explore the app to find the animal feeds & other products with a tap.",
                  textAlign: TextAlign.center,
                  style: MyTextTheme.subheading
                      .copyWith(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 50),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    // Add navigation or logic
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green, width: 1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: MyTextTheme.headline
                        .copyWith(color: Colors.green, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16),
                // Register Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Register",
                    style: MyTextTheme.headline
                        .copyWith(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
