import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/features/preorder/providers/preorder_controller.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGreen = Color(0xFF1A2F25);

class PreOrderDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const PreOrderDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<PreOrderDetailScreen> createState() =>
      _PreOrderDetailScreenState();
}

class _PreOrderDetailScreenState extends ConsumerState<PreOrderDetailScreen> {
  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final detailAsyncValue = ref.watch(preorderDetailProvider(widget.slug));

    return Scaffold(
      backgroundColor: kBgColor,
      body: detailAsyncValue.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (PreorderCampaign campaign) {
          final String title = campaign.productName ?? 'Unknown Product';
          final String farmName = campaign.farmerName ?? 'Unknown Farm';
          final double price = campaign.price ?? campaign.depositAmount;
          final int daysLeft =
              campaign.deadline.difference(DateTime.now()).inDays.clamp(0, 365);
          final double progress = campaign.targetQuantity > 0
              ? (campaign.currentReservations / campaign.targetQuantity) * 100
              : 0;
          final int remainingKg =
              (campaign.targetQuantity - campaign.currentReservations)
                  .clamp(0, 99999);
          final int totalKg = campaign.targetQuantity;
          final String imageUrl = (campaign.productImage != null && campaign.productImage!.isNotEmpty)
              ? campaign.productImage!
              : 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&q=80';
          final bool hasReserved = campaign.hasReserved ?? false;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                backgroundColor: kBgColor,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
                        color: kDarkGreen, size: 20),
                  ),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const PhosphorIcon(
                                  PhosphorIconsRegular.calendarCheck,
                                  size: 18,
                                  color: kDarkGreen),
                              const SizedBox(width: 6),
                              Text(
                                'Harvests in $daysLeft days',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: kTextGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasReserved)
                        Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFF0EAD6), // Sand color from home theme
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const PhosphorIcon(PhosphorIconsFill.checkCircle,
                                  color: kDarkGreen),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'You have reserved this harvest',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: kTextGreen,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '3 kg reserved. Harvest is expected in $daysLeft days.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: kTextGreen.withOpacity(0.8),
                                            fontSize: 13,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: kTextGreen,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  farmName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        height: 1.1,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 2.0),
                                      child: PhosphorIcon(
                                          PhosphorIconsRegular.mapPin,
                                          size: 12,
                                          color: Color(0xFFD97706)),
                                    ),
                                    const SizedBox(width: 4),
                                    const Expanded(
                                      child: Text(
                                        '3.2 km from you · Harvested within hours of pickup',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFD97706),
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                const PhosphorIcon(PhosphorIconsRegular.leaf,
                                    size: 16, color: kDarkGreen),
                                const SizedBox(width: 4),
                                Text(
                                  'Direct from Farm',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: kTextGreen,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Progress Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${progress.toInt()}% Funded',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: kTextGreen,
                                ),
                          ),
                          Text(
                            '$remainingKg kg left',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(kDarkGreen),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 32),
                      // Tracker Section
                      Text(
                        'Harvest Timeline',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextGreen,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _buildTimelineTracker(),
                      const SizedBox(height: 32),
                      // About Section
                      Text(
                        'About this harvest',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextGreen,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'These premium tomatoes are grown in nutrient-rich volcanic soil just 3.2 km from your area. By pre-ordering, you lock in the freshest possible produce — picked and delivered within hours of harvest. No cold storage, no long supply chain.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.6,
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Meet the Grower Section
                      Text(
                        'Meet the Grower',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextGreen,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1595878715977-2e8f8df18ea8?w=150&q=80'),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                  color: Colors.grey[200]!, width: 2),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pak Joko',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kTextGreen,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '3rd generation tomato grower · Bogor',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const PhosphorIcon(
                                        PhosphorIconsRegular.plant,
                                        size: 12,
                                        color: kDarkGreen),
                                    const SizedBox(width: 4),
                                    Text(
                                      '142 successful harvests',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: kDarkGreen,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Community Section
                      Text(
                        'From your community',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextGreen,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 90,
                            height: 32,
                            child: Stack(
                              children: List.generate(3, (index) {
                                final images = [
                                  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&q=80',
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80',
                                  'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&q=80',
                                ];
                                return Positioned(
                                  left: index * 24.0,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(images[index]),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Budi, Sari, and 14 others from your area reserved this.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              120), // Padding to account for the bottom sheet
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: detailAsyncValue.maybeWhen(
        data: (PreorderCampaign campaign) {
          final double price = campaign.price ?? campaign.depositAmount;
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pre-order price',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatter.format(price).replaceAll(',00', ''),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: kTextGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                              Text(
                                ' /kg',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Show reservation bottom sheet logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF166534), // Primary green
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Reserve Now',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTimelineTracker() {
    final steps = ['Planted', 'Growing', 'Harvesting', 'Ready'];
    int currentStep = 1; // "Growing"

    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIndex = i ~/ 2;
          final isActive = stepIndex < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(bottom: 24),
              color: isActive ? kDarkGreen : Colors.grey[200],
            ),
          );
        }

        final stepIndex = i ~/ 2;
        final isActive = stepIndex <= currentStep;
        return Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? kDarkGreen : Colors.grey[200],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              steps[stepIndex],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? kTextGreen : Colors.grey[500],
                  ),
            ),
          ],
        );
      }),
    );
  }
}
