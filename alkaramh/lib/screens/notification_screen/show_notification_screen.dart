import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7EC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                    const Spacer(),
                  Container(
                    child: Text(
                      'Notification',
                      style: MyTextTheme.body.copyWith(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              // Main Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bell Icon with glow
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Red glow
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        // Bell icon container
                        Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(notificationEmptyImage)),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Text(
                      "Don't miss a beat",
                      style: MyTextTheme.body.copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Get notified about Due date, discounts and deals',
                      textAlign: TextAlign.center,
                      style: MyTextTheme.body.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Enable Button
                    SizedBox(
                      width: 186,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Notification Enabled Clicked ");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF193219),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Enable Notification',
                          style: MyTextTheme.body.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Remind Later Button
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'remind me later',
                        style: MyTextTheme.body.copyWith(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
