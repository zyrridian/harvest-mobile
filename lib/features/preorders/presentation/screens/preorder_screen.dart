import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/core/widgets/app_search_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:harvest_app/core/widgets/pill_tab_bar.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGreen = Color(0xFF1A2F25);

class PreOrderScreen extends ConsumerStatefulWidget {
  const PreOrderScreen({super.key});

  @override
  ConsumerState<PreOrderScreen> createState() => _PreOrderScreenState();
}

class _PreOrderScreenState extends ConsumerState<PreOrderScreen> {
  final List<Map<String, dynamic>> _filters = [
    {'name': 'All', 'icon': null},
    {'name': 'Near You', 'icon': PhosphorIconsRegular.mapPin},
    {'name': 'Closing Soon', 'icon': PhosphorIconsRegular.fire},
    {'name': 'Fruits', 'icon': null},
    {'name': 'Vegetables', 'icon': null},
  ];
  int _selectedFilterIndex = 0;
  bool _isSearchVisible = false;
  bool _isFiltering = false;

  void _onFilterTapped(int index) async {
    setState(() {
      _selectedFilterIndex = index;
      _isFiltering = true;
    });
    // mock network delay for filter
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _isFiltering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preOrderControllerProvider);

    return Scaffold(
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
              titleSpacing: 0,
              centerTitle: false,
              title: AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _isSearchVisible
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
                  return Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        key: bottomChildKey,
                        left: 0.0,
                        right: 0.0,
                        child: bottomChild,
                      ),
                      Positioned(
                        key: topChildKey,
                        child: topChild,
                      ),
                    ],
                  );
                },
                firstChild: Padding(
                  padding: const EdgeInsets.only(left: 48), 
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Harvest Drops',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: kTextGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                      ),
                    ),
                  ),
                ),
                secondChild: const SizedBox(
                  width: double.infinity,
                  child: AppSearchBar(
                    hintText: 'Search harvests...',
                    height: 38,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: PhosphorIcon(
                    _isSearchVisible
                        ? PhosphorIconsRegular.x
                        : PhosphorIconsRegular.magnifyingGlass,
                    color: kDarkGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearchVisible = !_isSearchVisible;
                    });
                  },
                ),
                IconButton(
                  icon: Stack(
                    children: [
                      const PhosphorIcon(PhosphorIconsRegular.ticket,
                          color: kDarkGreen),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDC2626),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    context.push('/preorder-reservations');
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPersistentHeader(
              pinned: !_isSearchVisible,
              delegate: PillTabBarDelegate(
                height: _isSearchVisible ? 0.0 : 52.0,
                child: _isSearchVisible
                    ? const SizedBox()
                    : PillTabBar(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 4, bottom: 12),
                        tabs: _filters
                            .map((f) => PillTabItem(
                                  name: f['name'] as String,
                                  icon: f['icon'] as IconData?,
                                ))
                            .toList(),
                        selectedIndex: _selectedFilterIndex,
                        onTabSelected: _onFilterTapped,
                      ),
              ),
            ),
          ];
        },
        body: state.when(
          initial: () => const SizedBox(),
          loading: () => _buildShimmerGrid(),
          error: (err) => Center(child: Text('Error: $err')),
          data: (data) {
            // Sort by distance (mocking proximity sort for now)
            final sortedHarvests = data.availableHarvests.toList()
              ..sort((a, b) => a.distance.compareTo(b.distance));

            return RefreshIndicator(
              color: kDarkGreen,
              backgroundColor: Colors.white,
              onRefresh: () async {
                await ref.read(preOrderControllerProvider.notifier).refresh();
              },
              child: CustomScrollView(
                slivers: [
                  // The Grid Feed
                  if (_isFiltering)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: kTextGreen),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.60, // Taller to fit social proof
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildGridCard(sortedHarvests[index], index);
                          },
                          childCount: sortedHarvests.length,
                        ),
                      ),
                    ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            );
          },
        ),
      ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.white),
                    const SizedBox(height: 4),
                    Container(height: 11, width: 100, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(
                        height: 4, width: double.infinity, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(height: 14, width: 80, color: Colors.white),
                  ],
                ),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(PreOrderHarvest harvest, int index) {
    String imageUrl =
        'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300&q=80';
    if (harvest.title.contains('Strawberry')) {
      imageUrl =
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=300&q=80';
    }
    if (harvest.title.contains('Salmon')) {
      imageUrl =
          'https://images.unsplash.com/photo-1599084993091-1cb5c0721cc6?w=300&q=80';
    }

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // Mock distance if unknown, to demonstrate the UI concept
    final displayDistance = harvest.distance == 'Unknown distance'
        ? '${(2.5 + index * 1.2).toStringAsFixed(1)} km'
        : harvest.distance;

    // Mock social proof data
    final neighborsReserved = 12 + index * 3;

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
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
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
                      '${harvest.daysLeft}d left',
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
                  color: kTextGreen,
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
                  displayDistance,
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
            valueColor: const AlwaysStoppedAnimation<Color>(kDarkGreen),
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 4),

          // Social Proof
          Text(
            '$neighborsReserved neighbors reserved',
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
                  color: kTextGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
          ),
        ],
      ),
    );
  }
}
