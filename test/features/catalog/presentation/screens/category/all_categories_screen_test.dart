import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/catalog/domain/usecases/category/get_all_categories.dart';
import 'package:harvest_app/features/catalog/presentation/providers/category/category_providers.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/all_categories_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllCategories extends Mock implements GetAllCategories {}

void main() {
  late MockGetAllCategories mockGetAllCategories;

  setUp(() {
    mockGetAllCategories = MockGetAllCategories();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        getAllCategoriesUseCaseProvider.overrideWithValue(mockGetAllCategories),
      ],
      child: const MaterialApp(
        home: AllCategoriesScreen(),
      ),
    );
  }

  final tCategoryList = [
    Category(
      id: '1',
      name: 'Vegetables',
      description: 'Fresh veggies',
      emoji: '🥦',
      gradientColors: ['#E8F5E9', '#A5D6A7'],
      productCount: 5,
    )
  ];

  testWidgets('should display loading indicator when loading', (WidgetTester tester) async {
    when(() => mockGetAllCategories.call())
        .thenAnswer((_) async {
          await Future.delayed(const Duration(seconds: 1));
          return tCategoryList;
        });

    await tester.pumpWidget(createWidgetUnderTest());

    // Should find the CircularProgressIndicator immediately
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Finish all timers so it doesn't leave lingering timers
    await tester.pumpAndSettle();
  });

  testWidgets('should display list of categories when loaded successfully', (WidgetTester tester) async {
    when(() => mockGetAllCategories.call()).thenAnswer((_) async => tCategoryList);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Should find the category name
    expect(find.text('Vegetables'), findsOneWidget);
    // Should find the emoji
    expect(find.text('🥦'), findsOneWidget);
    // Should find the product count (string '5')
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('should display error message when exception is thrown', (WidgetTester tester) async {
    when(() => mockGetAllCategories.call()).thenThrow(Exception('API Failure'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Should find the error message
    expect(find.text('Failed to load categories'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
