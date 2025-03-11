import 'package:flutter/material.dart';
import 'package:idfy_user_application/login.dart';
import 'package:idfy_user_application/splashScreen.dart';
// Your home/dashboard page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Define routes
      routes: {
        '/': (context) => const SplashScreen(), 
      },
      initialRoute: '/', 
      title: 'User Application',
    );
  }
}
