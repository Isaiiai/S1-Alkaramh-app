import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/auth_screen/forgot_password_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:alkaramh/screens/bottom_navigation/bottom_navigation.dart';
import 'package:alkaramh/widget/snakbar_all/snakbar_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    UserAuthBloc userAuthBloc = BlocProvider.of<UserAuthBloc>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocListener<UserAuthBloc, UserAuthState>(
              bloc: userAuthBloc,
              listener: (context, state) {
                if (state is UserRegisterFailure) {
                  ErrorDialogbox().showErrorDialog(context, state.message);
                } else if (state is UserRegisterSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavScreen()),
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes from the stack
                  );
                } else if (state is GoogleSignInFailure) {
                  ErrorDialogbox().showErrorDialog(context, state.message);
                } else if (state is GoogleSignInSuccess) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavScreen()),
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes from the stack
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green
                          .withOpacity(0.1), // Light green background color
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.green, // Green arrow color
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                   AppLocalizations.of(context)!.translate('lets_sign_in_you'),
                    style: MyTextTheme.headline.copyWith(
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.translate('welcome_back'),
                    style: MyTextTheme.normal.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.translate('you_ve_been_missed'),
                    style: MyTextTheme.normal.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.translate('enter_your_email_or_phone'),
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
                  TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.translate('enter_your_password'),
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
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('forgot_password'),
                        style: MyTextTheme.normal.copyWith(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign In Button
                  BlocBuilder<UserAuthBloc, UserAuthState>(
                    bloc: userAuthBloc,
                    builder: (context, state) {
                      if (state is UserRegisterLoading ||
                          state is GoogleSignInLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: () {
                          userAuthBloc.add(SignInEvent(
                              email: _emailController.text,
                              password: _passwordController.text));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.translate('sign_in'),
                            style: MyTextTheme.normal.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            )),
                      );
                    },
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
                      userAuthBloc.add(SignInGoogleEvent());
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
                      AppLocalizations.of(context)!.translate('continue_with_google'),
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
                      ErrorDialogbox().showErrorDialog(
                          context,   AppLocalizations.of(context)!.translate('this_is_under_development'),);
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
                      AppLocalizations.of(context)!.translate('continue_with_apple'),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: Text.rich(
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate('dont_have_an_account'),
                          style: MyTextTheme.normal.copyWith(
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                              text: AppLocalizations.of(context)!.translate('register'),
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
      ),
    );
  }
}
