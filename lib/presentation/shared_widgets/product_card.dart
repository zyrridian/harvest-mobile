import 'package:flutter/material.dart';
import 'package:harvest_app/presentation/shared_widgets/app_cached_image.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final num price;
  final String imageUrl;
  final String unit;
  final num rating;
  final int soldCount;
  final String? farmerName;
  final bool isFresh;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.unit,
    required this.rating,
    required this.soldCount,
    this.farmerName,
    this.isFresh = false,
    this.isFavorite = false,
    required this.onTap,
    required this.onAddToCart,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFFE8F5E9);
    if (name.contains('Strawberry')) bgColor = const Color(0xFFFFEBEE);
    if (name.contains('Lobster')) bgColor = const Color(0xFFFFEBEE);
    if (name.contains('Ikan')) bgColor = const Color(0xFFE3F2FD);
    if (name.contains('Wortel')) bgColor = const Color(0xFFFFF3E0);

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: _buildImage(
                        imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isFresh)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28482A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
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
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color:
                              isFavorite ? Colors.red : Colors.black54,
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
                      const Icon(Icons.star, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        '$rating · $soldCount sold',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (farmerName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      farmerName!,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: formatter
                                    .format(price)
                                    .replaceAll(',00', ''),
                                style: const TextStyle(
                                  color: Color(0xFF28482A),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: ' /$unit',
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
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const PhosphorIcon(PhosphorIconsRegular.plus,
                              size: 14, color: Colors.black87),
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

  Widget _buildImage(String imageUrl,
      {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imageUrl.startsWith('data:image')) {
      return Image(
        image: getAppImageProvider(imageUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return PhosphorIcon(PhosphorIconsRegular.imageBroken,
              color: Colors.grey, size: width ?? 48);
        },
      );
    } else if (imageUrl.startsWith('http')) {
      return AppCachedImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        borderRadius: BorderRadius.circular(0),
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image_not_supported)),
      );
    }
  }
}
