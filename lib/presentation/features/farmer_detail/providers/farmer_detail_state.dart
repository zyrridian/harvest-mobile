import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/community_post.dart';
import '../../../../domain/entities/review.dart';

part 'farmer_detail_state.freezed.dart';

@freezed
class FarmerDetailState with _$FarmerDetailState {
  const factory FarmerDetailState({
    @Default(AsyncValue.loading()) AsyncValue<List<Product>> products,
    @Default(AsyncValue.loading()) AsyncValue<List<CommunityPost>> posts,
    @Default(AsyncValue.loading()) AsyncValue<List<Review>> reviews,
  }) = _FarmerDetailState;
}
