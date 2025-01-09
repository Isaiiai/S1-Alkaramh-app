import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  splashScreenImage,
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(
                height:90,
              ),
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 33, 226, 243),
              ),
            ],
          )),
    );
  }
}
