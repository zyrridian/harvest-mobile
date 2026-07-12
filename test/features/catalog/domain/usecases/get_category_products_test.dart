import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';
import 'package:harvest_app/features/catalog/domain/repositories/category_repository.dart';
import 'package:harvest_app/features/catalog/domain/usecases/category/get_category_products.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late GetCategoryProducts usecase;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetCategoryProducts(mockCategoryRepository);
  });

  final tCategoryProductList = <CategoryProduct>[];

  test('should get list of category products from the repository directly', () async {
    const tCategoryId = '1';
    
    when(() => mockCategoryRepository.getCategoryProducts(any()))
        .thenAnswer((_) async => tCategoryProductList);

    final result = await usecase(tCategoryId);

    expect(result, tCategoryProductList);
    verify(() => mockCategoryRepository.getCategoryProducts(tCategoryId));
    verifyNoMoreInteractions(mockCategoryRepository);
  });
}
