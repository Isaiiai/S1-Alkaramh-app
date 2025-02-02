import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/main.dart';
import 'package:alkaramh/screens/auth_screen/main_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:alkaramh/screens/order_screen/order_details_get_screen.dart';
import 'package:alkaramh/screens/wish_list/wish_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserAuthBloc userAuthBloc = UserAuthBloc();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[600], size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      onTap: onTap,
    );
  }

  Widget _buildAvatarText() {
    final String letter = (user?.displayName?.isNotEmpty ?? false)
        ? user!.displayName![0].toUpperCase()
        : '?';

    return Center(
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserAuthBloc userAuthBloc = BlocProvider.of<UserAuthBloc>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8F7EC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  color: Color(0xFFF8F7EC),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.translate('account'),
                          style: MyTextTheme.body.copyWith(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Section
            BlocListener<UserAuthBloc, UserAuthState>(
              bloc: userAuthBloc,
              listener: (context, state) {
                if (state is UserAuthInitial) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                } else if (state is UserRegisterFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate('something_went_wrong')),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        child: user!.photoURL != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.photoURL!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildAvatarText(),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              )
                            : _buildAvatarText(),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user!.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Menu Items
            Container(
              color: Color(0xFFF8F7EC),
              child: Column(
                children: [
                  _buildListTile(
                    title: AppLocalizations.of(context)!
                        .translate('you_are_in_current_version'),
                    icon: Icons.system_update_outlined,
                    onTap: () {},
                  ),
                  // _buildListTile(
                  //   title: AppLocalizations.of(context)!.translate('your_profile'),
                  //   icon: Icons.person_outline,
                  //   textColor: Colors.green,
                  //   onTap: () {},
                  // ),
                  _buildListTile(
                    title:
                        AppLocalizations.of(context)!.translate('your_orders'),
                    icon: Icons.shopping_bag_outlined,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderScreen()));
                    },
                  ),
                  _buildListTile(
                    title:
                        AppLocalizations.of(context)!.translate('faviroutes'),
                    icon: Icons.favorite_outline,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WishList()));
                    },
                  ),
                  _buildListTile(
                    title: AppLocalizations.of(context)!.translate('language'),
                    icon: Icons.language_outlined,
                    onTap: () {
                      _showLanguageDialog(context); // Open Language Dialog
                    },
                  ),
                  _buildListTile(
                    title:
                        AppLocalizations.of(context)!.translate('contact_us'),
                    icon: Icons.mail_outline,
                    onTap: () {},
                  ),
                  _buildListTile(
                    title: AppLocalizations.of(context)!.translate('logout'),
                    icon: Icons.logout,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(AppLocalizations.of(context)!.translate('change_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("English"),
                onTap: () {
                  MyApp.setLocale(context, const Locale('en', 'US'));
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("العربية"),
                onTap: () {
                  MyApp.setLocale(context, const Locale('ar', 'AE'));
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    UserAuthBloc userAuthBloc = BlocProvider.of<UserAuthBloc>(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('logout')),
          content:
              Text(AppLocalizations.of(context)!.translate('logout_confirm')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(AppLocalizations.of(context)!.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                userAuthBloc.add(LogoutEvent());
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text(AppLocalizations.of(context)!.translate('logout')),
            ),
          ],
        );
      },
    );
  }
}
