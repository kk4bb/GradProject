import 'package:flutter/material.dart';

import '../config/theme/app_light_text_styles.dart';
import '../resources/colors_manager.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String label;
  final Color? backgroundColor;
  final double? radius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final void Function() onTap;
  final TextStyle? textStyle;
  final bool fullWidth;

  const CustomElevatedButton({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.backgroundColor,
    this.radius,
    this.verticalPadding,
    this.horizontalPadding,
    this.fullWidth = true,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0, // الشكل المسطح modern مثل الصورة
        backgroundColor: backgroundColor ?? ColorsManager.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 10.0),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 15.0,
          vertical: verticalPadding ?? 14.0,
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixIcon ?? const SizedBox(),
          if (prefixIcon != null) SizedBox(width: 10.0),

          Text(
            label,
            style: textStyle ??
                AppLightTextStyles.bodyMedium.copyWith(
                  color: ColorsManager.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                ),
          ),

          if (suffixIcon != null) SizedBox(width: 10.0),
          suffixIcon ?? const SizedBox(),
        ],
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
