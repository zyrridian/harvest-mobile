import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../domain/entities/farmer.dart';
import '../providers/farmers_controller.dart';
import '../widgets/farmer_filter_bottom_sheet.dart';

// --- DESIGN CONSTANTS ---
const kDarkGreen = Color(0xFF1A2F25);
const kPillGrey = Color(0xFFF0F2F0);

class FarmersMapScreen extends ConsumerStatefulWidget {
  const FarmersMapScreen({super.key});

  @override
  ConsumerState<FarmersMapScreen> createState() => _FarmersMapScreenState();
}

class _FarmersMapScreenState extends ConsumerState<FarmersMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  bool _isListVisible = false;

  void _toggleListVisibility() {
    setState(() {
      _isListVisible = !_isListVisible;
    });
  }

  void _goToFarmerLocation(Farmer farmer) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(farmer.latitude, farmer.longitude),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ... (Keep existing _performSearch, _showFilterBottomSheet logic) ...
  void _performSearch() {}
  void _showFilterBottomSheet() {}

  LatLng _calculateCenter(List<Farmer> f) {
    final mapFarmers = f.where((farmer) => farmer.hasMapFeature).toList();
    if (mapFarmers.isEmpty)
      return const LatLng(-6.200000, 106.816666); // Default to Jakarta
    double lat = 0;
    double lng = 0;
    for (var farmer in mapFarmers) {
      lat += farmer.latitude;
      lng += farmer.longitude;
    }
    return LatLng(lat / mapFarmers.length, lng / mapFarmers.length);
  }

  Set<Marker> _createMarkers(List<Farmer> f) {
    return f.where((farmer) => farmer.hasMapFeature).map((farmer) {
      return Marker(
        markerId: MarkerId(farmer.id),
        position: LatLng(farmer.latitude, farmer.longitude),
        infoWindow: InfoWindow(
          title: farmer.name,
          snippet: farmer.address,
        ),
        onTap: () {
          _goToFarmerLocation(farmer);
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final farmersState = ref.watch(farmersControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. FULL SCREEN MAP
          farmersState.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (farmers) {
              final center = _calculateCenter(farmers);
              return GoogleMap(
                initialCameraPosition: CameraPosition(target: center, zoom: 12),
                onMapCreated: (controller) => _mapController = controller,
                markers: _createMarkers(farmers),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
                mapToolbarEnabled: false,
              );
            },
            error: (msg) => Center(child: Text('error: $msg')),
          ),

          // 2. FLOATING TOP BAR (Back + Search)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Floating Back Button
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: kDarkGreen),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Floating Search
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25), // Pill
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Icon(Icons.search, color: Colors.grey[500]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: GoogleFonts.dmSans(color: kDarkGreen),
                                decoration: InputDecoration(
                                  hintText: 'Search map area...',
                                  hintStyle: GoogleFonts.dmSans(
                                      color: Colors.grey[500]),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                                onSubmitted: (_) => _performSearch(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.tune_rounded,
                                  color: kDarkGreen),
                              onPressed: _showFilterBottomSheet,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. FLOATING COUNT CAPSULE
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isListVisible ? -100 : 30,
            left: 0,
            right: 0,
            child: Center(
              child: farmersState.maybeWhen(
                loaded: (farmers) {
                  final count = farmers.where((f) => f.hasMapFeature).length;
                  if (count == 0) return const SizedBox.shrink();

                  return GestureDetector(
                    onTap: _toggleListVisibility,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: kDarkGreen,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: kDarkGreen.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.map, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '$count farmers nearby',
                            style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),

          // 3.5 CURRENT LOCATION BUTTON
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isListVisible
                ? (MediaQuery.of(context).size.height * 0.6) + 16
                : 100,
            right: 16,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location, color: kDarkGreen),
                onPressed: _goToCurrentLocation,
              ),
            ),
          ),

          // 4. ANIMATED BOTTOM SHEET (FARMERS LIST)
          farmersState.maybeWhen(
            loaded: (farmers) {
              final visibleFarmers =
                  farmers.where((f) => f.hasMapFeature).toList();
              if (visibleFarmers.isEmpty) return const SizedBox.shrink();

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                bottom: _isListVisible
                    ? 0
                    : -(MediaQuery.of(context).size.height * 0.6),
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      GestureDetector(
                        onTap: _toggleListVisibility,
                        onVerticalDragUpdate: (details) {
                          if (details.primaryDelta! > 5) {
                            setState(() {
                              _isListVisible = false;
                            });
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          color: Colors.transparent, // to catch taps
                          padding: const EdgeInsets.only(top: 12, bottom: 16),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${visibleFarmers.length} Farmers Nearby',
                              style: GoogleFonts.dmSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: _toggleListVisibility,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      // List
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: visibleFarmers.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final farmer = visibleFarmers[index];
                            return _buildFarmerListItem(farmer);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerListItem(Farmer farmer) {
    return InkWell(
      onTap: () {
        _goToFarmerLocation(farmer);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Farmer Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                image: farmer.coverImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(farmer.coverImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: farmer.coverImage.isEmpty
                  ? const Icon(Icons.store, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            // Farmer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmer.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    farmer.description,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          farmer.address,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: Colors.grey[500],
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
            const SizedBox(width: 8),
            // Distance / Action
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: kPillGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions, color: kDarkGreen, size: 20),
            )
          ],
        ),
      ),
    );
  }
}
