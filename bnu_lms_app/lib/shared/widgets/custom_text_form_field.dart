import 'package:flutter/material.dart';

import '../resources/colors_manager.dart';


class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final TextStyle? style;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? fillColor;
  final int maxLines;

  const CustomTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.hintStyle,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.style,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.fillColor,
    this.maxLines = 1,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscure;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isPassword;
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      style: widget.style ,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: widget.fillColor ?? ColorsManager.white,

        // Consistent border design with 0px border and radius 15
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        // Prefix Icon with proper color application
        prefixIcon: widget.prefixIcon != null
            ? IconTheme(
          data: IconThemeData(
            color: widget.prefixIconColor ?? Colors.white,
          ),
          child: widget.prefixIcon!,
        )
            : null,

        // Suffix Icon (for password visibility toggle)
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () {
            setState(() {
              isObscure = !isObscure;
            });
          },
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: ColorsManager.white,
            size: 24,
          ),
        )
            : null,
      ),
      validator: widget.validator,
    );
  }
}