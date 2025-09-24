import 'package:flutter/material.dart';
import 'package:testemu/screens/auth/login/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stream App',
      home: LoginScreen(),
    );
  }
}
