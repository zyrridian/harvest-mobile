import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/repositories/category_repository.dart';
import 'package:harvest_app/features/catalog/domain/usecases/category/get_all_categories.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late GetAllCategories usecase;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetAllCategories(mockCategoryRepository);
  });

  final tCategoryList = <Category>[];

  test('should get list of categories from the repository directly', () async {
    when(() => mockCategoryRepository.getAllCategories())
        .thenAnswer((_) async => tCategoryList);

    final result = await usecase();

    expect(result, tCategoryList);
    verify(() => mockCategoryRepository.getAllCategories());
    verifyNoMoreInteractions(mockCategoryRepository);
  });
}
