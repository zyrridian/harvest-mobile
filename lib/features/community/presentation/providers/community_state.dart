import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/core/models/paginated_response.dart';

part 'community_state.freezed.dart';

@freezed
class CommunityState with _$CommunityState {
  const factory CommunityState.initial() = CommunityInitial;
  const factory CommunityState.loading() = CommunityLoading;
  const factory CommunityState.data(PaginatedResponse<CommunityPost> data) = CommunityData;
  const factory CommunityState.error(String message) = CommunityError;
}
