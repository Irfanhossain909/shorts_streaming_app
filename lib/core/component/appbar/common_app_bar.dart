import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/other_widgets/glass_effect_icon.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/features/auth/forgot%20password/presentation/screen/create_password.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? leadingColor;
  final Color? actionsColor;
  final Color? shapeColor;
  final Color? elevationColor;
  final double? toolbarHeight;
  final Widget? leading;
  final List<Widget>? actions;
  final bool isBackButton;
  final double? elevation;
  final double shapeRadius;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final bool? isCenterTitle;
  final bool? isShowBackButton;
  final String? subtitle;
  final Widget? child;
  const CommonAppBar({
    super.key,
    required this.title,
    this.backgroundColor = AppColors.white,
    this.titleColor = AppColors.white,
    this.leadingColor = AppColors.white,
    this.actionsColor = AppColors.white,
    this.shapeColor = AppColors.black,
    this.elevationColor = AppColors.black,
    this.toolbarHeight = 80,
    this.leading,
    this.actions,
    this.isBackButton = true,
    this.elevation = 0,
    this.shapeRadius = 30,
    this.titleFontSize = 20,
    this.titleFontWeight = FontWeight.w600,
    this.isCenterTitle = true,
    this.isShowBackButton = true,
    this.subtitle,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: elevation,
      toolbarHeight: toolbarHeight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(shapeRadius),
          bottomRight: Radius.circular(shapeRadius),
        ),
      ),
      flexibleSpace: CustomGrediantForAllScreen(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: title,
            fontSize: titleFontSize ?? 20,
            fontWeight: titleFontWeight ?? FontWeight.w600,
            color:
                titleColor ??
                AppColors.white, // Changed to white for better contrast
          ),
          subtitle != null
              ? CommonText(
                  text: subtitle ?? '',
                  fontSize: titleFontSize ?? 20,
                  fontWeight: titleFontWeight ?? FontWeight.w600,
                  color:
                      titleColor ??
                      AppColors.white, // Changed to white for better contrast
                )
              : const SizedBox.shrink(),
        ],
      ),
      centerTitle: isCenterTitle,
      leading:
          leading ??
          (isShowBackButton ?? true
              ? IconButton(
                  onPressed: () => Get.back(),
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.red2, // Background color
                    ),
                    padding: EdgeInsets.all(8), // Size control
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                )
              : null),
      actions: actions?.map((action) {
        if (action is IconButton) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GlassEffectIcon(icon: AppImages.ai, onTap: action.onPressed),
          );
        }
        return action;
      }).toList(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 80);
}
