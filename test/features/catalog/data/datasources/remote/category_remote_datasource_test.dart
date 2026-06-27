import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/features/catalog/data/datasources/remote/category_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late CategoryRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = CategoryRemoteDataSourceImpl(mockDio);
  });

  final tCategoryJson = {
    "status": "success",
    "data": [
      {
        "id": "1",
        "name": "Vegetables",
        "slug": "veg",
        "description": "Desc",
        "emoji": "🥦",
        "gradient_colors": ["#1", "#2"],
        "product_count": 1,
        "display_order": 1,
        "is_active": true
      }
    ]
  };

  group('getAllCategories', () {
    test('should return List<CategoryModel> when response is 200', () async {
      when(() => mockDio.get(AppConstants.catalogCategoriesEndpoint))
          .thenAnswer((_) async => Response(
                data: tCategoryJson,
                statusCode: 200,
                requestOptions: RequestOptions(path: AppConstants.catalogCategoriesEndpoint),
              ));

      final result = await dataSource.getAllCategories();
      
      expect(result.length, 1);
      expect(result.first.id, "1");
      expect(result.first.name, "Vegetables");
    });

    test('should throw Exception when response is not 200 or status is not success', () async {
      when(() => mockDio.get(AppConstants.catalogCategoriesEndpoint))
          .thenAnswer((_) async => Response(
                data: {"status": "error"},
                statusCode: 400,
                requestOptions: RequestOptions(path: AppConstants.catalogCategoriesEndpoint),
              ));

      expect(() => dataSource.getAllCategories(), throwsException);
    });
  });
}
