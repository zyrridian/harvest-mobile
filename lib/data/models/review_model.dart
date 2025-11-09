import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/review.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'user_name')
  final String userName;
  @JsonKey(name: 'user_avatar')
  final String? userAvatar;
  final double rating;
  final String comment;
  final List<String> images;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'is_verified_purchase')
  final bool isVerifiedPurchase;
  @JsonKey(name: 'helpful_count')
  final int helpfulCount;
  @JsonKey(name: 'is_helpful')
  final bool isHelpful;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.images = const [],
    required this.createdAt,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    this.isHelpful = false,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  Review toEntity() {
    return Review(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      rating: rating,
      comment: comment,
      images: images,
      createdAt: DateTime.parse(createdAt),
      isVerifiedPurchase: isVerifiedPurchase,
      helpfulCount: helpfulCount,
      isHelpful: isHelpful,
    );
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      userId: review.userId,
      userName: review.userName,
      userAvatar: review.userAvatar,
      rating: review.rating,
      comment: review.comment,
      images: review.images,
      createdAt: review.createdAt.toIso8601String(),
      isVerifiedPurchase: review.isVerifiedPurchase,
      helpfulCount: review.helpfulCount,
      isHelpful: review.isHelpful,
    );
  }
}
