import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/all_categories_screen.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/category_products_screen.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/category_screen.dart';
import 'package:harvest_app/features/catalog/domain/usecases/category/get_all_categories.dart';
import 'package:harvest_app/features/catalog/domain/usecases/category/get_category_products.dart';
import 'package:harvest_app/features/catalog/presentation/providers/category/category_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategories extends Mock implements GetAllCategories {}
class MockGetCategoryProducts extends Mock implements GetCategoryProducts {}

void main() {
  late MockGetAllCategories mockGetAllCategories;
  late MockGetCategoryProducts mockGetCategoryProducts;

  setUp(() {
    mockGetAllCategories = MockGetAllCategories();
    mockGetCategoryProducts = MockGetCategoryProducts();
    
    when(() => mockGetAllCategories.call()).thenAnswer((_) async => []);
    when(() => mockGetCategoryProducts.call(any())).thenAnswer((_) async => []);
  });

  Widget createWidgetUnderTest(String id) {
    return ProviderScope(
      overrides: [
        getAllCategoriesUseCaseProvider.overrideWithValue(mockGetAllCategories),
        getCategoryProductsUseCaseProvider.overrideWithValue(mockGetCategoryProducts),
      ],
      child: MaterialApp(
        home: CategoryScreen(
          categoryId: id,
          categoryName: 'Test Category',
        ),
      ),
    );
  }

  testWidgets('should render AllCategoriesScreen when categoryId is "all"', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest('all'));
    await tester.pumpAndSettle();

    expect(find.byType(AllCategoriesScreen), findsOneWidget);
    expect(find.byType(CategoryProductsScreen), findsNothing);
  });

  testWidgets('should render CategoryProductsScreen when categoryId is not "all"', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest('specific_id'));
    await tester.pumpAndSettle();

    expect(find.byType(CategoryProductsScreen), findsOneWidget);
    expect(find.byType(AllCategoriesScreen), findsNothing);
  });
}
