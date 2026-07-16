import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder.dart';
import 'package:harvest_app/core/widgets/app_cached_image.dart';
import 'package:harvest_app/core/constants/app_constants.dart';

class PreOrderHarvestCard extends StatelessWidget {
  final PreOrderHarvest harvest;
  final int index;

  const PreOrderHarvestCard({
    super.key,
    required this.harvest,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = harvest.imageUrl;

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // // Mock distance if unknown, to demonstrate the UI concept
    // final displayDistance = harvest.distance == 'Unknown distance'
    //     ? '${(2.5 + index * 1.2).toStringAsFixed(1)} km'
    //     : harvest.distance;

    // // Mock social proof data
    // final neighborsReserved = 12 + index * 3;

    return GestureDetector(
      onTap: () {
        context.push('/preorder/${harvest.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1:1 Image with overlay
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppCachedImage(
                    imageUrl: imageUrl.isEmpty
                        ? AppConstants.emptyImageUrl
                        : imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorAssetImage: AppConstants.emptyImageUrl,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      harvest.daysLeft > 0 ? '${harvest.daysLeft}d left' : 'Harvest Now',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFDC2626),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Details
          Text(
            harvest.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(
                '${harvest.farmerName} · ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
              ),
              const PhosphorIcon(PhosphorIconsRegular.mapPin,
                  size: 10, color: Colors.grey),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  harvest.distance ?? 'Unknown distance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Progress Bar Mini
          LinearProgressIndicator(
            value: harvest.progressPercentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 4),

          // Social Proof
          Text(
            '${harvest.totalPeopleReserved} neighbors reserved',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 9,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),

          // Price
          Text(
            '${formatter.format(harvest.price).replaceAll(',00', '')}/${harvest.unit}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
