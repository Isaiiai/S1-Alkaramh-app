import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/language_handler_bloc/language_bloc.dart';
import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/screens/auth_screen/main_screen.dart';
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
        style: MyTextTheme.body.copyWith(
          color: textColor ?? Colors.black87,
          fontSize: 18,
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
      backgroundColor: AppColors.primaryBackGroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  
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
                            style: MyTextTheme.body.copyWith(
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
            SizedBox(
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
                        AppLocalizations.of(context)!.translate('wishlist'),
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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .translate('select_language')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('English'),
                                onTap: () {
                                  context
                                      .read<LanguageBloc>()
                                      .add(ChangeLanguageEvent('en'));
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: const Text('العربية'),
                                onTap: () {
                                  context
                                      .read<LanguageBloc>()
                                      .add(ChangeLanguageEvent('ar'));
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
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
