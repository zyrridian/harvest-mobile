import 'package:equatable/equatable.dart';
import 'farmer.dart';
import '../../features/catalog/domain/entities/product.dart';
import '../../features/community/domain/entities/community_post.dart';
import '../../features/community/domain/entities/review.dart';

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
