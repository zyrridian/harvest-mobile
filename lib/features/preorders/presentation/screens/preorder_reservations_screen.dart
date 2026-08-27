import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:harvest_app/core/widgets/pill_tab_bar.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGreen = Color(0xFF1A2F25);

class PreOrderReservationsScreen extends ConsumerStatefulWidget {
  const PreOrderReservationsScreen({super.key});

  @override
  ConsumerState<PreOrderReservationsScreen> createState() =>
      _PreOrderReservationsScreenState();
}

class _PreOrderReservationsScreenState
    extends ConsumerState<PreOrderReservationsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  final List<String> _tabs = ['Active Drops', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(myReservationsProvider);

    return WebConstrainedBox(
      maxWidth: 600,
      child: Scaffold(
        backgroundColor: kBgColor,
        body: SafeArea(
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: kBgColor,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
                        color: kDarkGreen),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                  ),
                  title: Text(
                    'My Reservations',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kTextGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                  ),
                  centerTitle: true,
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: PillTabBarDelegate(
                    child: PillTabBar(
                      tabs: _tabs.map((t) => PillTabItem(name: t)).toList(),
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ];
            },
            body: reservationsAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: kTextGreen)),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (reservations) {
                final activeReservations =
                    reservations.where((r) => r.status != 'Completed').toList();
                final completedReservations =
                    reservations.where((r) => r.status == 'Completed').toList();
                return CustomScrollView(
                  slivers: [
                    if (_selectedTabIndex == 0) ...[
                      // Active Drops
                      if (activeReservations.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No active reservations.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == 0) {
                                // Premium Impact Card
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7EADA),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const PhosphorIcon(
                                                PhosphorIconsRegular.leaf,
                                                color: kDarkGreen,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Your Impact',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: kTextGreen,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'You saved ${reservations.fold(0.0, (sum, res) {
                                            final match = RegExp(r"([\d.]+)")
                                                .firstMatch(res.quantityStr);
                                            return sum +
                                                (match != null
                                                    ? (double.tryParse(
                                                            match.group(1) ??
                                                                '0') ??
                                                        0)
                                                    : 0);
                                          }).toInt()}kg of imperfect produce from going to waste!',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: kTextGreen,
                                                fontSize: 13,
                                                height: 1.4,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final reservation = activeReservations[index - 1];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: GestureDetector(
                                  onTap: () {
                                    context.push(
                                        '/preorder/${reservation.campaignId}');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: Colors.grey[200]!),
                                    ),
                                    child: _buildPremiumReservationItem(
                                        reservation),
                                  ),
                                ),
                              );
                            },
                            childCount: activeReservations.length + 1,
                          ),
                        ),
                    ] else ...[
                      // Completed Tab
                      if (completedReservations.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              'No completed reservations yet.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey[500]),
                            ),
                          ),
                        )
                      else
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final reservation = completedReservations[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                  ),
                                  child:
                                      _buildPremiumReservationItem(reservation),
                                ),
                              );
                            },
                            childCount: completedReservations.length,
                          ),
                        ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumReservationItem(PreOrderReservation reservation) {
    // Generate mock steps based on daysToHarvest
    final steps = [
      {'title': 'Planted', 'icon': PhosphorIconsRegular.plant},
      {'title': 'Growing', 'icon': PhosphorIconsRegular.sunHorizon},
      {'title': 'Harvesting', 'icon': PhosphorIconsRegular.basket},
      {'title': 'Ready', 'icon': PhosphorIconsRegular.package},
    ];

    int currentStep = 1;
    if (reservation.daysToHarvest < 5) currentStep = 2;
    if (reservation.status == 'Confirmed' && reservation.daysToHarvest == 0) {
      currentStep = 3;
    }

    final isUrl = reservation.imageUrl.startsWith('http');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                clipBehavior: Clip.antiAlias,
                child: isUrl
                    ? CachedNetworkImage(
                        imageUrl: reservation.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[200]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: kDarkGreen.withValues(alpha: 0.1),
                          child: const Center(
                            child: PhosphorIcon(PhosphorIconsRegular.leaf,
                                color: kDarkGreen, size: 20),
                          ),
                        ),
                      )
                    : Container(
                        color: kDarkGreen.withValues(alpha: 0.1),
                        child: const Center(
                          child: PhosphorIcon(PhosphorIconsRegular.leaf,
                              color: kDarkGreen, size: 20),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reservation.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kTextGreen,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${reservation.quantityStr} • ${reservation.farmerName}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Harvest in ${reservation.daysToHarvest} days',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFFD97706),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Premium Tracker
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: List.generate(steps.length * 2 - 1, (i) {
          //     if (i.isOdd) {
          //       // Line
          //       final stepIndex = i ~/ 2;
          //       final isActive = stepIndex < currentStep;
          //       return Expanded(
          //         child: Container(
          //           height: 2,
          //           margin: const EdgeInsets.only(top: 11),
          //           color: isActive ? kDarkGreen : Colors.grey[200],
          //         ),
          //       );
          //     }
          //     // Icon + Text
          //     final stepIndex = i ~/ 2;
          //     final isActive = stepIndex <= currentStep;
          //     final step = steps[stepIndex];
          //     return Column(
          //       children: [
          //         Container(
          //           width: 24,
          //           height: 24,
          //           decoration: BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: isActive ? kDarkGreen : Colors.white,
          //             border: Border.all(
          //               color: isActive ? kDarkGreen : Colors.grey[300]!,
          //               width: 2,
          //             ),
          //           ),
          //           child: Center(
          //             child: PhosphorIcon(
          //               step['icon'] as IconData,
          //               size: 12,
          //               color: isActive ? Colors.white : Colors.grey[400],
          //             ),
          //           ),
          //         ),
          //         const SizedBox(height: 6),
          //         Text(
          //           step['title'] as String,
          //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          //                 fontSize: 10,
          //                 fontWeight:
          //                     isActive ? FontWeight.bold : FontWeight.normal,
          //                 color: isActive ? kTextGreen : Colors.grey[500],
          //               ),
          //         ),
          //       ],
          //     );
          //   }),
          // ),
          // const SizedBox(height: 16),
          Text(
            'Your pre-order helps ${reservation.farmerName} plan their harvest with confidence.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }
}
