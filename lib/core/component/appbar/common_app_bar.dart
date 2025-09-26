import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/other_widgets/glass_effect_icon.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';

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
      backgroundColor: Colors.transparent,
      elevation: elevation,
      toolbarHeight: toolbarHeight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(shapeRadius),
          bottomRight: Radius.circular(shapeRadius),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.9, 0),
            end: Alignment(1.0, 0),
            colors: [
              Color(0xFF083E4B), // #083E4B
              Color(0xFF074E5E), // #074E5E
              Color(0xFF0288A6), // #0288A6
            ],
            stops: [0.0, 0.4, 1.0],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(shapeRadius),
            bottomRight: Radius.circular(shapeRadius),
          ),
        ),
      ),
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
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: leadingColor ?? AppColors.white,
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
