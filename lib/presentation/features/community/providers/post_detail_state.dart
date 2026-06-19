import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/domain/entities/community_comment.dart';
import 'package:harvest_app/domain/entities/paginated_response.dart';

part 'post_detail_state.freezed.dart';

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState.initial() = PostDetailInitial;
  const factory PostDetailState.loading() = PostDetailLoading;
  const factory PostDetailState.data(PaginatedResponse<CommunityComment> data) = PostDetailData;
  const factory PostDetailState.error(String message) = PostDetailError;
}
