import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
import 'package:alkaramh/bloc/product_varient/product_varient_bloc.dart';
import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
import 'package:alkaramh/screens/splash_screen/splash_screen.dart';
import 'package:alkaramh/bloc/home_bloc/bloc/home_fetch_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart'; // Import localization class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('ar', 'AE'); 

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeFetchBloc>(create: (context) => HomeFetchBloc()),
        BlocProvider<UserAuthBloc>(create: (context) => UserAuthBloc()),
        BlocProvider<ProductFetchBloc>(create: (context) => ProductFetchBloc()),
        BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
        BlocProvider<ProductVarientBloc>(create: (context) => ProductVarientBloc()),
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alkaramh',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 79, 41),
          ),
          useMaterial3: true,
        ),
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AE'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return supportedLocales.first;
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: const SplashScreen(),
      ),
    );
  }
}
