import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../domain/entities/farmer.dart';
import '../providers/farmers_controller.dart';
import '../widgets/farmer_filter_bottom_sheet.dart';

class FarmersMapScreen extends ConsumerStatefulWidget {
  const FarmersMapScreen({super.key});

  @override
  ConsumerState<FarmersMapScreen> createState() => _FarmersMapScreenState();
}

class _FarmersMapScreenState extends ConsumerState<FarmersMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

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
    _mapController?.dispose();
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
      body: Stack(
        children: [
          // Full Screen Map
          farmersState.when(
            initial: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (farmers) {
              if (farmers.isEmpty) {
                return _buildEmptyState();
              }

              // Filter farmers with map feature
              final mappableFarmers =
                  farmers.where((f) => f.hasMapFeature).toList();

              if (mappableFarmers.isEmpty) {
                return _buildNoMapFarmersState();
              }

              // Calculate center position
              final center = _calculateCenter(mappableFarmers);

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 12,
                ),
                markers: _createMarkers(mappableFarmers),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                padding: const EdgeInsets.only(
                  top: 140, // Space for search bar
                  bottom: 20,
                ),
              );
            },
            error: (message) => _buildErrorState(message),
          ),

          // Top Search Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Back button and search bar
                      Row(
                        children: [
                          // Back button
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Search bar
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
                                        hintText: 'Search farmers on map...',
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

                          // Filter button
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: hasActiveFilters
                                  ? AppColors.primary
                                  : Colors.white,
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

                      // Active filters
                      if (hasActiveFilters) ...[
                        const SizedBox(height: 12),
                        _buildActiveFiltersChips(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating farmer count badge
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: farmersState.maybeWhen(
                loaded: (farmers) {
                  final mappableFarmers =
                      farmers.where((f) => f.hasMapFeature).toList();
                  if (mappableFarmers.isEmpty) return const SizedBox.shrink();

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${mappableFarmers.length} ${mappableFarmers.length == 1 ? 'farmer' : 'farmers'} on map',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
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
      child: Row(
        children: [
          ...specialties.map((specialty) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
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
                ),
              )),
          if (hasMapFeature != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
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
            ),
          if (maxDistance != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
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
            ),
          if (minRating != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
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

  LatLng _calculateCenter(List<Farmer> farmers) {
    if (farmers.isEmpty) {
      return const LatLng(40.7128, -74.0060); // Default NYC
    }

    double totalLat = 0;
    double totalLng = 0;

    for (var farmer in farmers) {
      totalLat += farmer.latitude;
      totalLng += farmer.longitude;
    }

    return LatLng(
      totalLat / farmers.length,
      totalLng / farmers.length,
    );
  }

  Set<Marker> _createMarkers(List<Farmer> farmers) {
    return farmers.map((farmer) {
      return Marker(
        markerId: MarkerId(farmer.id),
        position: LatLng(farmer.latitude, farmer.longitude),
        infoWindow: InfoWindow(
          title: farmer.name,
          snippet:
              '${farmer.rating} ⭐ • ${farmer.distance.toStringAsFixed(1)} km',
          onTap: () => _showFarmerDetails(farmer),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          farmer.isVerified
              ? BitmapDescriptor.hueGreen
              : BitmapDescriptor.hueRed,
        ),
      );
    }).toSet();
  }

  void _showFarmerDetails(Farmer farmer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Farmer info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(farmer.profileImage),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            farmer.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (farmer.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${farmer.rating}'),
                          const SizedBox(width: 8),
                          const Icon(Icons.location_on,
                              color: AppColors.textSecondary, size: 16),
                          const SizedBox(width: 4),
                          Text('${farmer.distance.toStringAsFixed(1)} km'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              farmer.description,
              style: TextStyle(color: AppColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.directions),
                    label: const Text('Directions'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Profile'),
                  ),
                ),
              ],
            ),
          ],
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

  Widget _buildNoMapFarmersState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No farmers with map feature',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Try adjusting your filters'),
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
