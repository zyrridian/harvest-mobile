import 'package:dio/dio.dart';
import '../../models/community_post_model.dart';
import '../../models/post_comment_model.dart';

abstract class CommunityRemoteDataSource {
  Future<List<CommunityPostModel>> getFarmerPosts(String farmerId);
  Future<List<PostCommentModel>> getPostComments(String postId);
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final Dio dio;

  CommunityRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CommunityPostModel>> getFarmerPosts(String farmerId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data - farmer posts
    final mockPosts = _getMockPosts(farmerId);

    return mockPosts.map((json) => CommunityPostModel.fromJson(json)).toList();
  }

  @override
  Future<List<PostCommentModel>> getPostComments(String postId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Mock data - post comments
    final mockComments = _getMockComments(postId);

    return mockComments.map((json) => PostCommentModel.fromJson(json)).toList();
  }

  List<Map<String, dynamic>> _getMockPosts(String farmerId) {
    return [
      {
        'id': 'post_001',
        'farmer_id': farmerId,
        'farmer_name': 'Green Valley Farm',
        'farmer_avatar':
            'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=100',
        'content':
            '🌾 Harvest season is here! Our organic tomatoes are ready to be picked. This year\'s yield is looking exceptional thanks to the good weather and sustainable farming practices. Visit us this weekend!',
        'images': [
          'https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=800',
          'https://images.unsplash.com/photo-1607305387299-a3d9611cd469?w=800',
        ],
        'location': 'Green Valley Farm, Bandung',
        'type': 'harvest',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'like_count': 45,
        'comment_count': 12,
        'is_liked': false,
        'tags': ['organic', 'tomatoes', 'harvest'],
      },
      {
        'id': 'post_002',
        'farmer_id': farmerId,
        'farmer_name': 'Green Valley Farm',
        'farmer_avatar':
            'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=100',
        'content':
            '💡 Farming Tip: Companion planting can help reduce pests naturally! We plant marigolds alongside our vegetables to keep harmful insects away. This reduces our need for chemical pesticides.',
        'images': [
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800',
        ],
        'location': null,
        'type': 'tips',
        'created_at':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'like_count': 78,
        'comment_count': 23,
        'is_liked': true,
        'tags': ['farming tips', 'organic', 'companion planting'],
      },
      {
        'id': 'post_003',
        'farmer_id': farmerId,
        'farmer_name': 'Green Valley Farm',
        'farmer_avatar':
            'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=100',
        'content':
            '📢 Announcement: We\'re hosting a farm tour next Saturday! Learn about sustainable farming, meet our animals, and taste fresh produce. Perfect for families and school groups. Limited slots available!',
        'images': [],
        'location': 'Green Valley Farm, Bandung',
        'type': 'announcement',
        'created_at':
            DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'like_count': 92,
        'comment_count': 34,
        'is_liked': false,
        'tags': ['farm tour', 'event', 'education'],
      },
      {
        'id': 'post_004',
        'farmer_id': farmerId,
        'farmer_name': 'Green Valley Farm',
        'farmer_avatar':
            'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=100',
        'content':
            '🌱 Just planted a new batch of lettuce and spinach! They should be ready for harvest in about 6 weeks. We\'re using our new drip irrigation system which saves 40% more water.',
        'images': [
          'https://images.unsplash.com/photo-1523348837708-15d4a09cfac2?w=800',
        ],
        'location': 'Green Valley Farm, Bandung',
        'type': 'general',
        'created_at':
            DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'like_count': 56,
        'comment_count': 8,
        'is_liked': false,
        'tags': ['planting', 'lettuce', 'sustainable'],
      },
      {
        'id': 'post_005',
        'farmer_id': farmerId,
        'farmer_name': 'Green Valley Farm',
        'farmer_avatar':
            'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46?w=100',
        'content':
            '🎉 Farm Festival this Sunday! Live music, fresh produce market, farm-to-table food stalls, and kids activities. Bring the whole family! Entry is free.',
        'images': [
          'https://images.unsplash.com/photo-1560493676-04071c5f467b?w=800',
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800',
        ],
        'location': 'Green Valley Farm, Bandung',
        'type': 'event',
        'created_at':
            DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'like_count': 134,
        'comment_count': 45,
        'is_liked': true,
        'tags': ['festival', 'event', 'family'],
      },
    ];
  }

  List<Map<String, dynamic>> _getMockComments(String postId) {
    return [
      {
        'id': 'comment_001',
        'post_id': postId,
        'user_id': 'user_001',
        'user_name': 'Sarah Johnson',
        'user_avatar': null,
        'content': 'This looks amazing! Can\'t wait to visit this weekend 🌿',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        'like_count': 5,
        'is_liked': false,
      },
      {
        'id': 'comment_002',
        'post_id': postId,
        'user_id': 'user_002',
        'user_name': 'Ahmad Fauzi',
        'user_avatar': null,
        'content':
            'Do you deliver to Jakarta? I\'d love to order some tomatoes!',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
        'like_count': 2,
        'is_liked': false,
      },
      {
        'id': 'comment_003',
        'post_id': postId,
        'user_id': 'user_003',
        'user_name': 'Linda Martinez',
        'user_avatar': null,
        'content': 'Great farming practices! Keep up the good work 👏',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        'like_count': 8,
        'is_liked': true,
      },
      {
        'id': 'comment_004',
        'post_id': postId,
        'user_id': 'user_004',
        'user_name': 'Budi Santoso',
        'user_avatar': null,
        'content': 'How much per kg for the organic tomatoes?',
        'created_at':
            DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
        'like_count': 1,
        'is_liked': false,
      },
    ];
  }
}
