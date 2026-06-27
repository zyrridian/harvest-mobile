import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/usecases/get_all_categories.dart';
import 'package:harvest_app/features/catalog/presentation/providers/category_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategories extends Mock implements GetAllCategories {}

void main() {
  late MockGetAllCategories mockGetAllCategories;

  setUp(() {
    mockGetAllCategories = MockGetAllCategories();
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        getAllCategoriesUseCaseProvider.overrideWithValue(mockGetAllCategories),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  final tCategoryList = [
    Category(
      id: '1',
      name: 'Vegetables',
      description: 'Desc',
      emoji: '🥦',
      gradientColors: ['0xFF1A2F25', '0xFF1A2F25'],
      productCount: 1,
    )
  ];

  test('allCategoriesProvider should return list of categories successfully', () async {
    when(() => mockGetAllCategories.call()).thenAnswer((_) async => tCategoryList);

    final container = makeProviderContainer();
    
    container.listen(allCategoriesProvider, (_, __) {});

    final categories = await container.read(allCategoriesProvider.future);

    expect(categories, tCategoryList);
    verify(() => mockGetAllCategories.call()).called(1);
  });

  test('allCategoriesProvider should throw Exception when use case fails', () async {
    when(() => mockGetAllCategories.call()).thenThrow(Exception('Failed to load'));

    final container = makeProviderContainer();
    
    container.listen(allCategoriesProvider, (_, __) {});

    expect(
      () => container.read(allCategoriesProvider.future),
      throwsA(isA<Exception>()),
    );
  });
}
