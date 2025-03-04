import 'package:alkaramh/app_localizations.dart';
                          import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
                          import 'package:alkaramh/config/color/colors_file.dart';
                          import 'package:alkaramh/config/text/my_text_theme.dart';
                          import 'package:alkaramh/constants/image_deceleration.dart';
                          import 'package:alkaramh/screens/auth_screen/forgot_password_screen.dart';
                          import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
                          import 'package:alkaramh/screens/bottom_navigation/bottom_navigation.dart';
                          import 'package:alkaramh/widget/snakbar_all/snakbar_all.dart';
                          import 'package:flutter/material.dart';
                          import 'package:flutter_bloc/flutter_bloc.dart';
                          import 'package:flutter_svg/flutter_svg.dart';

                          class SignInScreen extends StatefulWidget {
                            const SignInScreen({super.key});

                            @override
                            _SignInScreenState createState() => _SignInScreenState();
                          }

                          class _SignInScreenState extends State<SignInScreen> {
                            final TextEditingController _emailController = TextEditingController();
                            final TextEditingController _passwordController = TextEditingController();
                            late UserAuthBloc userAuthBloc;

                            @override
                            void initState() {
                              super.initState();
                              userAuthBloc = BlocProvider.of<UserAuthBloc>(context);
                            }

                            @override
                            void dispose() {
                              _emailController.dispose();
                              _passwordController.dispose();
                              super.dispose();
                            }

                            @override
                            Widget build(BuildContext context) {
                              return Scaffold(
                                backgroundColor: AppColors.primaryBackGroundColor,
                                body: SafeArea(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: BlocListener<UserAuthBloc, UserAuthState>(
                                        bloc: userAuthBloc,
                                        listener: (context, state) {
                                          if (state is UserRegisterFailure || state is GoogleSignInFailure) {
                                            ErrorDialogbox().showErrorDialog(context, AppLocalizations.of(context)!.translate('something_went_wrong'));
                                          } else if (state is UserRegisterSuccess || state is GoogleSignInSuccess) {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => BottomNavScreen()),
                                              (Route<dynamic> route) => false,
                                            );
                                          }
                                        },
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
                                              AppLocalizations.of(context)!.translate('lets_sign_in_you'),
                                              style: MyTextTheme.headline(context).copyWith(
                                                fontSize: 40,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              AppLocalizations.of(context)!.translate('welcome_back'),
                                              style: MyTextTheme.normal(context).copyWith(
                                                fontSize: 30,
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.translate('you_ve_been_missed'),
                                              style: MyTextTheme.normal(context).copyWith(
                                                fontSize: 30,
                                              ),
                                            ),
                                            const SizedBox(height: 40),
                                            TextField(
                                              controller: _emailController,
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(context)!.translate('enter_your_email_or_phone'),
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
                                              obscureText: true,
                                              controller: _passwordController,
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(context)!.translate('enter_your_password'),
                                                hintStyle: MyTextTheme.normal(context).copyWith(
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
                                                      builder: (context) => const ForgotPasswordScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!.translate('forgot_password'),
                                                  style: MyTextTheme.normal(context).copyWith(
                                                    fontSize: 18,
                                                    decoration: TextDecoration.underline,
                                                    decorationColor: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            BlocBuilder<UserAuthBloc, UserAuthState>(
                                              bloc: userAuthBloc,
                                              builder: (context, state) {
                                                if (state is UserRegisterLoading || state is GoogleSignInLoading) {
                                                  return const Center(child: CircularProgressIndicator());
                                                }
                                                return ElevatedButton(
                                                  onPressed: () {
                                                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                                      ErrorDialogbox().showErrorDialog(
                                                        context,
                                                        AppLocalizations.of(context)!.translate('fill_all_fields'),
                                                      );
                                                      return;
                                                    }

                                                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                                                    if (!emailRegex.hasMatch(_emailController.text.trim())) {
                                                      ErrorDialogbox().showErrorDialog(
                                                        context,
                                                        AppLocalizations.of(context)!.translate('invalid_email'),
                                                      );
                                                      return;
                                                    }

                                                    userAuthBloc.add(SignInEvent(
                                                      email: _emailController.text.trim(),
                                                      password: _passwordController.text.trim(),
                                                    ));
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
                                                );
                                              },
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
                                                userAuthBloc.add(SignInGoogleEvent());
                                              },
                                              icon: Row(
                                                children: [
                                                  Image.asset(
                                                    googleSignInImage,
                                                    height: 24,
                                                  ),
                                                  const SizedBox(width: 16),
                                                ],
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
                                                userAuthBloc.add(SignupAppleEvent());
                                              },
                                              icon: Row(
                                                children: [
                                                  Image.asset(
                                                    appleSignInImage,
                                                    height: 24,
                                                  ),
                                                  const SizedBox(width: 16),
                                                ],
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
                                            const SizedBox(height: 30),
                                            Center(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => SignUpScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: AppLocalizations.of(context)!.translate('dont_have_an_account'),
                                                    style: MyTextTheme.normal(context).copyWith(
                                                      fontSize: 18,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: AppLocalizations.of(context)!.translate('register'),
                                                        style: MyTextTheme.headline(context).copyWith(
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