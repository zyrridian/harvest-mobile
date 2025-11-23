import 'package:dio/dio.dart';
import '../../models/product_model.dart';
import '../../models/review_model.dart';

abstract class FarmerProductsDataSource {
  Future<List<ProductModel>> getFarmerProducts(String farmerId);
  Future<List<ReviewModel>> getFarmerReviews(String farmerId);
}

class FarmerProductsRemoteDataSourceImpl implements FarmerProductsDataSource {
  final Dio dio;

  FarmerProductsRemoteDataSourceImpl({required this.dio});

  // Mock products data for each farmer
  final Map<String, List<Map<String, dynamic>>> _mockProducts = {
    'farmer_001': [
      {
        'id': 'prod_001',
        'name': 'Organic Tomatoes',
        'description':
            'Fresh organic tomatoes grown without pesticides. Perfect for salads and cooking.',
        'category': 'Vegetables',
        'price': 15000.0,
        'unit': 'kg',
        'image_url':
            'https://images.unsplash.com/photo-1592924357259-3e37f2b6c55e?w=400',
        'images': [
          'https://images.unsplash.com/photo-1592924357259-3e37f2b6c55e?w=400',
          'https://images.unsplash.com/photo-1546470427-227e7d37cfa6?w=400',
        ],
        'is_organic': true,
        'is_available': true,
        'stock': 50,
        'discount': 20.0,
        'rating': 4.8,
        'review_count': 45,
        'farmer_id': 'farmer_001',
        'farmer_name': 'Green Valley Organic Farm',
        'harvest_date': '2025-11-05T00:00:00Z',
        'tags': ['organic', 'fresh', 'local'],
        'created_at': '2025-10-01T00:00:00Z',
      },
      {
        'id': 'prod_002',
        'name': 'Fresh Lettuce',
        'description':
            'Crispy fresh lettuce, perfect for salads. Harvested daily.',
        'category': 'Vegetables',
        'price': 12000.0,
        'unit': 'kg',
        'image_url':
            'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
        'images': [
          'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
        ],
        'is_organic': true,
        'is_available': true,
        'stock': 30,
        'discount': null,
        'rating': 4.5,
        'review_count': 32,
        'farmer_id': 'farmer_001',
        'farmer_name': 'Green Valley Organic Farm',
        'harvest_date': '2025-11-07T00:00:00Z',
        'tags': ['organic', 'fresh'],
        'created_at': '2025-10-05T00:00:00Z',
      },
      {
        'id': 'prod_003',
        'name': 'Sweet Corn',
        'description': 'Sweet and juicy corn, perfect for grilling or boiling.',
        'category': 'Vegetables',
        'price': 8000.0,
        'unit': 'kg',
        'image_url':
            'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
        'images': [
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400',
        ],
        'is_organic': false,
        'is_available': true,
        'stock': 40,
        'discount': null,
        'rating': 4.9,
        'review_count': 67,
        'farmer_id': 'farmer_001',
        'farmer_name': 'Green Valley Organic Farm',
        'harvest_date': null,
        'tags': ['fresh', 'sweet'],
        'created_at': '2025-09-20T00:00:00Z',
      },
      {
        'id': 'prod_004',
        'name': 'Green Beans',
        'description':
            'Fresh green beans, great for stir-fry and healthy meals.',
        'category': 'Vegetables',
        'price': 10000.0,
        'unit': 'kg',
        'image_url':
            'https://images.unsplash.com/photo-1598030876513-6b6f10a5c5b2?w=400',
        'images': [
          'https://images.unsplash.com/photo-1598030876513-6b6f10a5c5b2?w=400',
        ],
        'is_organic': true,
        'is_available': true,
        'stock': 25,
        'discount': null,
        'rating': 4.6,
        'review_count': 28,
        'farmer_id': 'farmer_001',
        'farmer_name': 'Green Valley Organic Farm',
        'harvest_date': '2025-11-06T00:00:00Z',
        'tags': ['organic', 'healthy'],
        'created_at': '2025-10-10T00:00:00Z',
      },
      {
        'id': 'prod_005',
        'name': 'Red Peppers',
        'description': 'Vibrant red peppers, rich in vitamins and flavor.',
        'category': 'Vegetables',
        'price': 18000.0,
        'unit': 'kg',
        'image_url':
            'https://images.unsplash.com/photo-1601493700631-2f5d1e5ceebd?w=400',
        'images': [
          'https://images.unsplash.com/photo-1601493700631-2f5d1e5ceebd?w=400',
        ],
        'is_organic': true,
        'is_available': true,
        'stock': 35,
        'discount': null,
        'rating': 4.7,
        'review_count': 51,
        'farmer_id': 'farmer_001',
        'farmer_name': 'Green Valley Organic Farm',
        'harvest_date': '2025-11-04T00:00:00Z',
        'tags': ['organic', 'colorful'],
        'created_at': '2025-10-15T00:00:00Z',
      },
      {
        'id': 'prod_006',
        'name': 'Carrots',
        'description': 'Crunchy fresh carrots, packed with nutrients.',
        'category': 'Vegetables',
        'price': 7000.0,
        'unit': 'kg',
        'image_url':
            'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
        'images': [
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
        ],
        'is_organic': false,
        'is_available': true,
        'stock': 60,
        'discount': null,
        'rating': 4.4,
        'review_count': 39,
        'farmer_id': 'farmer_001',
        'farmer_name': 'Green Valley Organic Farm',
        'harvest_date': null,
        'tags': ['fresh', 'healthy'],
        'created_at': '2025-09-25T00:00:00Z',
      },
    ],
  };

  // Mock reviews data for each farmer
  final Map<String, List<Map<String, dynamic>>> _mockReviews = {
    'farmer_001': [
      {
        'id': 'rev_001',
        'user_id': 'user_001',
        'user_name': 'John Doe',
        'user_avatar': null,
        'rating': 5.0,
        'comment':
            'Great quality products! Fresh and organic. Will definitely buy again. The vegetables arrived in perfect condition and tasted amazing.',
        'images': [],
        'created_at': '2025-11-08T00:00:00Z',
        'is_verified_purchase': true,
        'helpful_count': 12,
        'is_helpful': false,
      },
      {
        'id': 'rev_002',
        'user_id': 'user_002',
        'user_name': 'Jane Smith',
        'user_avatar': null,
        'rating': 4.0,
        'comment':
            'Good service and fast delivery. The vegetables are always fresh. I appreciate the farmer\'s dedication to quality.',
        'images': [],
        'created_at': '2025-11-06T00:00:00Z',
        'is_verified_purchase': false,
        'helpful_count': 8,
        'is_helpful': false,
      },
      {
        'id': 'rev_003',
        'user_id': 'user_003',
        'user_name': 'Ahmad',
        'user_avatar': null,
        'rating': 5.0,
        'comment':
            'Best farmer in the area. Always reliable and honest pricing. Very professional and the organic certification is authentic.',
        'images': [],
        'created_at': '2025-11-04T00:00:00Z',
        'is_verified_purchase': true,
        'helpful_count': 15,
        'is_helpful': false,
      },
      {
        'id': 'rev_004',
        'user_id': 'user_004',
        'user_name': 'Sarah',
        'user_avatar': null,
        'rating': 4.5,
        'comment':
            'Very professional and friendly. Products are top quality. The packaging was excellent and everything was well-labeled.',
        'images': [],
        'created_at': '2025-11-02T00:00:00Z',
        'is_verified_purchase': true,
        'helpful_count': 6,
        'is_helpful': false,
      },
      {
        'id': 'rev_005',
        'user_id': 'user_005',
        'user_name': 'Michael',
        'user_avatar': null,
        'rating': 4.0,
        'comment':
            'Satisfied with the purchase. Everything arrived in good condition. The prices are fair and the quality is consistently good.',
        'images': [],
        'created_at': '2025-10-30T00:00:00Z',
        'is_verified_purchase': false,
        'helpful_count': 10,
        'is_helpful': false,
      },
    ],
  };

  @override
  Future<List<ProductModel>> getFarmerProducts(String farmerId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final products = _mockProducts[farmerId] ?? [];

    return products.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<ReviewModel>> getFarmerReviews(String farmerId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));

    final reviews = _mockReviews[farmerId] ?? [];

    return reviews.map((json) => ReviewModel.fromJson(json)).toList();
  }
}
