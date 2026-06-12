import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/notification_cubit.dart';
import '../../cubit/notification_state.dart';
import '../../../../courses/presentation/cubit/courses_cubit/courses_cubit.dart';
import '../../../../courses/presentation/cubit/courses_cubit/courses_state.dart';

import '../../../data/models/announcement_model.dart';
import '../../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../../auth/presentation/cubit/auth_state.dart';
import '../../../../auth/domain/entities/auth_entity.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  final AnnouncementModel? editAnnouncement;

  const CreateAnnouncementScreen({super.key, this.editAnnouncement});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  bool _isPinned = false;
  String _targetAudience = 'All Users';
  String _academicSection = 'All Sections';
  int? _selectedCourseId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final coursesCubit = context.read<CoursesCubit>();
    if (coursesCubit.state is! CoursesLoaded) {
      coursesCubit.fetchAssignedCourses();
    }

    if (widget.editAnnouncement != null) {
      final a = widget.editAnnouncement!;
      _titleController.text = a.title;
      _contentController.text = a.content;
      _selectedCourseId = a.courseId;
      _isPinned = a.isPinned;
      if (a.targetSection != null) {
        if (a.targetSection == 'TA') {
          _targetAudience = 'TAs';
        } else if (a.targetSection == 'Instructor' || a.targetSection == 'Doctor') {
          _targetAudience = 'Instructor/Doctor';
        } else {
          _academicSection = a.targetSection!;
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
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
          widget.editAnnouncement != null ? 'Edit Announcement' : 'New Announcement',
          style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Title',
              style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLight ? const Color(0xFFE2E8F0) : ColorsManager.darkBackground,
                ),
              ),
              child: TextField(
                controller: _titleController,
                style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.white),
                decoration: InputDecoration(
                  hintText: 'Enter announcement title...',
                  hintStyle: TextStyle(color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Course Selection
            Text(
              'Select Course',
              style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
            ),
            SizedBox(height: 8),
            BlocBuilder<CoursesCubit, CoursesState>(
              builder: (context, state) {
                if (state is CoursesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CoursesLoaded) {
                  final courses = state.courses;
                  if (courses.isEmpty) {
                    return const Text('No assigned courses found.');
                  }
                  
                  // Default selection to first course if null
                  if (_selectedCourseId == null && courses.isNotEmpty) {
                    // We need to defer state update to avoid build-phase errors
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _selectedCourseId == null) {
                        setState(() => _selectedCourseId = courses.first.id);
                      }
                    });
                  }

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isLight ? const Color(0xFFE2E8F0) : ColorsManager.darkBackground,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedCourseId ?? (courses.isNotEmpty ? courses.first.id : null),
                        icon: Icon(Icons.keyboard_arrow_down, color: isLight ? ColorsManager.grayDark : ColorsManager.white),
                        dropdownColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                        style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.white, fontSize: 14),
                        onChanged: (val) => setState(() => _selectedCourseId = val),
                        items: courses.map((c) {
                          return DropdownMenuItem<int>(
                            value: c.id,
                            child: Text(c.title),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 24),

            // Content
            Text(
              'Content',
              style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isLight ? const Color(0xFFE2E8F0) : ColorsManager.darkBackground,
                ),
              ),
              child: TextField(
                controller: _contentController,
                style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.white),
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Write your announcement here...',
                  hintStyle: TextStyle(color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Target Audience & Section Dropdowns
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Audience',
                        style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                      ),
                      SizedBox(height: 8),
                      Builder(builder: (context) {
                        final authState = context.read<AuthCubit>().state;
                        bool isTa = false;
                        if (authState is AuthSuccess && authState.auth.role.isTa) {
                          isTa = true;
                        }
                        
                        List<String> audiences = ['All Users', 'Students', 'TAs'];
                        if (isTa) {
                          audiences.add('Instructor/Doctor');
                        }

                        // Ensure current selection is valid
                        if (!audiences.contains(_targetAudience)) {
                           _targetAudience = audiences.first;
                        }

                        return _buildDropdown(
                          context,
                          isLight,
                          _targetAudience,
                          audiences,
                          (val) => setState(() => _targetAudience = val!),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Academic Section',
                        style: isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium,
                      ),
                      SizedBox(height: 8),
                      _buildDropdown(
                        context,
                        isLight,
                        _academicSection,
                        ['All Sections', 'Section 1', 'Section 2', 'Section 3'],
                        (val) => setState(() => _academicSection = val!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Pin Announcement Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pin Announcement',
                      style: isLight 
                          ? AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)
                          : AppDarkTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Keep at top of students\' feeds',
                      style: isLight 
                          ? AppLightTextStyles.labelSmall.copyWith(color: ColorsManager.grayMedium)
                          : AppDarkTextStyles.labelSmall.copyWith(color: ColorsManager.darkTextSecondary),
                    ),
                  ],
                ),
                Switch(
                  value: _isPinned,
                  onChanged: (value) {
                    setState(() {
                      _isPinned = value;
                    });
                  },
                  activeThumbColor: const Color(0xFF2FBAD7),
                  activeTrackColor: const Color(0xFF2FBAD7).withValues(alpha: 0.3),
                ),
              ],
            ),
            SizedBox(height: 48),

            // Publish Button
            BlocConsumer<NotificationCubit, NotificationState>(
              listener: (context, state) {
                if (state is AnnouncementPostedSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Announcement published successfully!')),
                  );
                  Navigator.pop(context);
                } else if (state is NotificationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill title and content')),
                      );
                      return;
                    }
                    if (_selectedCourseId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a course')),
                      );
                      return;
                    }

                    String? finalTargetSection;
                    if (_targetAudience == 'TAs') {
                      finalTargetSection = 'TA';
                    } else if (_targetAudience == 'Instructor/Doctor') {
                      finalTargetSection = 'Instructor';
                    } else if (_academicSection != 'All Sections') {
                      finalTargetSection = _academicSection;
                    }

                    if (widget.editAnnouncement != null) {
                      context.read<NotificationCubit>().updateAnnouncement(
                        widget.editAnnouncement!.id,
                        {
                          'title': _titleController.text,
                          'content': _contentController.text,
                          'targetSection': finalTargetSection,
                          'priority': _targetAudience == 'All Users' ? 0 : 1,
                          'isPinned': _isPinned,
                        }
                      );
                    } else {
                      context.read<NotificationCubit>().postAnnouncement({
                        'courseId': _selectedCourseId,
                        'title': _titleController.text,
                        'content': _contentController.text,
                        'targetSection': finalTargetSection,
                        'priority': _targetAudience == 'All Users' ? 0 : 1,
                        'isPinned': _isPinned,
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2FBAD7), // Cyan primary
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.editAnnouncement != null ? 'Update Announcement' : 'Publish Announcement',
                    style: const TextStyle(
                      color: ColorsManager.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, bool isLight, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLight ? const Color(0xFFE2E8F0) : ColorsManager.darkBackground,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: isLight ? ColorsManager.grayDark : ColorsManager.white),
          style: TextStyle(
            color: isLight ? ColorsManager.black : ColorsManager.white,
            fontSize: 14,
          ),
          dropdownColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
        ),
      ),
    );
  }
}
