import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testemu/core/component/shimmer/shimmer_base.dart';

class LoginSliderShimmer extends StatelessWidget {
  const LoginSliderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: ShimmerBase(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(8.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: Stack(
                  children: [
                    /// Main image shimmer (same color logic)
                    ShimmerBox(
                      height: 200.h,
                      width: 120.w,
                      borderRadius: BorderRadius.circular(30.r),
                    ),

                    /// Glass blur overlay
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8,
                          sigmaY: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ),
                    ),

                    /// Fake title shimmer
                    Positioned(
                      bottom: 60.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ShimmerBox(
                          height: 14.h,
                          width: 70.w,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
