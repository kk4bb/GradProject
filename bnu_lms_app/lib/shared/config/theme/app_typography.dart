import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class   AppTypography {
  // Display (أكبر عناوين)
  static final displayLarge = GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
  );

  static final displayMedium = GoogleFonts.poppins(
    fontSize: 28.sp,
    fontWeight: FontWeight.w600,
  );

  // Headlines (العناوين الأساسية داخل الشاشات)
  static final headlineLarge = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static final headlineMedium = GoogleFonts.poppins(
    fontSize: 21.sp,
    fontWeight: FontWeight.w600,
  );

  static final headlineSmall = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  // Titles (العناوين الثانوية)
  static final titleLarge = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static final titleMedium = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
  );

  // Body (النصوص العادية)
  static final bodyLarge = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  static final bodyMedium = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static final bodySmall = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  // Labels (أزرار / Tabs / Text صغير)
  static final labelLarge = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static final labelMedium = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static final labelSmall = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );
}
