import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

class CommonLoader extends StatelessWidget {
  const CommonLoader({
    super.key,
    this.size = 60,
    this.strokeWidth = 4,
    this.color,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size.sp,
        width: size.sp,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.red2,
          ),
        ),
      ),
    );
  }
}

/// Beautiful animated loader with pulse effect
class PulseLoader extends StatefulWidget {
  const PulseLoader({
    super.key,
    this.size = 80,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Container(
              width: widget.size.w,
              height: widget.size.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (widget.color ?? AppColors.red2).withOpacity(0.8),
                    (widget.color ?? AppColors.red2).withOpacity(0.2),
                  ],
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: (widget.size * 0.6).w,
                  height: (widget.size * 0.6).w,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.color ?? AppColors.red2,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
