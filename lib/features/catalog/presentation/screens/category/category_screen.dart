import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/all_categories_screen.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/category_products_screen.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final String categoryName;
  final String categoryId;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    // If categoryId is 'all', show all categories
    // Otherwise show specific category products
    if (widget.categoryId == 'all') {
      return const AllCategoriesScreen();
    } else {
      return CategoryProductsScreen(
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
      );
    }
  }
}
