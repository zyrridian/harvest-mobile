import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';

void main() {
  test('CategoryProduct entity instantiation', () {
    final entity = CategoryProduct(
      id: '1',
      name: 'Organic Tomatoes',
      categoryId: 'c1',
      categoryName: 'Vegetables',
      sellerId: 's1',
      sellerName: 'Farm',
      price: 25.0,
      unit: 'kg',
      imageUrl: 'http://',
      rating: 4.5,
      reviewCount: 10,
      stockQuantity: 20,
    );
    
    expect(entity.id, '1');
    expect(entity.name, 'Organic Tomatoes');
    expect(entity.isOrganic, false);
  });
}
