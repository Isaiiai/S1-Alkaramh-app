import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
import 'package:alkaramh/bloc/product_varient/product_varient_bloc.dart';
import 'package:alkaramh/bloc/user_auth/user_auth_bloc.dart';
import 'package:alkaramh/screens/auth_screen/forgot_password_screen.dart';
import 'package:alkaramh/screens/auth_screen/main_screen.dart';
import 'package:alkaramh/screens/auth_screen/otp_entry_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:alkaramh/screens/bottom_navigation/bottom_navigation.dart';
import 'package:alkaramh/screens/cart_screen/cart_screen.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:alkaramh/screens/splash_screen/splash_screen.dart';
import 'package:alkaramh/bloc/home_bloc/bloc/home_fetch_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeFetchBloc>(
          create: (context) => HomeFetchBloc(),
        ),
        BlocProvider<UserAuthBloc>(
          create: (context) => UserAuthBloc(),
        ),
        BlocProvider<ProductFetchBloc>(
          create: (context) => ProductFetchBloc(),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(),
        ),
        BlocProvider<ProductVarientBloc>(
          create: (context) => ProductVarientBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ),
        // Add more BlocProviders as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alkaramh',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 79, 41)),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
