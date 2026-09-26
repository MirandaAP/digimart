
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const DigiMartApp());
}

class DigiMartApp extends StatelessWidget {
  const DigiMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DigiMart',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}