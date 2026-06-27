import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/data/models/category_product_model.dart';
import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';

void main() {
  final tFarmerModel = FarmerModel(
    name: 'Green Valley Farm',
    isVerified: true,
  );

  final tCategoryProductModel = CategoryProductModel(
    id: '1',
    name: 'Organic Tomatoes',
    slug: 'organic-tomatoes',
    description: 'Vine-ripened tomatoes',
    category: 'Vegetables',
    categoryId: 'c1',
    categoryName: 'Vegetables',
    sellerId: 's1',
    sellerName: 'Green Valley Farm',
    price: 25000,
    currency: 'IDR',
    unit: 'kg',
    imageUrl: 'https://image.url',
    images: ['https://image.url'],
    isOrganic: true,
    isAvailable: true,
    stockQuantity: 22,
    rating: 0,
    reviewCount: 0,
    farmer: tFarmerModel,
    isHarvest: false,
    currentBooked: 0,
    tags: [],
    createdAt: '2026-06-26T09:41:17.863Z',
  );

  final tJson = {
    "id": "1",
    "name": "Organic Tomatoes",
    "slug": "organic-tomatoes",
    "description": "Vine-ripened tomatoes",
    "category": "Vegetables",
    "category_id": "c1",
    "category_name": "Vegetables",
    "seller_id": "s1",
    "seller_name": "Green Valley Farm",
    "price": 25000.0,
    "currency": "IDR",
    "unit": "kg",
    "image": null,
    "image_url": "https://image.url",
    "images": [
      "https://image.url"
    ],
    "is_organic": true,
    "is_available": true,
    "stock_quantity": 22,
    "discount": null,
    "rating": 0.0,
    "review_count": 0,
    "farmer": {
      "name": "Green Valley Farm",
      "profile_image": null,
      "is_verified": true
    },
    "is_harvest": false,
    "target_amount": null,
    "current_booked": 0.0,
    "harvest_date": null,
    "tags": [],
    "created_at": "2026-06-26T09:41:17.863Z"
  };

  group('CategoryProductModel', () {
    test('should map perfectly to CategoryProduct entity through toEntity()', () {
      final result = tCategoryProductModel.toEntity();
      
      expect(result, isA<CategoryProduct>());
      expect(result.id, tCategoryProductModel.id);
      expect(result.name, tCategoryProductModel.name);
    });

    test('fromJson should return a valid model from JSON', () {
      final result = CategoryProductModel.fromJson(tJson);
      
      expect(result.id, tCategoryProductModel.id);
      expect(result.farmer.name, tCategoryProductModel.farmer.name);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tCategoryProductModel.toJson();
      
      expect(result['id'], tJson['id']);
      expect(result['name'], tJson['name']);
      expect((result['farmer'] as FarmerModel).name, (tJson['farmer'] as Map)['name']);
    });
  });
}
