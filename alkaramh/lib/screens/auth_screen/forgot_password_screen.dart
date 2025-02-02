import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/auth_screen/signin_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
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

                const SizedBox(height: 60),
                // Image
                Center(
                  child: Image.asset(
                    fonrgotpasswordImage,
                    width: 300,
                    height: 300,
                  ),
                ),
                const SizedBox(height: 60),
                // Title
                Text(
                  AppLocalizations.of(context)!.translate('forgot_password'),
                  style: MyTextTheme.headline.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!
                      .translate('forgot_password_message'),
                  style: MyTextTheme.body.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                        .translate('enter_your_email_or_phone'),
                    hintStyle: MyTextTheme.normal.copyWith(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey, // Set the border color as grey
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        // Optional: Set the focused border color as grey
                        width:
                            2.0, // Optional: You can adjust the width for better visibility
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add navigation or logic
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green button color
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.translate('get_otp'),
                      style: MyTextTheme.body.copyWith(
                        color: Colors.white, // White text color
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                // Subtitle
              ],
            ),
          ),
        ),
      ),
    );
  }
}
