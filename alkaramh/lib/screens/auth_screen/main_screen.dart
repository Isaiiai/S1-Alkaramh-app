import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/language_handler_bloc/language_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/auth_screen/signin_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedLanguage = 'en'; // Default language

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  // Load saved language preference
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage =
          prefs.getString('language') ?? 'en'; // Default is English
    });
  }

  // Save language preference and update the app
  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primaryBackGroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
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
                  AppLocalizations.of(context)!
                      .translate('lets_buy_the_products'),
                  textAlign: TextAlign.center,
                  style: MyTextTheme.headline.copyWith(fontSize: 22),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  AppLocalizations.of(context)!
                      .translate('explore_our_app_to_see'),
                  textAlign: TextAlign.center,
                  style: MyTextTheme.subheading
                      .copyWith(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 50),
                // Sign In Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green, width: 1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('sign_in'),
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
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('register'),
                    style: MyTextTheme.headline
                        .copyWith(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                // Language Selection Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green, width: 1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final currentLocale =
                        context.read<LanguageBloc>().state.locale.languageCode;
                    final newLanguage = currentLocale == 'en' ? 'ar' : 'en';
                    context
                        .read<LanguageBloc>()
                        .add(ChangeLanguageEvent(newLanguage));
                  },
                  child: Text(
                    context.watch<LanguageBloc>().state.locale.languageCode ==
                            'en'
                        ? "Switch to Arabic"
                        : "التبديل إلى الإنجليزية", style: MyTextTheme.headline
                        .copyWith(color: Colors.green, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
