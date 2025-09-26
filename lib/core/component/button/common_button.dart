import 'package:flutter/material.dart';
import 'package:testemu/core/constants/app_colors.dart';

import '../other_widgets/common_loader.dart';
import '../text/common_text.dart';

class CommonButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String titleText;
  final Color titleColor;
  final Color buttonColor;
  final Color? borderColor;
  final double borderWidth;
  final double titleSize;
  final FontWeight titleWeight;
  final double buttonRadius;
  final double buttonHeight;
  final double buttonWidth;
  final bool isLoading;
  final bool isGradient;

  const CommonButton({
    this.onTap,
    required this.titleText,
    this.titleColor = AppColors.white,
    this.buttonColor = AppColors.primaryColor,
    this.titleSize = 16,
    this.buttonRadius = 30,
    this.titleWeight = FontWeight.w700,
    this.buttonHeight = 48,
    this.borderWidth = 1,
    this.isLoading = false,
    this.buttonWidth = double.infinity,
    this.borderColor = AppColors.primaryColor,
    this.isGradient = true,
    super.key,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 100),
          lowerBound: 0.0,
          upperBound: 0.15,
        )..addListener(() {
          setState(() {});
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.buttonHeight,
      width: widget.buttonWidth,
      child: _buildElevatedButton(),
    );
  }

  // Function to build the button with common settings
  Widget _buildElevatedButton() {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: Transform.scale(
        scale: (1 - _animationController.value).toDouble(),
        child: Container(
          decoration: BoxDecoration(
            color: widget.buttonColor,
            gradient: widget.isGradient
                ? LinearGradient(
                    begin: Alignment(-0.9, 0),
                    end: Alignment(1.0, 0),
                    colors: [
                      Color(0xFF083E4B), // #083E4B
                      Color(0xFF074E5E), // #074E5E
                      Color(0xFF0288A6), // #0288A6
                    ],
                    stops: [0.0, 0.4, 1.0],
                  )
                : null,
            borderRadius: BorderRadius.circular(widget.buttonRadius),
            border: Border.all(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.buttonRadius),
              onTap: widget.onTap,
              child: Container(
                height: widget.buttonHeight,
                width: widget.buttonWidth,
                alignment: Alignment.center,
                child: widget.isLoading ? _buildLoader() : _buildText(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return CommonLoader(size: widget.buttonHeight - 12);
  }

  Widget _buildText() {
    return CommonText(
      text: widget.titleText,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      fontSize: widget.titleSize,
      color: widget.titleColor,
      fontWeight: widget.titleWeight,
    );
  }

  _onTapDown(TapDownDetails details) {
    if (widget.onTap == null) return;
    _animationController.forward();
  }

  _onTapUp(TapUpDetails details) {
    if (widget.onTap == null) return;
    _animationController.reverse();
  }

  _onTapCancel() {
    if (widget.onTap == null) return;
    _animationController.reverse();
  }
}
