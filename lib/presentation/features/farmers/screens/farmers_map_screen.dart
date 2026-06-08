import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // ... (Keep existing _performSearch, _showFilterBottomSheet, _calculateCenter, _createMarkers logic) ...
  // Re-pasting standard logic omitted for brevity, ensure you keep the logic methods from your snippet.
  void _performSearch() {}
  void _showFilterBottomSheet() {}
  LatLng _calculateCenter(List<Farmer> f) =>
      const LatLng(0, 0); // Use your logic
  Set<Marker> _createMarkers(List<Farmer> f) => {}; // Use your logic

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
              // ... (Your existing map logic)
              return GoogleMap(
                initialCameraPosition:
                    const CameraPosition(target: LatLng(0, 0), zoom: 12),
                // ... map settings
              );
            },
            error: (msg) => Center(child: Text(msg)),
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
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: farmersState.maybeWhen(
                loaded: (farmers) {
                  final count = farmers.where((f) => f.hasMapFeature).length;
                  if (count == 0) return const SizedBox.shrink();

                  return Container(
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
}
