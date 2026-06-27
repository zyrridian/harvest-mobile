import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/domain/entities/category_product.dart';
import 'package:harvest_app/features/catalog/domain/usecases/get_category_products.dart';
import 'package:harvest_app/features/catalog/presentation/providers/category_providers.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/category_products_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCategoryProducts extends Mock implements GetCategoryProducts {}

void main() {
  late MockGetCategoryProducts mockGetCategoryProducts;

  setUp(() {
    mockGetCategoryProducts = MockGetCategoryProducts();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        getCategoryProductsUseCaseProvider.overrideWithValue(mockGetCategoryProducts),
      ],
      child: const MaterialApp(
        home: CategoryProductsScreen(
          categoryId: '1',
          categoryName: 'Vegetables',
        ),
      ),
    );
  }

  final tProductList = [
    CategoryProduct(
      id: '1',
      name: 'Organic Tomatoes',
      categoryId: '1',
      categoryName: 'Vegetables',
      sellerId: 's1',
      sellerName: 'Farm',
      price: 25.0,
      unit: 'kg',
      imageUrl: 'http://image',
      rating: 4.5,
      reviewCount: 10,
      stockQuantity: 20,
      isOrganic: true,
      isPremium: true,
    )
  ];

  testWidgets('should display loading indicator when loading', (WidgetTester tester) async {
    when(() => mockGetCategoryProducts.call(any()))
        .thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 1));
          return tProductList;
        });

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    await tester.pumpAndSettle();
  });

  testWidgets('should display product list when loaded successfully', (WidgetTester tester) async {
    when(() => mockGetCategoryProducts.call(any())).thenAnswer((_) async => tProductList);

    // Provide mock image network so we don't throw HTTP errors during widget test
    await tester.runAsync(() async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();
    });

    expect(find.text('Organic Tomatoes'), findsOneWidget);
    expect(find.text('Farm'), findsOneWidget);
    expect(find.text('ORGANIC'), findsOneWidget);
    expect(find.text('PREMIUM'), findsOneWidget);
  });
}
