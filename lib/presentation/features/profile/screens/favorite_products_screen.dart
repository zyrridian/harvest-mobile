import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/features/catalog/domain/entities/favorite_product.dart';
import 'package:harvest_app/presentation/features/profile/providers/favorite_products_controller.dart';
import 'package:intl/intl.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);

class FavoriteProductsScreen extends ConsumerWidget {
  const FavoriteProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoriteProductsControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Favorite Products',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: state.when(
        initial: () => const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (err) => Center(child: Text('Error: $err')),
        data: (data) {
          if (data.favorites.isEmpty) {
            return const Center(child: Text('No favorite products found.'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.read(favoriteProductsControllerProvider.notifier).refresh();
            },
            color: kDarkGreen,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65, 
              ),
              itemCount: data.favorites.length,
              itemBuilder: (context, index) {
                return _buildProductCard(data.favorites[index], context, ref);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(FavoriteProduct product, BuildContext context, WidgetRef ref) {
    Color bgColor = Colors.grey[100]!;
    if (product.name.contains('Bayam')) bgColor = const Color(0xFFE8F3E8);
    if (product.name.contains('Strawberry')) bgColor = const Color(0xFFFDE8F1);
    if (product.name.contains('Ikan')) bgColor = const Color(0xFFE3F2FD);
    if (product.name.contains('Wortel')) bgColor = const Color(0xFFFFF3E0);

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return GestureDetector(
      onTap: () {
        context.push('/products/${product.productId}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Top Area
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(width: double.infinity, height: double.infinity, color: Colors.grey[200], child: const PhosphorIcon(PhosphorIconsRegular.imageBroken, color: Colors.grey)),
                      ),
                    ),
                  ),
                  if (product.isFresh)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28482A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'FRESH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(favoriteProductsControllerProvider.notifier).removeFavorite(product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} removed from favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: const PhosphorIcon(
                          PhosphorIconsFill.heart,
                          size: 16, 
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Details Area
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const PhosphorIcon(PhosphorIconsFill.star, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.farmerName,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: formatter.format(product.price).replaceAll(',00', ''),
                                style: TextStyle(
                                  color: const Color(0xFF28482A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: ' /${product.unit}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
