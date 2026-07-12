import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';

void main() {
  test('Category entity instantiation', () {
    final entity = Category(
      id: '1',
      name: 'Vegetables',
      description: 'Desc',
      emoji: '🥦',
      gradientColors: ['#E8F5E9', '#A5D6A7'],
      productCount: 1,
    );
    
    expect(entity.id, '1');
    expect(entity.name, 'Vegetables');
  });
}
