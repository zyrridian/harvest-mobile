import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:harvest_app/features/preorders/presentation/widgets/preorder_harvest_card.dart';
import 'package:harvest_app/features/preorders/presentation/widgets/preorder_shimmer_grid.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/core/widgets/app_search_bar.dart';
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
    {'name': 'All', 'filterValue': 'all', 'icon': null},
    {
      'name': 'Near you',
      'filterValue': 'near you',
      'icon': PhosphorIconsRegular.mapPin
    },
    {
      'name': 'Closing soon',
      'filterValue': 'closing soon',
      'icon': PhosphorIconsRegular.fire
    },
  ];
  int _selectedFilterIndex = 0;
  bool _isSearchVisible = false;
  bool _isFiltering = false;

  void _onFilterTapped(int index) async {
    setState(() {
      _selectedFilterIndex = index;
      _isFiltering = true;
    });

    final filterValue = _filters[index]['filterValue'] as String;
    await ref
        .read(preOrderControllerProvider.notifier)
        .loadCampaigns(filter: filterValue);

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
      body: WebConstrainedBox(
        child: SafeArea(
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
                  layoutBuilder: (Widget topChild, Key topChildKey,
                      Widget bottomChild, Key bottomChildKey) {
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            loading: () => PreOrderShimmerGrid(),
            error: (err) => Center(child: Text('Error: $err')),
            data: (data) {
              return RefreshIndicator(
                color: kDarkGreen,
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await ref.read(preOrderControllerProvider.notifier).refresh();
                },
                child: CustomScrollView(
                  slivers: [
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
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.60,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return PreOrderHarvestCard(
                                harvest: data.availableHarvests[index],
                                index: index,
                              );
                            },
                            childCount: data.availableHarvests.length,
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
      ),
    );
  }
}
