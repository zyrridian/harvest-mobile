import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/repositories/category_repository.dart';
import 'package:harvest_app/features/catalog/domain/usecases/get_all_categories_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late GetAllCategoriesUseCase usecase;
  late MockCategoryRepository mockCategoryRepository;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    usecase = GetAllCategoriesUseCase(mockCategoryRepository);
  });

  final tCategoryList = <Category>[
    Category(
      id: '1',
      name: 'Vegetables',
      description: 'Desc',
      emoji: '🥦',
      gradientColors: ['#1', '#2'],
      productCount: 1,
    )
  ];

  group('GetAllCategoriesUseCase', () {
    test('should get Right(List<Category>) from the repository when successful', () async {
      // arrange
      when(() => mockCategoryRepository.getAllCategories())
          .thenAnswer((_) async => tCategoryList);

      // act
      final result = await usecase();

      // assert
      expect(result, Right(tCategoryList));
      verify(() => mockCategoryRepository.getAllCategories());
      verifyNoMoreInteractions(mockCategoryRepository);
    });

    test('should return Left(ServerFailure) when the repository throws an Exception', () async {
      // arrange
      when(() => mockCategoryRepository.getAllCategories())
          .thenThrow(Exception('Server error'));

      // act
      final result = await usecase();

      // assert
      expect(result, isA<Left<Failure, List<Category>>>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (data) => fail('Should not succeed'),
      );
      verify(() => mockCategoryRepository.getAllCategories());
    });
  });
}
