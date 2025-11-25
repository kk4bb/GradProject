import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../resources/colors_manager.dart';

class AppDarkTextStyles {
  // 👋 Welcome Text
  static final TextStyle welcome = GoogleFonts.poppins(
    fontSize: 14.sp,
    color: ColorsManager.blue, // keep blue accent for highlight
    fontWeight: FontWeight.w400,
  );

  // 🙋‍♂️ User Name
  static final TextStyle userName = GoogleFonts.poppins(
    fontSize: 16.sp,
    color: ColorsManager.darkTextPrimary,
    fontWeight: FontWeight.w600,
  );

  // 🏷️ Section Titles (e.g., "Upcoming", "Quick Access")
  static final TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: 20.sp,
    color: ColorsManager.darkTextPrimary,
    fontWeight: FontWeight.w600,
  );

  // 📘 Card Title (e.g., "Calculus II Assignment")
  static final TextStyle cardTitle = GoogleFonts.poppins(
    fontSize: 16.sp,
    color: ColorsManager.darkTextPrimary,
    fontWeight: FontWeight.w500,
  );

  // 🕒 Card Subtitle (e.g., "Due at 11:59 PM")
  static final TextStyle cardSubtitle = GoogleFonts.poppins(
    fontSize: 14.sp,
    color: ColorsManager.darkTextSecondary,
    fontWeight: FontWeight.w400,
  );

  // 📚 Quick Access Label (e.g., "Courses", "Calendar")
  static final TextStyle quickAccessLabel = GoogleFonts.poppins(
    fontSize: 15.sp,
    color: ColorsManager.darkTextPrimary,
    fontWeight: FontWeight.w500,
  );

  // 🔁 Continue Section Title (e.g., "Continue where you left off")
  static final TextStyle continueTitle = GoogleFonts.poppins(
    fontSize: 18.sp,
    color: ColorsManager.darkTextPrimary,
    fontWeight: FontWeight.w600,
  );

  // ⏳ Duration Text (e.g., "15 min left")
  static final TextStyle timeRemaining = GoogleFonts.poppins(
    fontSize: 13.sp,
    color: ColorsManager.darkTextSecondary,
    fontWeight: FontWeight.w400,
  );

  // ⚙️ Settings Screen Title
  static final TextStyle appBarTitle = GoogleFonts.poppins(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.darkTextPrimary,
  );

  // 🧩 Settings Item Title
  static final TextStyle settingItemTitle = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.darkTextPrimary,
  );

  // 🗒 Settings Item Subtitle
  static final TextStyle settingItemSubtitle = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.darkTextSecondary,
  );


  static final tabLabelSelected = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.white,
  );

  static final tabLabelUnselected = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.darkTextSecondary,
  );

  static final notificationTitle = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.darkTextPrimary,
  );

  static final notificationDescription = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: ColorsManager.darkTextSecondary,
  );

  static final notificationTime = GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.darkTextSecondary,
  );


  // LOGIN SCREEN TEXT STYLES - DARK
  static final loginTitle = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.darkTextPrimary,
  );

  static final loginSubtitle = GoogleFonts.poppins(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.darkTextSecondary,
  );

  static final loginInputHint = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.darkTextSecondary,
  );

  static final forgotPassword = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.blue,
  );

  static final loginButtonText = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.white,
  );

  static final loginSsoButtonText = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.blue,
  );

  static final loginFooter = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.darkTextSecondary,
  );

}