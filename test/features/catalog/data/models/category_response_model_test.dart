import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/data/models/category/category_response_model.dart';

void main() {
  group('CategoryResponseModels', () {
    test('CategoryListResponse fromJson and toJson', () {
      final json = {
        'status': 'success',
        'data': []
      };
      
      final model = CategoryListResponse.fromJson(json);
      expect(model.status, 'success');
      expect(model.isSuccess, true);
      expect(model.toJson()['status'], 'success');
    });

    test('CategoryDetailResponse fromJson and toJson', () {
      final json = {
        'status': 'error',
        'data': null
      };
      
      final model = CategoryDetailResponse.fromJson(json);
      expect(model.status, 'error');
      expect(model.isSuccess, false);
      expect(model.toJson()['status'], 'error');
    });
  });
}
