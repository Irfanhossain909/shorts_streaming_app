import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testemu/core/component/image/common_image.dart';

class GlassEffectIcon extends StatelessWidget {
  const GlassEffectIcon({
    super.key,
    required this.icon,
    this.width = 24,
    this.height = 24,
    this.onTap,
  });
  final String icon;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x30FFFFFF), Color(0x10FFFFFF)],
              ),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CommonImage(imageSrc: icon, width: width, height: height),
          ),
        ),
      ),
    );
  }
}
