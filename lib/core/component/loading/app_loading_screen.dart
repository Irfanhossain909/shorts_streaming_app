import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/constants/app_colors.dart';

/// Full screen beautiful loading animation
/// Use this when loading critical app data or during transitions
class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({
    super.key,
    this.message = 'Loading...',
    this.showMessage = true,
  });

  final String message;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.red2,
            Colors.black,
            Colors.black,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated loading rings
            const LoadingRings(),
            if (showMessage) ...[
              SizedBox(height: 30.h),
              Text(
                message,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated loading rings widget
class LoadingRings extends StatefulWidget {
  const LoadingRings({super.key});

  @override
  State<LoadingRings> createState() => _LoadingRingsState();
}

class _LoadingRingsState extends State<LoadingRings>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          AnimatedBuilder(
            animation: _controller1,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller1.value * 2 * 3.14159,
                child: Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.red2.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.red2,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Middle ring
          AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_controller2.value * 2 * 3.14159,
                child: Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.red2.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.red2,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Inner ring
          AnimatedBuilder(
            animation: _controller3,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller3.value * 2 * 3.14159,
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.red2.withOpacity(0.7),
                      width: 3,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: AppColors.red2,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Center dot
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppColors.red2,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.red2.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer effect loading bar (horizontal progress style)
class ShimmerLoadingBar extends StatefulWidget {
  const ShimmerLoadingBar({
    super.key,
    this.height = 4,
    this.color,
  });

  final double height;
  final Color? color;

  @override
  State<ShimmerLoadingBar> createState() => _ShimmerLoadingBarState();
}

class _ShimmerLoadingBarState extends State<ShimmerLoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.height.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: null,
            backgroundColor: (widget.color ?? AppColors.red2).withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.color ?? AppColors.red2,
            ),
          );
        },
      ),
    );
  }
}
