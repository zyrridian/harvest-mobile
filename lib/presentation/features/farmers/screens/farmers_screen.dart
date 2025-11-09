import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../../domain/entities/farmer.dart';
import '../providers/farmers_controller.dart';
import '../providers/farmers_state.dart';
import '../widgets/farmer_card.dart';
import '../widgets/farmer_filter_bottom_sheet.dart';

class FarmersScreen extends ConsumerStatefulWidget {
  const FarmersScreen({super.key});

  @override
  ConsumerState<FarmersScreen> createState() => _FarmersScreenState();
}

class _FarmersScreenState extends ConsumerState<FarmersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        ref.read(farmersControllerProvider.notifier).searchFarmers('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    ref.read(farmersControllerProvider.notifier).searchFarmers(query);
  }

  void _showFilterBottomSheet() {
    final specialties = ref.read(selectedSpecialtiesProvider);
    final hasMapFeature = ref.read(hasMapFeatureFilterProvider);
    final maxDistance = ref.read(maxDistanceFilterProvider);
    final minRating = ref.read(minRatingFilterProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FarmerFilterBottomSheet(
        selectedSpecialties: specialties,
        hasMapFeature: hasMapFeature,
        maxDistance: maxDistance,
        minRating: minRating,
        onApply: (specialties, hasMap, distance, rating) {
          ref.read(farmersControllerProvider.notifier).applyFilters(
                specialties: specialties,
                hasMapFeature: hasMap,
                maxDistance: distance,
                minRating: rating,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmersState = ref.watch(farmersControllerProvider);
    final hasActiveFilters = _hasActiveFilters();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 1,
            title: Text(
              'Farmers Directory',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            actions: [
              // Map View Button
              IconButton(
                icon: const Icon(
                  Icons.map_outlined,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  context.push(AppRouter.farmersMap);
                },
                tooltip: 'Map View',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search,
                              color: AppColors.textSecondary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search farmers...',
                                border: InputBorder.none,
                                isDense: true,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12),
                              ),
                              onSubmitted: (_) => _performSearch(),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear,
                                  color: AppColors.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Filter Button
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color:
                          hasActiveFilters ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: hasActiveFilters
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.tune,
                            color: hasActiveFilters
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          onPressed: _showFilterBottomSheet,
                        ),
                        if (hasActiveFilters)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Active Filters Chips
          if (hasActiveFilters)
            SliverToBoxAdapter(
              child: _buildActiveFiltersChips(),
            ),

          // List View
          _buildListView(farmersState),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    final specialties = ref.watch(selectedSpecialtiesProvider);
    final hasMapFeature = ref.watch(hasMapFeatureFilterProvider);
    final maxDistance = ref.watch(maxDistanceFilterProvider);
    final minRating = ref.watch(minRatingFilterProvider);

    return specialties.isNotEmpty ||
        hasMapFeature != null ||
        maxDistance != null ||
        minRating != null;
  }

  Widget _buildActiveFiltersChips() {
    final specialties = ref.watch(selectedSpecialtiesProvider);
    final hasMapFeature = ref.watch(hasMapFeatureFilterProvider);
    final maxDistance = ref.watch(maxDistanceFilterProvider);
    final minRating = ref.watch(minRatingFilterProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...specialties.map((specialty) => Chip(
                label: Text(specialty),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  final updated = List<String>.from(specialties)
                    ..remove(specialty);
                  ref.read(farmersControllerProvider.notifier).applyFilters(
                        specialties: updated,
                      );
                },
                backgroundColor: AppColors.primary.withOpacity(0.1),
                side: const BorderSide(color: AppColors.primary),
              )),
          if (hasMapFeature != null)
            Chip(
              label: const Text('Map Feature'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                ref.read(farmersControllerProvider.notifier).applyFilters(
                      hasMapFeature: null,
                    );
              },
              backgroundColor: AppColors.primary.withOpacity(0.1),
              side: const BorderSide(color: AppColors.primary),
            ),
          if (maxDistance != null)
            Chip(
              label: Text('Within ${maxDistance.toStringAsFixed(0)} km'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                ref.read(farmersControllerProvider.notifier).applyFilters(
                      maxDistance: null,
                    );
              },
              backgroundColor: AppColors.primary.withOpacity(0.1),
              side: const BorderSide(color: AppColors.primary),
            ),
          if (minRating != null)
            Chip(
              label: Text('${minRating.toStringAsFixed(1)}+ ⭐'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                ref.read(farmersControllerProvider.notifier).applyFilters(
                      minRating: null,
                    );
              },
              backgroundColor: AppColors.primary.withOpacity(0.1),
              side: const BorderSide(color: AppColors.primary),
            ),
          TextButton.icon(
            onPressed: () {
              ref.read(farmersControllerProvider.notifier).clearFilters();
            },
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text('Clear all'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: const Size(0, 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(FarmersState state) {
    return state.when(
      initial: () => const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      ),
      loading: () => const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      loaded: (farmers) {
        if (farmers.isEmpty) {
          return SliverFillRemaining(
            child: _buildEmptyState(),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FarmerCard(
                    farmer: farmers[index],
                    onTap: () {
                      _showFarmerDetails(farmers[index]);
                    },
                  ),
                );
              },
              childCount: farmers.length,
            ),
          ),
        );
      },
      error: (message) => SliverFillRemaining(
        child: _buildErrorState(message),
      ),
    );
  }

  void _showFarmerDetails(Farmer farmer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${farmer.name} details coming soon'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.agriculture_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No farmers found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(farmersControllerProvider.notifier).loadFarmers();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
