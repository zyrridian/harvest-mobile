import 'package:harvest_app/features/catalog/data/models/product_model.dart';
import 'package:harvest_app/features/catalog/data/models/product/review_model.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_detail.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'farmer_model.dart';

part 'farmer_detail_model.g.dart';

@JsonSerializable()
class FarmerDetailModel {
  final FarmerModel farmer;
  final List<ProductModel> products;
  final List<ReviewModel> reviews;
  // We handle posts manually because the API returns a different structure
  // for embedded posts compared to the standard CommunityPostModel
  @JsonKey(name: 'posts', fromJson: _parsePosts, toJson: _postsToJson)
  final List<CommunityPost> posts;

  FarmerDetailModel({
    required this.farmer,
    required this.products,
    required this.reviews,
    required this.posts,
  });

  factory FarmerDetailModel.fromJson(Map<String, dynamic> json) {
    // The endpoint returns the farmer fields at the root of the "data" object, 
    // along with products, posts, and reviews.
    // So we can parse the farmer from the exact same JSON!
    final farmerModel = FarmerModel.fromJson(json);
    
    return _$FarmerDetailModelFromJson({
      ...json,
      'farmer': json, // Inject the root json as 'farmer' so FarmerModel can parse it
    });
  }

  Map<String, dynamic> toJson() => _$FarmerDetailModelToJson(this);

  FarmerDetail toEntity() {
    return FarmerDetail(
      farmer: farmer.toEntity(),
      products: products.map((p) => p.toEntity()).toList(),
      posts: posts,
      reviews: reviews.map((r) => r.toEntity()).toList(),
    );
  }

  static List<dynamic> _postsToJson(List<CommunityPost> posts) => [];

  // Custom parser for embedded posts which have a slightly different format
  static List<CommunityPost> _parsePosts(List<dynamic>? json) {
    if (json == null) return [];
    
    return json.map((postJson) {
      if (postJson is! Map<String, dynamic>) return null;
      
      try {
        final author = postJson['author'] as Map<String, dynamic>?;
        
        final imagesRaw = postJson['images'] as List<dynamic>? ?? [];
        final images = imagesRaw.map((e) => e.toString()).toList();
        
        final tagsRaw = postJson['tags'] as List<dynamic>? ?? [];
        final tags = tagsRaw.map((e) => CommunityTag(
          postId: postJson['id']?.toString() ?? '', 
          tag: e.toString()
        )).toList();
        
        return CommunityPost(
          id: postJson['id']?.toString() ?? '',
          userId: author?['id']?.toString() ?? '',
          farmerId: (author != null && author['type'] == 'producer') ? author['id']?.toString() : null,
          title: postJson['title']?.toString() ?? '',
          content: postJson['content']?.toString() ?? '',
          likesCount: (postJson['likes_count'] as num?)?.toInt() ?? 0,
          commentsCount: (postJson['comments_count'] as num?)?.toInt() ?? 0,
          createdAt: postJson['created_at'] != null 
              ? DateTime.parse(postJson['created_at'].toString()) 
              : DateTime.now(),
          updatedAt: postJson['created_at'] != null 
              ? DateTime.parse(postJson['created_at'].toString()) 
              : DateTime.now(),
          user: CommunityUser(
            id: author?['id']?.toString() ?? '',
            name: author?['name']?.toString() ?? 'Unknown User',
            avatarUrl: author?['avatar_url']?.toString(),
            userType: author?['type']?.toString(),
          ),
          farmer: (author != null && author['type'] == 'producer')
              ? CommunityFarmer(
                  id: author['id']?.toString() ?? '',
                  name: author['name']?.toString() ?? 'Unknown Farmer',
                  profileImage: author['avatar_url']?.toString(),
                ) 
              : null,
          images: images,
          tags: tags,
          isLikedByUser: false,
        );
      } catch (e) {
        // If parsing fails for a single post, we skip it
        return null;
      }
    }).whereType<CommunityPost>().toList();
  }
}
