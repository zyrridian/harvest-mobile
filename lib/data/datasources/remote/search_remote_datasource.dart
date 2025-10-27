import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../models/product_model.dart';

abstract class SearchRemoteDataSource {
  /// Search products from API
  ///
  /// Endpoint: GET /api/products/search
  ///
  /// Query Parameters:
  /// - q: search query
  /// - sort_by: relevance|price|distance|newest|rating
  /// - min_price: minimum price filter
  /// - max_price: maximum price filter
  /// - categories: comma-separated category names
  /// - types: comma-separated type names (organic, fresh, local)
  /// - page: page number (default: 1)
  /// - limit: items per page (default: 20)
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? types,
    int? page,
    int? limit,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> searchProducts({
    required String query,
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    List<String>? categories,
    List<String>? types,
    int? page,
    int? limit,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{
        'q': query,
        if (sortBy != null) 'sort_by': sortBy,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (categories != null && categories.isNotEmpty)
          'categories': categories.join(','),
        if (types != null && types.isNotEmpty) 'types': types.join(','),
        'page': page ?? 1,
        'limit': limit ?? 20,
      };

      // For now, return mock data as if from API
      // In production, this would be:
      // final response = await dio.get('/api/products/search', queryParameters: queryParams);

      // Simulate API response with local JSON data
      final mockResponse = _getMockApiResponse(queryParams);

      final List<dynamic> data = mockResponse['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException('An unexpected error occurred');
    }
  }

  // Mock API response - simulates backend JSON response
  Map<String, dynamic> _getMockApiResponse(Map<String, dynamic> queryParams) {
    final products = _mockProducts;

    // Apply filters
    var filteredProducts = List<Map<String, dynamic>>.from(products);

    // Filter by search query
    if (queryParams['q'] != null && queryParams['q'].toString().isNotEmpty) {
      final searchQuery = queryParams['q'].toString().toLowerCase();
      filteredProducts = filteredProducts.where((p) {
        return p['name'].toString().toLowerCase().contains(searchQuery) ||
            p['description'].toString().toLowerCase().contains(searchQuery) ||
            p['category'].toString().toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Filter by price range
    if (queryParams['min_price'] != null) {
      filteredProducts = filteredProducts.where((p) {
        return p['price'] >= queryParams['min_price'];
      }).toList();
    }
    if (queryParams['max_price'] != null) {
      filteredProducts = filteredProducts.where((p) {
        return p['price'] <= queryParams['max_price'];
      }).toList();
    }

    // Filter by categories
    if (queryParams['categories'] != null) {
      final categories = queryParams['categories'].toString().split(',');
      filteredProducts = filteredProducts.where((p) {
        return categories.contains(p['category']);
      }).toList();
    }

    // Filter by types
    if (queryParams['types'] != null) {
      final types = queryParams['types'].toString().split(',');
      filteredProducts = filteredProducts.where((p) {
        final productTypes = List<String>.from(p['types']);
        return types.any((type) => productTypes.contains(type));
      }).toList();
    }

    // Sort results
    if (queryParams['sort_by'] != null) {
      switch (queryParams['sort_by']) {
        case 'price':
          filteredProducts.sort((a, b) => a['price'].compareTo(b['price']));
          break;
        case 'distance':
          filteredProducts
              .sort((a, b) => a['distance'].compareTo(b['distance']));
          break;
        case 'rating':
          filteredProducts.sort((a, b) => b['rating'].compareTo(a['rating']));
          break;
        case 'newest':
          filteredProducts
              .sort((a, b) => b['created_at'].compareTo(a['created_at']));
          break;
        default: // relevance
          break;
      }
    }

    return {
      'success': true,
      'data': filteredProducts,
      'meta': {
        'total': filteredProducts.length,
        'page': queryParams['page'] ?? 1,
        'limit': queryParams['limit'] ?? 20,
      }
    };
  }

  // Mock product data - simulates API database
  static final List<Map<String, dynamic>> _mockProducts = [
    {
      'id': '1',
      'name': 'Organic Fresh Tomatoes',
      'description': 'Fresh organic tomatoes from local farms',
      'store_name': 'Green Farm Market',
      'store_id': 'store_1',
      'distance': 1.2,
      'price': 2.50,
      'unit': 'per kg',
      'rating': 4.8,
      'stock': 120,
      'tag': 'Organic',
      'image_url':
          'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=400',
      'category': 'Vegetables',
      'types': ['Organic', 'Fresh'],
      'created_at': '2024-10-20T10:00:00Z',
    },
    {
      'id': '2',
      'name': 'Fresh Red Apples',
      'description': 'Crispy and sweet red apples',
      'store_name': 'Fruit Paradise',
      'store_id': 'store_2',
      'distance': 2.5,
      'price': 3.20,
      'unit': 'per kg',
      'rating': 4.9,
      'stock': 85,
      'tag': 'Fresh',
      'image_url':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
      'category': 'Fruits',
      'types': ['Fresh', 'Local'],
      'created_at': '2024-10-21T10:00:00Z',
    },
    {
      'id': '3',
      'name': 'Green Lettuce',
      'description': 'Crispy organic lettuce perfect for salads',
      'store_name': 'Organic Valley',
      'store_id': 'store_3',
      'distance': 0.8,
      'price': 1.80,
      'unit': 'per pcs',
      'rating': 4.7,
      'stock': 45,
      'tag': 'Organic',
      'image_url':
          'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
      'category': 'Vegetables',
      'types': ['Organic'],
      'created_at': '2024-10-22T10:00:00Z',
    },
    {
      'id': '4',
      'name': 'Sweet Potatoes',
      'description': 'Nutritious sweet potatoes',
      'store_name': 'Farm Fresh Store',
      'store_id': 'store_4',
      'distance': 3.1,
      'price': 2.00,
      'unit': 'per kg',
      'rating': 4.6,
      'stock': 95,
      'tag': 'Fresh',
      'image_url':
          'https://images.unsplash.com/photo-1589927986089-35812636d30a?w=400',
      'category': 'Vegetables',
      'types': ['Fresh', 'Local'],
      'created_at': '2024-10-23T10:00:00Z',
    },
    {
      'id': '5',
      'name': 'Bell Peppers Mix',
      'description': 'Colorful mix of bell peppers',
      'store_name': 'Veggie Corner',
      'store_id': 'store_5',
      'distance': 1.9,
      'price': 4.50,
      'unit': 'per kg',
      'rating': 4.8,
      'stock': 62,
      'tag': 'New',
      'image_url':
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      'category': 'Vegetables',
      'types': ['Fresh'],
      'created_at': '2024-10-25T10:00:00Z',
    },
    {
      'id': '6',
      'name': 'Fresh Spinach',
      'description': 'Fresh organic spinach bundle',
      'store_name': 'Green Leaf Market',
      'store_id': 'store_6',
      'distance': 1.5,
      'price': 2.30,
      'unit': 'per bundle',
      'rating': 4.9,
      'stock': 38,
      'tag': 'Organic',
      'image_url':
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      'category': 'Vegetables',
      'types': ['Organic', 'Fresh'],
      'created_at': '2024-10-24T10:00:00Z',
    },
    {
      'id': '7',
      'name': 'Organic Carrots',
      'description': 'Fresh organic carrots from local farms',
      'store_name': 'Nature\'s Best',
      'store_id': 'store_7',
      'distance': 2.2,
      'price': 1.95,
      'unit': 'per kg',
      'rating': 4.7,
      'stock': 110,
      'tag': 'Organic',
      'image_url':
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
      'category': 'Vegetables',
      'types': ['Organic', 'Local'],
      'created_at': '2024-10-26T10:00:00Z',
    },
    {
      'id': '8',
      'name': 'Fresh Broccoli',
      'description': 'Fresh green broccoli heads',
      'store_name': 'Farm Fresh Store',
      'store_id': 'store_4',
      'distance': 1.7,
      'price': 3.00,
      'unit': 'per pcs',
      'rating': 4.8,
      'stock': 72,
      'tag': 'Fresh',
      'image_url':
          'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400',
      'category': 'Vegetables',
      'types': ['Fresh', 'Local'],
      'created_at': '2024-10-27T10:00:00Z',
    },
    {
      'id': '9',
      'name': 'Organic Bananas',
      'description': 'Sweet organic bananas',
      'store_name': 'Fruit Paradise',
      'store_id': 'store_2',
      'distance': 2.5,
      'price': 2.80,
      'unit': 'per kg',
      'rating': 4.6,
      'stock': 150,
      'tag': 'Organic',
      'image_url':
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
      'category': 'Fruits',
      'types': ['Organic'],
      'created_at': '2024-10-19T10:00:00Z',
    },
    {
      'id': '10',
      'name': 'Fresh Strawberries',
      'description': 'Sweet and juicy strawberries',
      'store_name': 'Berry Farm',
      'store_id': 'store_8',
      'distance': 3.5,
      'price': 5.50,
      'unit': 'per kg',
      'rating': 5.0,
      'stock': 30,
      'tag': 'Fresh',
      'image_url':
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
      'category': 'Fruits',
      'types': ['Fresh', 'Local'],
      'created_at': '2024-10-27T08:00:00Z',
    },
  ];
}
