import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/language_handler_bloc/language_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
import 'package:alkaramh/bloc/product_varient/product_varient_bloc.dart';
import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
import 'package:alkaramh/screens/splash_screen/splash_screen.dart';
import 'package:alkaramh/bloc/home_bloc/bloc/home_fetch_bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(create: (context) => LanguageBloc()),
        BlocProvider<HomeFetchBloc>(create: (context) => HomeFetchBloc()),
        BlocProvider<UserAuthBloc>(create: (context) => UserAuthBloc()),
        BlocProvider<ProductFetchBloc>(create: (context) => ProductFetchBloc()),
        BlocProvider<OrderBloc>(create: (context) => OrderBloc()),
        BlocProvider<ProductVarientBloc>(
            create: (context) => ProductVarientBloc()),
        BlocProvider<CartBloc>(create: (context) => CartBloc()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return DevicePreview(
            enabled: true,
            builder: (context) => MaterialApp(
              useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,
              title: 'Alkaramh',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromARGB(255, 0, 79, 41),
                ),
                useMaterial3: true,
              ),
              locale: languageState.locale,
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
        },
      ),
    );
  }
}