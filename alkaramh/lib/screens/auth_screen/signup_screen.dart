import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/auth_screen/forgot_password_screen.dart';
import 'package:alkaramh/screens/bottom_navigation/bottom_navigation.dart';
import 'package:alkaramh/services/google_services.dart';
import 'package:alkaramh/widget/snakbar_all/snakbar_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  late UserAuthBloc _userAuthBloc;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _userAuthBloc = UserAuthBloc();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<UserAuthBloc, UserAuthState>(
          bloc: _userAuthBloc,
          listener: (context, state) {
            if (state is UserRegisterFailure || state is GoogleSignInFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state is UserRegisterFailure
                        ? state.message
                        : state is GoogleSignInFailure
                        ? state.message
                        : "An error occurred",
                  ),
                ),
              );
            } else if (state is UserRegisterSuccess ||
                state is GoogleSignInSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavScreen(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UserRegisterLoading || state is GoogleSignInLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.translate('create_new_account'),
                      style: MyTextTheme.headline(context).copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate('signup_to_shopping'),
                          style: MyTextTheme.normal(context).copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          shopingSvgIcon,
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('enter_name'),
                        hintStyle: MyTextTheme.normal(context).copyWith(
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
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('enter_email'),
                        hintStyle: MyTextTheme.normal(context).copyWith(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      obscureText: _obscurePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('enter_password'),
                        hintStyle: MyTextTheme.normal(context).copyWith(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      obscureText: _obscureConfirmPassword,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.translate('confirm_password'),
                        hintStyle: MyTextTheme.normal(context).copyWith(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.translate(
                                    'password_must_be_at_least_characters_long'),
                              ),
                            ),
                          );
                          return;
                        } else if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.translate('password_does_not_match'),
                              ),
                            ),
                          );
                          return;
                        }
                        if (nameController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            emailController.text.isEmpty) {
                          ErrorDialogbox().showErrorDialog(
                              context,
                              AppLocalizations.of(context)!.translate('fill_all_fields'));
                          return;
                        }

                        final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                        if (!emailRegex.hasMatch(emailController.text.trim())) {
                          print('Invalid email${emailController}');
                          ErrorDialogbox().showErrorDialog(
                              context,
                              AppLocalizations.of(context)!.translate('invalid_email'));
                          return;
                        }
                        _userAuthBloc.add(
                          UserAuthRegisterEvent(
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                          ),
                        );
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
                        AppLocalizations.of(context)!.translate('sign_in'),
                        style: MyTextTheme.normal(context).copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "OR",
                            style: MyTextTheme.normal(context).copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        _userAuthBloc.add(SignupGoogleEvent());
                      },
                      icon: Image.asset(
                        googleSignInImage,
                        height: 24,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.translate('continue_with_google'),
                        style: MyTextTheme.normal(context).copyWith(
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
                    ElevatedButton.icon(
                      onPressed: () {
                        _userAuthBloc.add(SignupAppleEvent());
                      },
                      icon: Image.asset(
                        appleSignInImage,
                        height: 24,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.translate('continue_with_apple'),
                        style: MyTextTheme.normal(context).copyWith(
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}