import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/user_profile.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = ProfileInitial;
  const factory ProfileState.loading() = ProfileLoading;
  const factory ProfileState.data(UserProfile profile) = ProfileData;
  const factory ProfileState.error(String message) = ProfileError;
}
