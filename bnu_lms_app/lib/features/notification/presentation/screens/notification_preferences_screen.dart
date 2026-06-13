import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../../auth/domain/entities/auth_entity.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  bool _assignments = true;
  bool _quizzes = true;
  bool _grades = true;
  bool _attendance = false;
  bool _announcements = true;
  bool _forums = true;
  String _lastUpdated = '';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _assignments  = prefs.getBool('pref_assignments')  ?? true;
      _quizzes      = prefs.getBool('pref_quizzes')      ?? true;
      _grades       = prefs.getBool('pref_grades')       ?? true;
      _attendance   = prefs.getBool('pref_attendance')   ?? false;
      _announcements= prefs.getBool('pref_announcements')?? true;
      _forums       = prefs.getBool('pref_forums')       ?? true;
      final ts = prefs.getInt('pref_last_saved');
      _lastUpdated  = ts != null
          ? DateFormat('d MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ts))
          : 'Never';
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_assignments',   _assignments);
    await prefs.setBool('pref_quizzes',       _quizzes);
    await prefs.setBool('pref_grades',        _grades);
    await prefs.setBool('pref_attendance',    _attendance);
    await prefs.setBool('pref_announcements', _announcements);
    await prefs.setBool('pref_forums',        _forums);
    await prefs.setInt('pref_last_saved',     DateTime.now().millisecondsSinceEpoch);
    if (mounted) {
      setState(() {
        _lastUpdated = DateFormat('d MMM yyyy, hh:mm a').format(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    final authState = context.read<AuthCubit>().state;
    bool isStudent = true; // default fallback
    if (authState is AuthSuccess) {
      isStudent = authState.auth.role.isStudent;
    }

    return Scaffold(
      backgroundColor: isLight ? const Color(0xFFF8FAFC) : ColorsManager.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isLight ? ColorsManager.black : ColorsManager.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: isLight 
                  ? AppLightTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold) 
                  : AppDarkTextStyles.headlineLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Manage how you receive updates about your courses and academic progress.',
              style: isLight 
                  ? AppLightTextStyles.bodyMedium.copyWith(color: const Color(0xFF475569)) 
                  : AppDarkTextStyles.bodyMedium.copyWith(color: ColorsManager.darkTextSecondary),
            ),
            SizedBox(height: 32),

            // Coursework & Assessment Section (Students Only)
            if (isStudent) ...[
              Container(
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isLight ? const Color(0xFFE2E8F0) : ColorsManager.darkBackground,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20, bottom: 8),
                      child: Text(
                        'COURSEWORK & ASSESSMENT',
                        style: TextStyle(
                          color: isLight ? const Color(0xFF94A3B8) : ColorsManager.darkTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    if (isLight) const Divider(color: Color(0xFFF1F5F9), height: 1),
                    _buildPreferenceItem(
                      isLight,
                      icon: Icons.assignment_outlined,
                      title: 'Assignments',
                      subtitle: 'Due dates, submissions, and feedback',
                      value: _assignments,
                      onChanged: (val) { setState(() => _assignments = val); _savePrefs(); },
                    ),
                    if (isLight) const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                    _buildPreferenceItem(
                      isLight,
                      icon: Icons.quiz_outlined,
                      title: 'Quizzes',
                      subtitle: 'Available tests and time reminders',
                      value: _quizzes,
                      onChanged: (val) { setState(() => _quizzes = val); _savePrefs(); },
                    ),
                    if (isLight) const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                    _buildPreferenceItem(
                      isLight,
                      icon: Icons.star_border,
                      title: 'Grades',
                      subtitle: 'Published scores and final results',
                      value: _grades,
                      onChanged: (val) { setState(() => _grades = val); _savePrefs(); },
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],

            // Administration Section
            Container(
              decoration: BoxDecoration(
                color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLight ? const Color(0xFFE2E8F0) : ColorsManager.darkBackground,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 20, bottom: 8),
                    child: Text(
                      'ADMINISTRATION',
                      style: TextStyle(
                        color: isLight ? const Color(0xFF94A3B8) : ColorsManager.darkTextSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (isLight) const Divider(color: Color(0xFFF1F5F9), height: 1),
                  if (isStudent) ...[
                    _buildPreferenceItem(
                      isLight,
                      icon: Icons.person_outline,
                      title: 'Attendance',
                      subtitle: 'Presence records and missing alerts',
                      value: _attendance,
                      onChanged: (val) { setState(() => _attendance = val); _savePrefs(); },
                    ),
                    if (isLight) const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                  ],
                  _buildPreferenceItem(
                    isLight,
                    icon: Icons.campaign_outlined,
                    title: 'Announcements',
                    subtitle: 'Institute news and emergency alerts',
                    value: _announcements,
                    onChanged: (val) { setState(() => _announcements = val); _savePrefs(); },
                  ),
                  if (isLight) const Divider(color: Color(0xFFF1F5F9), height: 1, indent: 64),
                  _buildPreferenceItem(
                    isLight,
                    icon: Icons.forum_outlined,
                    title: 'Forums & Discussions',
                    subtitle: 'New threads, replies, and mentions',
                    value: _forums,
                    onChanged: (val) { setState(() => _forums = val); _savePrefs(); },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Update Preferences Button
            ElevatedButton(
              onPressed: () async {
                await _savePrefs();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preferences saved!'),
                      backgroundColor: ColorsManager.blue,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.blue,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Update Preferences',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  const Icon(Icons.check, color: Colors.white, size: 20),
                ],
              ),
            ),

            SizedBox(height: 16),
            Center(
              child: Text(
                _lastUpdated.isEmpty ? '' : 'Last updated: $_lastUpdated',
                style: TextStyle(
                  color: isLight ? const Color(0xFF94A3B8) : ColorsManager.darkTextSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(
    bool isLight, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isLight ? const Color(0xFFEAF8FB) : ColorsManager.darkBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2FBAD7), // Cyan icon color
              size: 22,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isLight ? const Color(0xFF0F172A) : ColorsManager.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isLight ? const Color(0xFF64748B) : ColorsManager.darkTextSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF2FBAD7),
            inactiveThumbColor: isLight ? Colors.white : ColorsManager.grayMedium,
            inactiveTrackColor: isLight ? const Color(0xFFE2E8F0) : ColorsManager.darkBackground,
          ),
        ],
      ),
    );
  }
}
