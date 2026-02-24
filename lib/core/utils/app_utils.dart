import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testemu/core/constants/app_colors.dart';

class Utils {
  Utils._();

  /// ✅ Default SnackBar position: TOP
  /// If you pass [SnackBarPosition.bottom] then it will show at bottom.
  static const SnackBarPosition _defaultPosition = SnackBarPosition.top;

  /// ✅ SUCCESS SNACKBAR
  static void successSnackBar(
    BuildContext context,
    String title,
    String message, {
    SnackBarPosition position = _defaultPosition,
  }) {
    _showSnackBar(
      context,
      title: title,
      message: message,
      backgroundColor: AppColors.black,
      icon: const Icon(Icons.check_circle, color: AppColors.red),
      position: position,
      titleColor: AppColors.white,
      messageColor: AppColors.white,
      messageOpacity: 0.8,
    );
  }

  /// ❌ ERROR SNACKBAR
  static void errorSnackBar(
    BuildContext context,
    dynamic title,
    String message, {
    SnackBarPosition position = _defaultPosition,
  }) {
    _showSnackBar(
      context,
      title: kDebugMode ? title.toString() : "Oops!",
      message: message,
      backgroundColor: AppColors.red,
      icon: const Icon(Icons.error, color: AppColors.white),
      position: position,
      titleColor: AppColors.white,
      messageColor: AppColors.white,
      messageOpacity: 0.9,
    );
  }

  /// 💬 MESSAGE SNACKBAR (NEW)
  /// ✅ Text color: White
  /// ✅ BG color: #470808
  static void messageSnackBar(
    BuildContext context,
    String title,
    String message, {
    SnackBarPosition position = _defaultPosition,
  }) {
    _showSnackBar(
      context,
      title: title,
      message: message,
      backgroundColor: const Color(0xFF470808),
      icon: const Icon(Icons.info_outline, color: AppColors.white),
      position: position,
      titleColor: AppColors.white,
      messageColor: AppColors.white,
      messageOpacity: 0.95,
    );
  }

  /// =========================
  /// ✅ Common snack builder
  /// =========================
  static void _showSnackBar(
    BuildContext context, {
    required String title,
    required String message,
    required Color backgroundColor,
    required Widget icon,
    required SnackBarPosition position,
    required Color titleColor,
    required Color messageColor,
    double messageOpacity = 0.9,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        margin: _marginByPosition(position),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: messageColor.withOpacity(messageOpacity),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static EdgeInsets _marginByPosition(SnackBarPosition position) {
    // ✅ Keep your existing TOP design
    if (position == SnackBarPosition.top) {
      return const EdgeInsets.only(left: 16, right: 16, top: 20);
    }

    // ✅ Bottom floating snackbar margin
    return const EdgeInsets.only(left: 16, right: 16, bottom: 20);
  }
}

/// ✅ Position enum for ScaffoldMessenger SnackBar
enum SnackBarPosition { top, bottom }



// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:testemu/core/constants/app_colors.dart';

// class Utils {
//   /// SUCCESS SNACKBAR (TOP)
//   static successSnackBar(
//     BuildContext context,
//     String title,
//     String message,
//   ) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 3),
//           backgroundColor: AppColors.black,

//           // 👇 TOP position
//           margin: const EdgeInsets.only(
//             left: 16,
//             right: 16,
//             top: 20,
//           ),

//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           content: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Icon(
//                 Icons.check_circle,
//                 color: AppColors.red,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         color: AppColors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       message,
//                       style: TextStyle(
//                         color: AppColors.white.withOpacity(0.8),
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//   }

//   /// ERROR SNACKBAR (TOP)
//   static errorSnackBar(
//     BuildContext context,
//     dynamic title,
//     String message,
//   ) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           duration: const Duration(seconds: 3),
//           backgroundColor: AppColors.red,

//           // 👇 TOP position
//           margin: const EdgeInsets.only(
//             left: 16,
//             right: 16,
//             top: 20,
//           ),

//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           content: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Icon(
//                 Icons.error,
//                 color: AppColors.white,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       kDebugMode ? title.toString() : "Oops!",
//                       style: const TextStyle(
//                         color: AppColors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       message,
//                       style: TextStyle(
//                         color: AppColors.white.withOpacity(0.9),
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//   }
// }
