import 'package:equatable/equatable.dart';
import 'package:harvest_app/features/catalog/domain/entities/product.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/community/domain/entities/review.dart';
import 'farmer.dart';

class FarmerDetail extends Equatable {
  final Farmer farmer;
  final List<Product> products;
  final List<CommunityPost> posts;
  final List<Review> reviews;

  const FarmerDetail({
    required this.farmer,
    required this.products,
    required this.posts,
    required this.reviews,
  });

  @override
  List<Object?> get props => [farmer, products, posts, reviews];
}
