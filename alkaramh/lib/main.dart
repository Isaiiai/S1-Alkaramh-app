import 'package:alkaramh/screens/auth_screen/main_screen.dart';
import 'package:alkaramh/screens/auth_screen/signin_screen.dart';
import 'package:alkaramh/screens/auth_screen/signup_screen.dart';
import 'package:alkaramh/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 79, 41)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
