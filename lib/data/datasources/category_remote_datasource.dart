import 'package:harvest_app/data/models/category_model.dart';
import 'package:harvest_app/data/models/category_product_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String categoryId);
  Future<List<CategoryProductModel>> getCategoryProducts(String categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  // Simulated API delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    await _simulateNetworkDelay();

    return [
      CategoryModel(
        id: 'vegetables',
        name: 'Vegetables',
        description: 'Fresh organic vegetables from local farmers',
        emoji: '🥦',
        gradientColors: ['#D4E2D4', '#B8C6B8'],
        productCount: 45,
      ),
      CategoryModel(
        id: 'fruits',
        name: 'Fruits',
        description: 'Seasonal fruits picked at peak ripeness',
        emoji: '🍓',
        gradientColors: ['#FFE5D9', '#FFD1BC'],
        productCount: 38,
      ),
      CategoryModel(
        id: 'meat',
        name: 'Meat',
        description: 'Premium quality meat from trusted sources',
        emoji: '🥩',
        gradientColors: ['#F2E6E6', '#E6D0D0'],
        productCount: 22,
      ),
      CategoryModel(
        id: 'fish',
        name: 'Fish',
        description: 'Fresh catch delivered daily',
        emoji: '🐟',
        gradientColors: ['#DBEAFE', '#93C5FD'],
        productCount: 18,
      ),
      CategoryModel(
        id: 'dairy',
        name: 'Dairy',
        description: 'Farm-fresh dairy products',
        emoji: '🧀',
        gradientColors: ['#FFF9E6', '#FFF0C2'],
        productCount: 28,
      ),
      CategoryModel(
        id: 'eggs',
        name: 'Eggs',
        description: 'Free-range eggs from happy hens',
        emoji: '🥚',
        gradientColors: ['#FEF9C3', '#FDE047'],
        productCount: 12,
      ),
      CategoryModel(
        id: 'grains',
        name: 'Grains',
        description: 'Wholesome grains and cereals',
        emoji: '🌾',
        gradientColors: ['#F0EAD6', '#E6DEBF'],
        productCount: 31,
      ),
      CategoryModel(
        id: 'herbs',
        name: 'Herbs',
        description: 'Fresh herbs and spices',
        emoji: '🌿',
        gradientColors: ['#E8F5E9', '#C8E6C9'],
        productCount: 24,
      ),
      CategoryModel(
        id: 'nuts',
        name: 'Nuts & Seeds',
        description: 'Nutritious nuts and seeds',
        emoji: '🥜',
        gradientColors: ['#FFEEE0', '#FFE0C7'],
        productCount: 16,
      ),
      CategoryModel(
        id: 'honey',
        name: 'Honey',
        description: 'Pure raw honey from local beekeepers',
        emoji: '🍯',
        gradientColors: ['#FFF4E6', '#FFE8CC'],
        productCount: 8,
      ),
    ];
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    await _simulateNetworkDelay();
    final categories = await getAllCategories();
    return categories.firstWhere((c) => c.id == categoryId);
  }

  @override
  Future<List<CategoryProductModel>> getCategoryProducts(
      String categoryId) async {
    await _simulateNetworkDelay();

    // Mock products for different categories
    final Map<String, List<CategoryProductModel>> mockProducts = {
      'vegetables': [
        CategoryProductModel(
          id: 'veg_001',
          name: 'Organic Spinach',
          categoryId: 'vegetables',
          categoryName: 'Vegetables',
          sellerId: 'farmer_001',
          sellerName: 'Green Valley Farm',
          price: 3.99,
          unit: 'bunch',
          imageUrl:
              'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
          rating: 4.8,
          reviewCount: 124,
          isOrganic: true,
          stockQuantity: 45,
        ),
        CategoryProductModel(
          id: 'veg_002',
          name: 'Fresh Lettuce',
          categoryId: 'vegetables',
          categoryName: 'Vegetables',
          sellerId: 'farmer_001',
          sellerName: 'Green Valley Farm',
          price: 2.49,
          unit: 'head',
          imageUrl:
              'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
          rating: 4.7,
          reviewCount: 98,
          isOrganic: true,
          stockQuantity: 60,
        ),
        CategoryProductModel(
          id: 'veg_003',
          name: 'Cherry Tomatoes',
          categoryId: 'vegetables',
          categoryName: 'Vegetables',
          sellerId: 'farmer_002',
          sellerName: 'Sunrise Organic',
          price: 4.99,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
          rating: 4.9,
          reviewCount: 156,
          isPremium: true,
          isOrganic: true,
          stockQuantity: 38,
          discount: '10% OFF',
        ),
        CategoryProductModel(
          id: 'veg_004',
          name: 'Fresh Carrots',
          categoryId: 'vegetables',
          categoryName: 'Vegetables',
          sellerId: 'farmer_003',
          sellerName: 'Fresh Fields Co.',
          price: 3.49,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
          rating: 4.6,
          reviewCount: 89,
          isOrganic: false,
          stockQuantity: 52,
        ),
        CategoryProductModel(
          id: 'veg_005',
          name: 'Bell Peppers Mix',
          categoryId: 'vegetables',
          categoryName: 'Vegetables',
          sellerId: 'farmer_002',
          sellerName: 'Sunrise Organic',
          price: 5.99,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
          rating: 4.8,
          reviewCount: 142,
          isOrganic: true,
          stockQuantity: 33,
        ),
        CategoryProductModel(
          id: 'veg_006',
          name: 'Fresh Broccoli',
          categoryId: 'vegetables',
          categoryName: 'Vegetables',
          sellerId: 'farmer_001',
          sellerName: 'Green Valley Farm',
          price: 4.49,
          unit: 'head',
          imageUrl:
              'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400',
          rating: 4.7,
          reviewCount: 76,
          isOrganic: true,
          stockQuantity: 28,
        ),
      ],
      'fruits': [
        CategoryProductModel(
          id: 'fruit_001',
          name: 'Strawberries',
          categoryId: 'fruits',
          categoryName: 'Fruits',
          sellerId: 'farmer_002',
          sellerName: 'Sunrise Organic',
          price: 6.99,
          unit: 'punnet',
          imageUrl:
              'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
          rating: 4.9,
          reviewCount: 203,
          isPremium: true,
          isOrganic: true,
          stockQuantity: 24,
        ),
        CategoryProductModel(
          id: 'fruit_002',
          name: 'Fresh Apples',
          categoryId: 'fruits',
          categoryName: 'Fruits',
          sellerId: 'farmer_001',
          sellerName: 'Green Valley Farm',
          price: 4.99,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
          rating: 4.7,
          reviewCount: 145,
          isOrganic: false,
          stockQuantity: 67,
        ),
        CategoryProductModel(
          id: 'fruit_003',
          name: 'Organic Bananas',
          categoryId: 'fruits',
          categoryName: 'Fruits',
          sellerId: 'farmer_003',
          sellerName: 'Fresh Fields Co.',
          price: 3.49,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
          rating: 4.6,
          reviewCount: 178,
          isOrganic: true,
          stockQuantity: 89,
        ),
        CategoryProductModel(
          id: 'fruit_004',
          name: 'Sweet Oranges',
          categoryId: 'fruits',
          categoryName: 'Fruits',
          sellerId: 'farmer_002',
          sellerName: 'Sunrise Organic',
          price: 5.49,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
          rating: 4.8,
          reviewCount: 167,
          isOrganic: true,
          stockQuantity: 45,
          discount: '15% OFF',
        ),
      ],
      'meat': [
        CategoryProductModel(
          id: 'meat_001',
          name: 'Premium Beef',
          categoryId: 'meat',
          categoryName: 'Meat',
          sellerId: 'butcher_001',
          sellerName: 'Quality Meats Co.',
          price: 18.99,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1603048588665-791ca8aea617?w=400',
          rating: 4.9,
          reviewCount: 234,
          isPremium: true,
          stockQuantity: 15,
        ),
        CategoryProductModel(
          id: 'meat_002',
          name: 'Chicken Breast',
          categoryId: 'meat',
          categoryName: 'Meat',
          sellerId: 'butcher_001',
          sellerName: 'Quality Meats Co.',
          price: 12.99,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400',
          rating: 4.7,
          reviewCount: 189,
          stockQuantity: 28,
        ),
      ],
      'fish': [
        CategoryProductModel(
          id: 'fish_001',
          name: 'Fresh Salmon',
          categoryId: 'fish',
          categoryName: 'Fish',
          sellerId: 'fisher_001',
          sellerName: 'Ocean Fresh Market',
          price: 22.99,
          unit: 'kg',
          imageUrl:
              'https://images.unsplash.com/photo-1599084993091-1cb5c0721cc6?w=400',
          rating: 4.8,
          reviewCount: 167,
          isPremium: true,
          stockQuantity: 12,
        ),
      ],
      'dairy': [
        CategoryProductModel(
          id: 'dairy_001',
          name: 'Fresh Milk',
          categoryId: 'dairy',
          categoryName: 'Dairy',
          sellerId: 'farmer_001',
          sellerName: 'Green Valley Farm',
          price: 4.99,
          unit: 'liter',
          imageUrl:
              'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
          rating: 4.9,
          reviewCount: 245,
          isOrganic: true,
          stockQuantity: 48,
        ),
        CategoryProductModel(
          id: 'dairy_002',
          name: 'Artisan Cheese',
          categoryId: 'dairy',
          categoryName: 'Dairy',
          sellerId: 'dairy_001',
          sellerName: 'Farmhouse Dairy',
          price: 8.99,
          unit: '250g',
          imageUrl:
              'https://images.unsplash.com/photo-1452195100486-9cc805987862?w=400',
          rating: 4.8,
          reviewCount: 134,
          isPremium: true,
          stockQuantity: 22,
        ),
      ],
    };

    return mockProducts[categoryId] ?? [];
  }
}
