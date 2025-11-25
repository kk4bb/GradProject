// import 'package:bnu_lms/shared/config/theme/app_light_text_styles.dart';
// import 'package:bnu_lms/shared/resources/colors_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CardItem extends StatelessWidget {
//   const CardItem({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColorsManager.card,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Course Image
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.r),
//               topRight: Radius.circular(16.r),
//             ),
//             child: Image.asset(
//               'assets/images/bnu.jpg',
//               height: 140.h,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Advanced Calculus',
//                   style: AppStyles.headline18Bold,
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   'Dr. Ahmed Hassan',
//                   style: AppStyles.body14Regular.copyWith(
//                     color: ColorsManager.textSecondary,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//
//                 // Progress Bar
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8.r),
//                   child: LinearProgressIndicator(
//                     value: 0.75,
//                     backgroundColor: ColorsManager.blueAccent,
//                     color: ColorsManager.blueAccent,
//                     minHeight: 8.h,
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     '75% Complete',
//                     style: AppStyles.body12Regular.copyWith(
//                       color: ColorsManager.textSecondary,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
