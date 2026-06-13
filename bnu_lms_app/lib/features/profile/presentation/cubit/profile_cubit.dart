import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/get_my_profile_use_case.dart';
import 'profile_state.dart';

import 'dart:io';
import '../../domain/use_cases/upload_profile_picture_use_case.dart';
import '../../domain/entities/profile_entity.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final GetMyProfileUseCase getMyProfileUseCase;
  final UploadProfilePictureUseCase uploadProfilePictureUseCase;

  ProfileCubit(
    this.getMyProfileUseCase,
    this.uploadProfilePictureUseCase,
  ) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    final result = await getMyProfileUseCase();
    
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> uploadProfilePicture(File file) async {
    if (state is! ProfileLoaded) return;
    
    final currentProfile = (state as ProfileLoaded).profile;
    
    // We emit loading state so UI knows an upload is in progress
    emit(ProfileLoading());

    final result = await uploadProfilePictureUseCase(file);
    
    if (isClosed) return;
    
    result.fold(
      (failure) {
        // In a real app we might want to emit an error state briefly,
        // then revert to ProfileLoaded. For now, we'll just emit an error.
        emit(ProfileError(failure.message));
        // And we might want to reload the profile to recover
        fetchProfile();
      },
      (newUrl) {
        // Create a new ProfileEntity with the new URL
        final updatedProfile = ProfileEntity(
          id: currentProfile.id,
          email: currentProfile.email,
          firstName: currentProfile.firstName,
          lastName: currentProfile.lastName,
          faculty: currentProfile.faculty,
          academicYear: currentProfile.academicYear,
          creditHours: currentProfile.creditHours,
          enrolledCoursesCount: currentProfile.enrolledCoursesCount,
          gpa: currentProfile.gpa,
          rank: currentProfile.rank,
          studentId: currentProfile.studentId,
          role: currentProfile.role,
          profilePictureUrl: newUrl,
        );
        emit(ProfileLoaded(updatedProfile));
      },
    );
  }
}
