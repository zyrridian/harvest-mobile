import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/data/datasources/remote/category_remote_datasource.dart';
import 'package:harvest_app/features/catalog/data/models/category/category_model.dart';
import 'package:harvest_app/features/catalog/data/repositories/category_repository_impl.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements CategoryRemoteDataSource {}

void main() {
  late CategoryRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = CategoryRepositoryImpl(mockRemoteDataSource);
  });

  final tCategoryModel = CategoryModel(
    id: '1',
    name: 'Vegetables',
    slug: 'veg',
    description: 'Desc',
    emoji: '🥦',
    gradientColors: ['#1', '#2'],
    productCount: 1,
    displayOrder: 1,
    isActive: true,
  );
  
  final tCategoryModelList = [tCategoryModel];

  group('getAllCategories', () {
    test('should return mapped List<Category> when call to remote data source is successful', () async {
      when(() => mockRemoteDataSource.getAllCategories())
          .thenAnswer((_) async => tCategoryModelList);

      final result = await repository.getAllCategories();
      
      verify(() => mockRemoteDataSource.getAllCategories());
      expect(result, isA<List<Category>>());
      expect(result.first.id, '1');
      expect(result.first.name, 'Vegetables');
    });

    test('should throw Exception when the call to remote data source is unsuccessful', () async {
      when(() => mockRemoteDataSource.getAllCategories())
          .thenThrow(Exception('Failed API call'));

      expect(() => repository.getAllCategories(), throwsException);
    });
  });
}
