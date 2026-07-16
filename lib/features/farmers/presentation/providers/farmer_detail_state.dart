import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import 'package:harvest_app/features/catalog/domain/entities/product.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/community/domain/entities/review.dart';

part 'farmer_detail_state.freezed.dart';

@freezed
class FarmerDetailState with _$FarmerDetailState {
  const factory FarmerDetailState({
    @Default(AsyncValue.loading()) AsyncValue<Farmer> farmerDetail,
    @Default(AsyncValue.loading()) AsyncValue<List<Product>> products,
    @Default(AsyncValue.loading()) AsyncValue<List<CommunityPost>> posts,
    @Default(AsyncValue.loading()) AsyncValue<List<Review>> reviews,
  }) = _FarmerDetailState;
}
