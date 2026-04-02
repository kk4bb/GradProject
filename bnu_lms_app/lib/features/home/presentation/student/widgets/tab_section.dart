// import 'package:bnu_lms/features/home/presentation/widgets/content_box.dart';
// import 'package:bnu_lms/features/home/presentation/widgets/tab_item.dart';
// import 'package:bnu_lms/shared/resources/colors_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class TabSection extends StatefulWidget {
//   const TabSection({super.key});
//
//   @override
//   State<TabSection> createState() => _TabSectionState();
// }
//
// class _TabSectionState extends State<TabSection> {
//   int selectedTabIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TabBar(
//             onTap: (index) {
//               setState(() {
//                 selectedTabIndex = index;
//               });
//             },
//             isScrollable: true,
//             dividerColor: ColorsManager.divider,
//             indicator:const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: ColorsManager.blueAccent,
//                   width: 3.0,
//                 ),
//               ),
//             ),
//             tabAlignment: TabAlignment.start,
//             padding: EdgeInsets.zero,
//             tabs: [
//               Tab(
//                 child: TabItem(
//                   sourceName: 'Deadlines',
//                   isSelected: selectedTabIndex == 0,
//                 ),
//               ),
//               Tab(
//                 child: TabItem(
//                   sourceName: 'Next Lecture',
//                   isSelected: selectedTabIndex == 1,
//                 ),
//               ),
//               Tab(
//                 child: TabItem(
//                   sourceName: 'Recent Grades',
//                   isSelected: selectedTabIndex == 2,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           SizedBox(
//             height: 300.h,
//             child: TabBarView(
//               children: [
//                 _buildTabContent(),
//                 _buildTabContent(),
//                 _buildTabContent(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTabContent() {
//     return ListView(
//       children: const [
//         ContentBox(
//           icon: Icons.book_outlined,
//           title: 'Calculus Assignment 3',
//           subtitle: 'May 15, 2024',
//         ),
//         ContentBox(
//           icon: Icons.science_outlined,
//           title: 'Physics Lab Report',
//           subtitle: 'May 20, 2024',
//         ),
//       ],
//     );
//   }
// }