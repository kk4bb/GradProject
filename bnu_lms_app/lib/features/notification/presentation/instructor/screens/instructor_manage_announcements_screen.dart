import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/routes_manager/routes.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/announcement_card.dart';
import '../../cubit/notification_cubit.dart';
import '../../cubit/notification_state.dart';
import '../../../../courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import '../../../../courses/presentation/cubit/courses_cubit/courses_state.dart';
import '../../../data/models/announcement_model.dart';
import 'package:intl/intl.dart';

class InstructorManageAnnouncementsScreen extends StatefulWidget {
  const InstructorManageAnnouncementsScreen({super.key});

  @override
  State<InstructorManageAnnouncementsScreen> createState() => _InstructorManageAnnouncementsScreenState();
}

class _InstructorManageAnnouncementsScreenState extends State<InstructorManageAnnouncementsScreen> {
  int? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    // Ensure courses are fetched for the instructor/TA
    final coursesCubit = context.read<CoursesCubit>();
    if (coursesCubit.state is! CoursesLoaded) {
      coursesCubit.fetchAssignedCourses();
    } else {
      final courses = (coursesCubit.state as CoursesLoaded).courses;
      if (courses.isNotEmpty) {
        _selectedCourseId = courses.first.id;
        context.read<NotificationCubit>().getManageCourseAnnouncements(_selectedCourseId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isLight ? ColorsManager.black : ColorsManager.white,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Manage Announcements',
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.createAnnouncement).then((_) {
                  if (_selectedCourseId != null && mounted) {
                    context.read<NotificationCubit>().getManageCourseAnnouncements(_selectedCourseId!);
                  }
                });
              },
              icon: const Icon(Icons.add, color: ColorsManager.white),
              label: const Text(
                'Create Announcement',
                style: TextStyle(color: ColorsManager.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2FBAD7), // Cyan primary
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),

          // Course Dropdown
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter by Course',
                  style: isLight 
                      ? AppLightTextStyles.labelMedium.copyWith(color: ColorsManager.grayMedium)
                      : AppDarkTextStyles.labelMedium.copyWith(color: ColorsManager.darkTextSecondary),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLight ? const Color(0xFFF1F5F9) : ColorsManager.darkSurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: BlocBuilder<CoursesCubit, CoursesState>(
                      builder: (context, state) {
                        if (state is CoursesLoading) {
                          return const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        } else if (state is CoursesLoaded) {
                          final courses = state.courses;
                          if (courses.isEmpty) return const Text('No courses');

                          if (_selectedCourseId == null && courses.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted && _selectedCourseId == null) {
                                setState(() => _selectedCourseId = courses.first.id);
                                context.read<NotificationCubit>().getManageCourseAnnouncements(courses.first.id);
                              }
                            });
                          }

                          return DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: _selectedCourseId ?? (courses.isNotEmpty ? courses.first.id : null),
                              icon: Icon(Icons.keyboard_arrow_down, size: 16, color: isLight ? ColorsManager.grayDark : ColorsManager.white),
                              style: TextStyle(
                                color: isLight ? ColorsManager.black : ColorsManager.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              dropdownColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                              onChanged: (int? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedCourseId = newValue;
                                  });
                                  context.read<NotificationCubit>().getManageCourseAnnouncements(newValue);
                                }
                              },
                              items: courses.map((c) {
                                return DropdownMenuItem<int>(
                                  value: c.id,
                                  child: Text(
                                    c.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List of Announcements
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is AnnouncementLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotificationError) {
                  return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
                } else if (state is NotificationEmpty) {
                  return const Center(child: Text("No announcements found"));
                } else if (state is AnnouncementLoaded) {
                  final announcements = state.announcements as List<AnnouncementModel>;
                  
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final a = announcements[index];
                      // Priority mapping
                      AnnouncementUrgency urgency = AnnouncementUrgency.info;
                      if (a.priority == 1) urgency = AnnouncementUrgency.reminder;
                      if (a.priority == 2) urgency = AnnouncementUrgency.urgent;

                      return AnnouncementCard(
                        title: a.title,
                        course: 'Course ${a.courseId}',
                        target: a.targetSection ?? 'All Sections',
                        time: DateFormat('MMM d, h:mm a').format(a.createdAt),
                        reachCount: 0,
                        isPinned: a.isPinned,
                        urgency: urgency,
                        onEdit: () {
                          Navigator.pushNamed(
                            context, 
                            Routes.createAnnouncement,
                            arguments: {'announcement': a},
                          ).then((_) {
                            if (_selectedCourseId != null && mounted) {
                              this.context.read<NotificationCubit>().getManageCourseAnnouncements(_selectedCourseId!);
                            }
                          });
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Announcement'),
                              content: const Text('Are you sure you want to delete this announcement?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    this.context.read<NotificationCubit>().deleteAnnouncement(a.id);
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        onView: () {},
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
