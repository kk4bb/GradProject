import 'package:bnu_lms_app/shared/resources/app_sizes.dart';
import 'package:bnu_lms_app/shared/resources/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../shared/providers/theme_provider.dart';
import 'package:bnu_lms_app/shared/resources/assets_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubit/profile_cubit.dart';
import '../../presentation/cubit/profile_state.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:bnu_lms_app/shared/config/api_constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: isLight ? AppLightTextStyles.headlineMedium : AppDarkTextStyles.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isLight ? ColorsManager.black : ColorsManager.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar Picker
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ColorsManager.blue, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: ColorsManager.grayMedium.withValues(alpha: 0.1),
                          child: ClipOval(
                            child: _selectedImage != null
                                ? Image.file(_selectedImage!, width: 108, height: 108, fit: BoxFit.cover)
                                : (profile.profilePictureUrl != null && profile.profilePictureUrl!.isNotEmpty
                                    ? Image.network(
                                        profile.profilePictureUrl!.startsWith('http') 
                                            ? profile.profilePictureUrl! 
                                            : '${ApiConstants.baseUrl.replaceAll('api/', '')}${profile.profilePictureUrl!.startsWith('/') ? profile.profilePictureUrl!.substring(1) : profile.profilePictureUrl!}',
                                        width: 108,
                                        height: 108,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.asset(ImagesManager.profileImage, width: 108, height: 108, fit: BoxFit.cover),
                                      )
                                    : Image.asset(ImagesManager.profileImage, width: 108, height: 108, fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _selectedImage = File(image.path);
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorsManager.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: isLight ? Colors.white : ColorsManager.darkBackground, width: 2),
                          ),
                          child: Icon(Icons.camera_alt, size: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // Info Notice
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorsManager.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ColorsManager.blue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: ColorsManager.blue, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Contact Admin to change personal details.",
                            style: (isLight ? AppLightTextStyles.bodyMedium : AppDarkTextStyles.bodyMedium).copyWith(color: ColorsManager.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Read-Only Fields
                  _buildReadOnlyField('Full Name', profile.fullName, isLight),
                  SizedBox(height: 16),
                  _buildReadOnlyField('Email Address', profile.email, isLight),
                  SizedBox(height: 16),
                  _buildReadOnlyField('Role / Title', profile.role ?? 'Student', isLight),
                  SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (_selectedImage != null) {
                                setState(() {
                                  _isSaving = true;
                                });
                                
                                final scaffoldMessenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);
                                
                                await context.read<ProfileCubit>().uploadProfilePicture(_selectedImage!);
                                
                                if (mounted) {
                                  setState(() {
                                    _isSaving = false;
                                  });
                                  scaffoldMessenger.showSnackBar(
                                    const SnackBar(content: Text('Profile updated successfully!')),
                                  );
                                  navigator.pop();
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No changes made.')),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Changes',
                              style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, bool isLight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: (isLight ? AppLightTextStyles.labelMedium : AppDarkTextStyles.labelMedium).copyWith(color: ColorsManager.grayMedium),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.05) : ColorsManager.darkSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorsManager.grayMedium.withValues(alpha: 0.1)),
          ),
          child: Text(
            value,
            style: (isLight ? AppLightTextStyles.titleMedium : AppDarkTextStyles.titleMedium).copyWith(color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary),
          ),
        ),
      ],
    );
  }
}
