import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  AppToast._();

  /// 🎨 Default style
  static const Color _bg = Color(0xFF470808);
  static const Color _text = Colors.white;

  /// 💬 NORMAL MESSAGE TOAST
  static void message(
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: message,
      
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: _bg,
      textColor: _text,
      fontSize: 14,
    );
  }

  /// ❌ FAILED TOAST
  static void failed(
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
    Toast toastLength = Toast.LENGTH_SHORT,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      backgroundColor: _bg,
      textColor: _text,
      fontSize: 14,
    );
  }
}
