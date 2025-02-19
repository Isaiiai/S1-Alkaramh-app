import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/services/auth_services.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isNotification = false;

  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final status = await AuthServices().isNotificationEnabled();
    setState(() {
      isNotification = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackGroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      child: Text(
                        AppLocalizations.of(context)!.translate('notifications'),
                        style: MyTextTheme.body(context).copyWith(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                // Main Content
                Column(
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
                      AppLocalizations.of(context)!.translate('dont_miss_a_beat'),
                      style: MyTextTheme.body(context).copyWith(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      AppLocalizations.of(context)!.translate(
                          'get_notification_about_due_date_discounts_and_deals'),
                      textAlign: TextAlign.center,
                      style: MyTextTheme.body(context).copyWith(
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
                        onPressed: () async {
                          final authServices = AuthServices();
                          final result = await authServices.updateNotificationStatus(
                              isNotification ? false : true);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isNotification
                                  ? AppLocalizations.of(context)!.translate('disable_notification')
                                  : AppLocalizations.of(context)!.translate('notifications_enabled')),
                              backgroundColor: isNotification ? Colors.green : Colors.green,
                            ),
                          );
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
                          isNotification
                              ? AppLocalizations.of(context)!.translate('disable_notification')
                              : AppLocalizations.of(context)!.translate('enable_notification'),
                          style: MyTextTheme.body(context).copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.translate('remaind_me_later'),
                        style: MyTextTheme.body(context).copyWith(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}