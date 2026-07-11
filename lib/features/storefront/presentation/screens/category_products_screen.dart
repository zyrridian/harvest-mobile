import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:harvest_app/domain/entities/marketplace.dart';
import 'package:harvest_app/features/storefront/presentation/providers/marketplace_controller.dart';
import 'package:harvest_app/presentation/shared_widgets/marketplace_product_card.dart';
import 'package:harvest_app/presentation/shared_widgets/app_search_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProductsScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final MarketplaceCategory? category;

  const CategoryProductsScreen({
    Key? key,
    required this.categoryId,
    this.category,
  }) : super(key: key);

  @override
  ConsumerState<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();
}

class _CategoryProductsScreenState
    extends ConsumerState<CategoryProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MarketplaceProduct>? _products;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCategoryProducts();
  }

  Future<void> _fetchCategoryProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final getProducts = ref.read(getProductsUseCaseProvider);
      final result = await getProducts(
        category: widget.categoryId,
      );

      result.fold(
        (failure) {
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        },
        (productList) {
          final mappedProducts = productList.products
              .map((p) => MarketplaceProduct(
                    id: p.id,
                    name: p.name,
                    farmerName: p.farmer.name,
                    price: p.price,
                    unit: p.unit,
                    imageUrl: p.imageUrl,
                    rating: p.rating,
                    soldCount: p.reviewCount,
                    isFresh: p.isHarvest,
                  ))
              .toList();

          setState(() {
            _products = mappedProducts;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
              color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: AppSearchBar(
          controller: _searchController,
          hintText: widget.category?.name != null
              ? 'Search in ${widget.category!.name}...'
              : 'Search produce...',
        ),
        titleSpacing: 0,
        actions: [
          const SizedBox(width: 20),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildShimmerGrid();
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PhosphorIcon(PhosphorIconsRegular.warningCircle,
                size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCategoryProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_products == null || _products!.isEmpty) {
      return const Center(
        child: Text(
          'No products found in this category.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: _products!.length,
        itemBuilder: (context, index) {
          return MarketplaceProductCard(product: _products![index]);
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }
}
