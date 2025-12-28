// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../text/common_text.dart';

class CommonTextField extends StatefulWidget {
  CommonTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.mexLength,
    this.maxLines,
    this.validator,
    this.prefixText,
    this.paddingHorizontal = 16,
    this.paddingVertical = 14,
    this.borderRadius = 10,
    this.inputFormatters,
    this.fillColor = AppColors.white,
    this.hintTextColor = AppColors.textSecondary,
    this.labelTextColor = AppColors.textSecondary,
    this.textColor = AppColors.black,
    this.borderColor = AppColors.background,
    this.onSubmitted,
    this.onTap,
    this.suffixIcon,
    this.readOnly = false,
  });

  final String? hintText;
  final String? labelText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? labelTextColor;
  final Color? hintTextColor;
  final Color? textColor;
  final Color borderColor;
  final double paddingHorizontal;
  final double paddingVertical;
  final double borderRadius;
  final int? mexLength;
  final int? maxLines;
  final bool isPassword;
  final bool readOnly;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final FormFieldValidator? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late bool obscureText;

  @override
  void initState() {
    super.initState();
    // If it's a password field, start with text hidden
    obscureText = widget.isPassword;
  }

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure password fields are single-line
    final effectiveMaxLines = widget.isPassword ? 1 : widget.maxLines;

    // Automatically set keyboardType to multiline when using newline action with multiline fields
    final effectiveKeyboardType = widget.isPassword
        ? TextInputType.text
        : (widget.textInputAction == TextInputAction.newline &&
                effectiveMaxLines != null &&
                effectiveMaxLines > 1)
            ? TextInputType.multiline
            : widget.keyboardType;

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: effectiveKeyboardType,
      controller: widget.controller,
      obscureText: widget.isPassword ? obscureText : false,
      textInputAction: widget.textInputAction,
      maxLength: widget.mexLength,
      maxLines: effectiveMaxLines,
      readOnly: widget.readOnly,
      cursorColor: AppColors.white,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(fontSize: 14, color: widget.textColor),
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      validator: widget.validator,
      decoration: InputDecoration(
        errorMaxLines: 2,
        filled: true,
        prefixIcon: widget.prefixIcon,
        fillColor: widget.fillColor,
        counterText: "",
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.paddingHorizontal.w,
          vertical: widget.paddingVertical.h,
        ),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(),
        disabledBorder: _buildBorder(),
        errorBorder: _buildBorder(),
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle:
            GoogleFonts.poppins(fontSize: 14, color: widget.hintTextColor),
        labelStyle:
            GoogleFonts.poppins(fontSize: 14, color: widget.labelTextColor),
        prefix: widget.prefixText != null
            ? CommonText(
                text: widget.prefixText ?? "",
                fontWeight: FontWeight.w400,
              )
            : null,
        suffixIcon: widget.isPassword
            ? _buildPasswordSuffixIcon()
            : widget.suffixIcon,
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius.r),
      borderSide: BorderSide(color: widget.borderColor),
    );
  }

  Widget _buildPasswordSuffixIcon() {
    return GestureDetector(
      onTap: toggleObscureText,
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 10.w),
        child: Icon(
          obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20.sp,
          color: widget.textColor,
        ),
      ),
    );
  }
}



// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../constants/app_colors.dart';
// import '../text/common_text.dart';

// class CommonTextField extends StatelessWidget {
//   CommonTextField({
//     super.key,
//     this.hintText,
//     this.labelText,
//     this.prefixIcon,
//     this.isPassword = false,
//     this.controller,
//     this.textInputAction = TextInputAction.next,
//     this.keyboardType = TextInputType.text,
//     this.mexLength,
//     this.maxLines,
//     this.validator,
//     this.prefixText,
//     this.paddingHorizontal = 16,
//     this.paddingVertical = 14,
//     this.borderRadius = 10,
//     this.inputFormatters,
//     this.fillColor = AppColors.white,
//     this.hintTextColor = AppColors.textSecondary,
//     this.labelTextColor = AppColors.textSecondary,
//     this.textColor = AppColors.black,
//     this.borderColor = AppColors.background,
//     this.onSubmitted,
//     this.onTap,
//     this.suffixIcon,
//     this.readOnly = false,
//   });

//   final String? hintText;
//   final String? labelText;
//   final String? prefixText;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final Color? fillColor;
//   final Color? labelTextColor;
//   final Color? hintTextColor;
//   final Color? textColor;
//   final Color borderColor;
//   final double paddingHorizontal;
//   final double paddingVertical;
//   final double borderRadius;
//   final int? mexLength;
//   final int? maxLines;
//   final bool isPassword;
//   final bool readOnly;
//   RxBool obscureText = false.obs;
//   final Function(String)? onSubmitted;
//   final VoidCallback? onTap;
//   final TextEditingController? controller;
//   final TextInputAction textInputAction;
//   final FormFieldValidator? validator;
//   final TextInputType keyboardType;
//   final List<TextInputFormatter>? inputFormatters;

//   @override
//   Widget build(BuildContext context) {
//     // Automatically set keyboardType to multiline when using newline action with multiline fields
//     final effectiveKeyboardType =
//         (textInputAction == TextInputAction.newline &&
//             maxLines != null &&
//             maxLines! > 1)
//         ? TextInputType.multiline
//         : keyboardType;

//     return TextFormField(
//       autovalidateMode: AutovalidateMode.onUnfocus,
//       keyboardType: effectiveKeyboardType,
//       controller: controller,
//       obscureText: obscureText.value,
//       textInputAction: textInputAction,
//       maxLength: mexLength,
//       maxLines: maxLines,
//       readOnly: readOnly,
//       cursorColor: AppColors.white,
//       inputFormatters: inputFormatters,
//       style: TextStyle(fontSize: 14, color: textColor),
//       onFieldSubmitted: onSubmitted,
//       onTap: onTap,
//       validator: validator,
//       decoration: InputDecoration(
//         errorMaxLines: 2,
//         filled: true,
//         prefixIcon: prefixIcon,
//         fillColor: fillColor,
//         counterText: "",
//         contentPadding: EdgeInsets.symmetric(
//           horizontal: paddingHorizontal.w,
//           vertical: paddingVertical.h,
//         ),
//         border: _buildBorder(),
//         enabledBorder: _buildBorder(),
//         focusedBorder: _buildBorder(),
//         disabledBorder: _buildBorder(),
//         errorBorder: _buildBorder(),
//         hintText: hintText,
//         labelText: labelText,
//         hintStyle: GoogleFonts.poppins(fontSize: 14, color: hintTextColor),
//         labelStyle: GoogleFonts.poppins(fontSize: 14, color: labelTextColor),
//         prefix: CommonText(text: prefixText ?? "", fontWeight: FontWeight.w400),
//         suffixIcon: isPassword ? _buildPasswordSuffixIcon() : suffixIcon,
//       ),
//     );
//   }

//   OutlineInputBorder _buildBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(borderRadius.r),
//       borderSide: BorderSide(color: borderColor),
//     );
//   }

//   Widget _buildPasswordSuffixIcon() {
//     return GestureDetector(
//       onTap: toggle,
//       child: Padding(
//         padding: EdgeInsetsDirectional.only(end: 10.w),
//         child: Obx(
//           () => Icon(
//             obscureText.value
//                 ? Icons.visibility_off_outlined
//                 : Icons.visibility_outlined,
//             size: 20.sp,
//             color: textColor,
//           ),
//         ),
//       ),
//     );
//   }

//   void toggle() {
//     obscureText.value = !obscureText.value;
//   }
// }
