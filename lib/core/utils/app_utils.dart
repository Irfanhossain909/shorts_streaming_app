import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testemu/core/constants/app_colors.dart';

class Utils {
  /// SUCCESS SNACKBAR (TOP)
  static successSnackBar(
    BuildContext context,
    String title,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.black,

          // 👇 TOP position
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.8),
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

  /// ERROR SNACKBAR (TOP)
  static errorSnackBar(
    BuildContext context,
    dynamic title,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.red,

          // 👇 TOP position
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error,
                color: AppColors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kDebugMode ? title.toString() : "Oops!",
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
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
}


// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:testemu/core/constants/app_colors.dart';

// class Utils {
//   static successSnackBar(BuildContext context, String title, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 color: AppColors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               message,
//               style: const TextStyle(color: AppColors.white, fontSize: 14),
//             ),
//           ],
//         ),
//         backgroundColor: AppColors.black,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   static errorSnackBar(BuildContext context, dynamic title, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               kDebugMode ? title.toString() : "Oops",
//               style: const TextStyle(
//                 color: AppColors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               message,
//               style: const TextStyle(color: AppColors.white, fontSize: 14),
//             ),
//           ],
//         ),
//         backgroundColor: AppColors.red,
//         behavior: SnackBarBehavior.floating,
//         margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }
