import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green
                        .withOpacity(0.1), // Light green background color
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.green, // Green arrow color
                      ),
                      onPressed: () {
                        // Handle back navigation
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
          
                const SizedBox(height: 20),
          
                Text(
                  "Let’s Sign you in.",
                  style: MyTextTheme.headline.copyWith(
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                Text(
                  "Welcome back\nYou’ve been missed!",
                  style: MyTextTheme.normal.copyWith(
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 40),
                // Email or Phone Field
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter Email or Phone",
                    hintStyle: MyTextTheme.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    hintStyle: MyTextTheme.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                     suffixIcon: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: SvgPicture.asset(
                            lockSvgIcon,
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                  ),
                ),
                const SizedBox(height: 8),
                // Forgot Password
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      "Forgot password?",
                      style: MyTextTheme.normal.copyWith(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    // Handle sign-in logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Sign In",
                      style: MyTextTheme.normal.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ),
                const SizedBox(height: 20),
                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: MyTextTheme.normal.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),
                // Continue with Google
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Google Sign-In
                  },
                  icon: Row(
                    children: [
                      Image.asset(
                        googleSignInImage, // Replace with your asset path
                        height: 24,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  label: Text(
                    "Continue with Google",
                    style: MyTextTheme.normal.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Continue with Apple
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Apple Sign-In
                  },
                  icon: Row(
                    children: [
                      Image.asset(
                        appleSignInImage, // Replace with your asset path
                        height: 24,
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  label: Text(
                    "Continue with Apple",
                    style: MyTextTheme.normal.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Register Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle navigation to register screen
                    },
                    child:  Text.rich(
                      TextSpan(
                        text: "Don’t have an account? ",
                        style: MyTextTheme.normal.copyWith(
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: MyTextTheme.headline.copyWith(
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
