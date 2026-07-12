import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final bool isHelpful;

  const Review({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        rating,
        comment,
        images,
        createdAt,
        isVerifiedPurchase,
        helpfulCount,
        isHelpful,
      ];
}
