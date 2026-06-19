import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/providers/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'profile_state.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  ProfileState build() {
    _fetchProfileData();
    return const ProfileState.loading();
  }

  Future<void> _fetchProfileData() async {
    state = const ProfileState.loading();
    try {
      final repository = ref.read(userProfileRepositoryProvider);
      final profile = await repository.getUserProfile();
      state = ProfileState.data(profile);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await _fetchProfileData();
  }
}
