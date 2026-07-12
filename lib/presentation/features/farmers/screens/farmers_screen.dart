import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../../domain/entities/farmer.dart';
import '../providers/farmers_controller.dart';
import '../providers/farmers_state.dart';
import '../widgets/farmer_card.dart';
import '../widgets/farmer_filter_bottom_sheet.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

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
    // (Logic remains same, styling handled in the widget)
    final specialties = ref.read(selectedSpecialtiesProvider);
    final hasMapFeature = ref.read(hasMapFeatureFilterProvider);
    final maxDistance = ref.read(maxDistanceFilterProvider);
    final minRating = ref.read(minRatingFilterProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
      backgroundColor: kBgColor,
      body: CustomScrollView(
        slivers: [
          // 1. APP BAR
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: kBgColor,
            surfaceTintColor: kBgColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 70,
            title: Text(
              'Farmers Directory',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: kDarkGreen,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: kPillGrey),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.map_outlined, color: kDarkGreen),
                    onPressed: () => context.push(AppRouter.explore),
                    tooltip: 'Map View',
                  ),
                ),
              ),
            ],
          ),

          // 2. SEARCH & FILTER BAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Icon(Icons.search, color: Colors.grey[500], size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.inter(color: kDarkGreen),
                              decoration: InputDecoration(
                                hintText: 'Search local farmers...',
                                hintStyle:
                                    GoogleFonts.inter(color: Colors.grey[500]),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (_) => _performSearch(),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: Icon(Icons.close_rounded,
                                  color: Colors.grey[500], size: 20),
                              onPressed: () {
                                _searchController.clear();
                                _performSearch();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  GestureDetector(
                    onTap: _showFilterBottomSheet,
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: hasActiveFilters ? kDarkGreen : Colors.white,
                        borderRadius: BorderRadius.circular(16), // Pebble shape
                        border: Border.all(
                          color: hasActiveFilters ? kDarkGreen : kPillGrey,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            color: hasActiveFilters ? Colors.white : kDarkGreen,
                          ),
                          if (hasActiveFilters)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: kAccentOrange,
                                  shape: BoxShape.circle,
                                ),
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

          // 3. ACTIVE FILTERS
          if (hasActiveFilters)
            SliverToBoxAdapter(
              child: _buildActiveFiltersChips(),
            ),

          // 4. LIST VIEW
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Clear All Text Button
          TextButton(
            onPressed: () =>
                ref.read(farmersControllerProvider.notifier).clearFilters(),
            child: Text(
              'Clear all',
              style: GoogleFonts.inter(
                  color: kTextGrey, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),

          ...specialties.map((s) => _buildFilterChip(s, () {
                final updated = List<String>.from(specialties)..remove(s);
                ref
                    .read(farmersControllerProvider.notifier)
                    .applyFilters(specialties: updated);
              })),

          if (hasMapFeature != null)
            _buildFilterChip('Map Feature', () {
              ref
                  .read(farmersControllerProvider.notifier)
                  .applyFilters(hasMapFeature: null);
            }),

          if (maxDistance != null)
            _buildFilterChip('< ${maxDistance.toStringAsFixed(0)} km', () {
              ref
                  .read(farmersControllerProvider.notifier)
                  .applyFilters(maxDistance: null);
            }),

          if (minRating != null)
            _buildFilterChip('${minRating.toStringAsFixed(1)}+ ⭐', () {
              ref
                  .read(farmersControllerProvider.notifier)
                  .applyFilters(minRating: null);
            }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPillGrey),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
                color: kDarkGreen, fontWeight: FontWeight.w500, fontSize: 13),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(Icons.close_rounded, size: 14, color: kTextGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(FarmersState state) {
    return state.when(
      initial: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
      loading: () => const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator(color: kDarkGreen))),
      loaded: (farmers) {
        if (farmers.isEmpty)
          return SliverFillRemaining(child: _buildEmptyState());
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FarmerCard(
                  farmer: farmers[index],
                  onTap: () => context.push(AppRouter.farmerDetail,
                      extra: farmers[index]),
                ),
              ),
              childCount: farmers.length,
            ),
          ),
        );
      },
      error: (message) =>
          SliverFillRemaining(child: Center(child: Text(message))),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
                color: Color(0xFFFFF9E6), shape: BoxShape.circle),
            child: const Text('🌾', style: TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 16),
          Text('No farmers found',
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen)),
          Text('Try adjusting your filters.',
              style: GoogleFonts.inter(color: kTextGrey)),
        ],
      ),
    );
  }
}
