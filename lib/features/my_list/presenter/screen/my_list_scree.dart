import 'package:flutter/material.dart';
import 'package:testemu/core/constants/app_colors.dart';

class MyListScree extends StatelessWidget {
  const MyListScree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.red2, // প্রথম color
              Colors.transparent, // শেষ color
              Colors.transparent, // শেষ color
              Colors.transparent, // শেষ color
              Colors.transparent, // শেষ color
              Colors.transparent, // শেষ color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
