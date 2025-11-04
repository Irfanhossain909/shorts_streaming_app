import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/constants/app_images.dart';
import 'package:testemu/core/utils/extensions/extension.dart';
import 'package:testemu/features/download/controller/download_episod_controller.dart';

class DownloadEpisodListScreen extends StatelessWidget {
  const DownloadEpisodListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadEpisodController>(
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: IconButton(
                  onPressed: () {
                    controller.valueManupolate();
                  },
                  icon: SvgPicture.asset(width: 18.w, AppImages.markIcon),
                ),
              ),
            ],
            isBackButton: false,
            isShowBackButton: false,
            isCenterTitle: false,
            title: "Downloaded",
          ),
          body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .65,
                  ),
                  padding: EdgeInsets.all(12),
                  physics: BouncingScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return EpisodCard(isMarkShowAll: controller.value.value);
                    });
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: Obx(() {
            return controller.value.value
                ? SafeArea(
                    child: Container(
                      color: Colors.black, // eta tumar bg color hishebe daw
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonText(
                              text: "Select All",
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Vertical Divider
                          Container(
                            width: 1,
                            height: 24, // divider height adjust koro
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),

                          Expanded(
                            child: InkWell(
                              onTap: () {
                                deteleDialog(context);
                              },
                              child: CommonText(
                                text: "Delete",
                                style: GoogleFonts.poppins(
                                  color: AppColors.red,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox();
          }),
        );
      },
    );
  }
}

Future<dynamic> deteleDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.background,
      contentPadding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              34.height, // space for close button

              Text(
                "Confirm to delete from download",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(36.r),
                      ),

                      alignment: Alignment.center,

                      child: CommonText(
                        top: 8.h,
                        bottom: 8.h,
                        text: "Cancel",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showMiddleToast(context, "Delete Successful");
                        Get.back();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.buton,
                          borderRadius: BorderRadius.circular(36.r),
                        ),

                        alignment: Alignment.center,

                        child: CommonText(
                          top: 8.h,
                          bottom: 8.h,
                          text: "Confirm",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    ),
  );
}

void showMiddleToast(BuildContext context, String message) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return ToastWidget(
        message: message,
        onFinish: () {
          try {
            overlayEntry?.remove();
          } catch (e) {
            // Ignore if already removed
          }
        },
      );
    },
  );

  Overlay.of(context).insert(overlayEntry);
}

class ToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onFinish;

  const ToastWidget({super.key, required this.message, required this.onFinish});

  @override
  ToastWidgetState createState() => ToastWidgetState();
}

class ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    // Fade in
    Future.delayed(Duration.zero, () {
      setState(() {
        opacityLevel = 1.0;
      });
    });

    // Fade out after 1 second
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        opacityLevel = 0.0;
      });
    });

    // Remove from overlay after fade out
    Future.delayed(Duration(milliseconds: 1300), () {
      widget.onFinish();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      left: MediaQuery.of(context).size.width * 0.2,
      right: MediaQuery.of(context).size.width * 0.2,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: opacityLevel,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF1D1D1D),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: CommonText(
                    text: widget.message,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EpisodCard extends StatefulWidget {
  final bool isMarkShowAll;
  const EpisodCard({super.key, this.isMarkShowAll = false});

  @override
  State<EpisodCard> createState() => _EpisodCardState();
}

class _EpisodCardState extends State<EpisodCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        Stack(
          children: [
            CommonImage(
              borderRadius: 8.r,
              width: 82.w,
              height: 103.h,
              imageSrc: AppImages.m1,
            ),

            /// Select Button
            if (widget.isMarkShowAll)
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  child: isSelected
                      ? Container(
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Icon(
                            Icons.done,
                            size: 12,
                            color: AppColors.black,
                          ),
                        )
                      : Container(
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(color: AppColors.white),
                          ),
                        ),
                ),
              ),
          ],
        ),

        CommonText(
          left: 4,
          text: "Ep.1",
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
