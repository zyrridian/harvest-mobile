import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/data/models/category_model.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';

void main() {
  final tCategoryModel = CategoryModel(
    id: '3c0543cb-6c2e-435f-97d9-3fd9a224fa30',
    name: 'Vegetables',
    slug: 'vegetables',
    description: 'Fresh vegetables from local farms',
    emoji: '🥦',
    gradientColors: ['#E8F5E9', '#A5D6A7'],
    productCount: 7,
    displayOrder: 1,
    isActive: true,
  );

  final Map<String, dynamic> tJson = {
    "id": "3c0543cb-6c2e-435f-97d9-3fd9a224fa30",
    "name": "Vegetables",
    "slug": "vegetables",
    "description": "Fresh vegetables from local farms",
    "emoji": "🥦",
    "gradient_colors": [
      "#E8F5E9",
      "#A5D6A7"
    ],
    "product_count": 7,
    "display_order": 1,
    "is_active": true
  };

  group('CategoryModel', () {
    test('should map perfectly to Category entity through toEntity()', () {
      final result = tCategoryModel.toEntity();
      
      expect(result, isA<Category>());
      expect(result.id, tCategoryModel.id);
      expect(result.name, tCategoryModel.name);
    });

    test('fromJson should return a valid model from JSON', () {
      final result = CategoryModel.fromJson(tJson);
      
      expect(result.id, tCategoryModel.id);
      expect(result.slug, tCategoryModel.slug);
      expect(result.gradientColors, tCategoryModel.gradientColors);
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tCategoryModel.toJson();
      
      expect(result, tJson);
    });
  });
}
