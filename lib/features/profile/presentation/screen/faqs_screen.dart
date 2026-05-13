import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:testemu/core/component/appbar/common_app_bar.dart';
import 'package:testemu/core/component/other_widgets/common_loader.dart';
import 'package:testemu/core/component/screen/error_screen.dart';
import 'package:testemu/core/component/text/common_text.dart';
import 'package:testemu/core/constants/app_colors.dart';
import 'package:testemu/core/utils/enum/enum.dart';
import 'package:testemu/features/profile/presentation/controller/faqs_controller.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqsController>(
      init: FaqsController.instance,
      builder: (controller) {
        if (controller.status == Status.loading) {
          return const CommonLoader(size: 60);
        }
        if (controller.status == Status.error) {
          return ErrorScreen(onTap: controller.getFaqsRepo);
        }
        return Scaffold(
          appBar: CommonAppBar(title: "FAQs"),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 32.r, left: 16.r, right: 16.r),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.faqs.length,
              itemBuilder: (context, index) {
                final faq = controller.faqs[index];
                return _ExpandableFaqTile(
                  question: faq.question ?? '',
                  answer: faq.answer ?? '',
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ExpandableFaqTile extends StatefulWidget {
  const _ExpandableFaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_ExpandableFaqTile> createState() => _ExpandableFaqTileState();
}

class _ExpandableFaqTileState extends State<_ExpandableFaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.activeTrackColor;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonText(
                      text: widget.question,
                      textAlign: TextAlign.start,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    _expanded ? Icons.remove : Icons.add,
                    size: 22.sp,
                    color: color,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: CommonText(
                text: widget.answer,
                textAlign: TextAlign.justify,
                maxLines: _expanded ? 1000 : 3,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: color.withValues(alpha: 0.8),
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            sizeCurve: Curves.easeOut,
          ),
          SizedBox(height: _expanded ? 18.h : 0),
          Divider(color: color.withValues(alpha: 0.2), height: 1.h),
        ],
      ),
    );
  }
}
