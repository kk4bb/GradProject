// import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../shared/config/theme/app_dark_text_styles.dart';
// import '../../../../shared/config/theme/app_light_text_styles.dart';
// import '../../../../shared/providers/theme_provider.dart';
//
// class ProfileActionButtons extends StatelessWidget {
//   const ProfileActionButtons({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ActionButton(
//               icon: 'assets/icons/overlay.png',
//               label: 'View Transcript',
//               onTap: () {
//                 // Navigate to transcript
//               },
//             ),
//             ActionButton(
//               icon: 'assets/icons/academic_progress.png',
//               label: 'Progress',
//               onTap: () {
//                 // Navigate to progress
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ActionButton(
//               icon: 'assets/icons/tutition_payment.png',
//               label: 'Tuition Payments',
//               onTap: () {
//                 // Navigate to payments
//               },
//             ),
//             ActionButton(
//               icon: 'assets/icons/certificates.png',
//               label: 'Certificates',
//               onTap: () {
//                 // Navigate to certificates
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ActionButton(
//               icon: 'assets/icons/report.png',
//               label: 'Attendance Report',
//               onTap: () {
//                 // Navigate to attendance report
//               },
//             ),
//             ActionButton(
//               icon: 'assets/icons/help_center.png',
//               label: 'Advising Sessions',
//               onTap: () {
//                 // Navigate to advising sessions
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// class ActionButton extends StatelessWidget {
//   final String icon;
//   final String label;
//   final VoidCallback onTap;
//
//   const ActionButton({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isLight = themeProvider.isLightTheme();
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         alignment: Alignment.center,
//         width: 160,
//         height: 152,
//         decoration: BoxDecoration(
//           color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(icon, width: 40, height: 40),
//             const SizedBox(height: 20),
//             Text(
//               label,
//               style: isLight
//                   ? AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.black)
//                   : AppDarkTextStyles.labelMedium.copyWith(
//                       color: ColorsManager.white,
//                     ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
