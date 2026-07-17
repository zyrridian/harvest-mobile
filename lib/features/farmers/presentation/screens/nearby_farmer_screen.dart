import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import 'package:harvest_app/features/farmers/domain/entities/nearby_farmer.dart';
import 'package:harvest_app/features/farmers/presentation/providers/nearby_farmer_controller.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kHighlightGreen = Color(0xFF4A7C38);

class NearbyFarmerScreen extends ConsumerStatefulWidget {
  const NearbyFarmerScreen({super.key});

  @override
  ConsumerState<NearbyFarmerScreen> createState() => _NearbyFarmerScreenState();
}

class _NearbyFarmerScreenState extends ConsumerState<NearbyFarmerScreen> {
  GoogleMapController? _mapController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _isListView = true;
  String? _selectedFarmerId;
  bool _isScrolled = false;
  final Set<String> _expandedCabangFarmers = {};

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(() {
      if (_sheetController.size <= 0.3 && _isListView) {
        setState(() => _isListView = false);
      } else if (_sheetController.size > 0.3 && !_isListView) {
        setState(() => _isListView = true);
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nearbyFarmerControllerProvider);
    final controller = ref.read(nearbyFarmerControllerProvider.notifier);

    return Scaffold(
      backgroundColor: kBgColor,
      resizeToAvoidBottomInset: false,
      body: state.when(
        initial: () => const SizedBox(),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (err) => Center(child: Text('Error: $err')),
        data: (farmers, searchQuery, isOrganicFilter, isOpenNowFilter, radius, isLoading) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final sheetHeaderHeight = 100.0;
              final minFraction = sheetHeaderHeight / constraints.maxHeight;
              final topPadding = MediaQuery.of(context).padding.top;
              final safeTopSpace = topPadding + 140.0;
              final maxFraction = ((constraints.maxHeight - safeTopSpace) /
                      constraints.maxHeight)
                  .clamp(0.5, 1.0);

              return Stack(
                children: [
                  // Map Area
                  Positioned.fill(
                    child: GoogleMap(
                      padding: EdgeInsets.only(
                        top: topPadding + 80,
                        bottom: _isListView ? (constraints.maxHeight * 0.5) : sheetHeaderHeight,
                      ),
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-6.200000, 106.816666),
                        zoom: 13,
                      ),
                      markers: farmers
                          .expand((f) {
                            final List<Marker> markers = [];
                            
                            // Plot Main Farm Location (if valid coordinates exist)
                            if (f.mainLocation != null) {
                              markers.add(Marker(
                                markerId: MarkerId('main-${f.id}'),
                                position: LatLng(f.mainLocation!.latitude, f.mainLocation!.longitude),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  _selectedFarmerId == f.id
                                      ? BitmapDescriptor.hueGreen
                                      : BitmapDescriptor.hueRed,
                                ),
                                onTap: () {
                                  setState(() => _selectedFarmerId = f.id);
                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLng(
                                        LatLng(f.mainLocation!.latitude, f.mainLocation!.longitude)),
                                  );
                                },
                              ));
                            } else {
                              // Fallback to legacy farmer coordinates
                              markers.add(Marker(
                                markerId: MarkerId('main-${f.id}'),
                                position: LatLng(f.latitude, f.longitude),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  _selectedFarmerId == f.id
                                      ? BitmapDescriptor.hueGreen
                                      : BitmapDescriptor.hueRed,
                                ),
                                onTap: () {
                                  setState(() => _selectedFarmerId = f.id);
                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLng(
                                        LatLng(f.latitude, f.longitude)),
                                  );
                                },
                              ));
                            }

                            // Plot all Cabang / Branches
                            for (var branch in f.cabang) {
                              markers.add(Marker(
                                markerId: MarkerId('branch-${branch.id}'),
                                position: LatLng(branch.latitude, branch.longitude),
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  _selectedFarmerId == f.id
                                      ? BitmapDescriptor.hueGreen
                                      : BitmapDescriptor.hueOrange,
                                ),
                                onTap: () {
                                  setState(() => _selectedFarmerId = f.id);
                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLng(
                                        LatLng(branch.latitude, branch.longitude)),
                                  );
                                },
                              ));
                            }
                            return markers;
                          })
                          .toSet(),
                      onMapCreated: (mapController) =>
                          _mapController = mapController,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                  ),
                  // Search bar overlay
                  Positioned(
                    top: topPadding + 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (val) =>
                                  controller.updateSearchQuery(val),
                              style: TextStyle(fontSize: 13),
                              cursorColor: kDarkGreen,
                              decoration: InputDecoration(
                                hintText: 'Search area or farmer name...',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 13),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                          DropdownButton<double>(
                            value: radius,
                            icon: const Icon(Icons.arrow_drop_down, size: 16),
                            underline: const SizedBox(),
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                            items: const [
                              DropdownMenuItem(value: 3.0, child: Text('3 km')),
                              DropdownMenuItem(value: 5.0, child: Text('5 km')),
                              DropdownMenuItem(value: 10.0, child: Text('10 km')),
                              DropdownMenuItem(value: 0.0, child: Text('All')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                controller.updateRadius(val);
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          // GestureDetector(
                          //   onTap: () => controller.toggleOpenNowFilter(),
                          //   child: Container(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 12, vertical: 6),
                          //     decoration: BoxDecoration(
                          //       color: isOpenNowFilter
                          //           ? kHighlightGreen.withOpacity(0.1)
                          //           : Colors.transparent,
                          //       border: Border.all(
                          //           color: isOpenNowFilter
                          //               ? kHighlightGreen
                          //               : Colors.grey[300]!),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     // child: Row(
                          //     //   children: [
                          //     //     Icon(PhosphorIconsRegular.clock,
                          //     //         size: 14,
                          //     //         color: isOpenNowFilter
                          //     //             ? kHighlightGreen
                          //     //             : Colors.black87),
                          //     //     const SizedBox(width: 4),
                          //     //     Text('Open now',
                          //     //         style: TextStyle(
                          //     //             fontSize: 12,
                          //     //             color: isOpenNowFilter
                          //     //                 ? kHighlightGreen
                          //     //                 : Colors.black87)),
                          //     //   ],
                          //     // ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // Current location button
                  AnimatedBuilder(
                    animation: _sheetController,
                    builder: (context, child) {
                      double posSize = 0.5;
                      if (_sheetController.isAttached) {
                        posSize = _sheetController.size;
                      }
                      return Positioned(
                        bottom: (posSize * constraints.maxHeight) + 16,
                        right: 16,
                        child: child!,
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLng(
                              const LatLng(-6.200000, 106.816666)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.my_location,
                            color: kDarkGreen, size: 20),
                      ),
                    ),
                  ),
                  // // Legend overlay
                  // AnimatedBuilder(
                  //   animation: _sheetController,
                  //   builder: (context, child) {
                  //     double posSize = 0.5;
                  //     if (_sheetController.isAttached) {
                  //       posSize = _sheetController.size;
                  //     }
                  //     return Positioned(
                  //       bottom: (posSize * constraints.maxHeight) + 16,
                  //       left: 68,
                  //       child: child!,
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 12, vertical: 8),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(20),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.05),
                  //           blurRadius: 10,
                  //           offset: const Offset(0, 2),
                  //         ),
                  //       ],
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         _buildLegendItem(
                  //             const Color(0xFF4A7C38), 'Produce'),
                  //         const SizedBox(width: 12),
                  //         _buildLegendItem(
                  //             const Color(0xFFD97706), 'Aquaculture'),
                  //         const SizedBox(width: 12),
                  //         _buildLegendItem(Colors.grey, 'Closed'),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Dark Overlay
                  AnimatedBuilder(
                    animation: _sheetController,
                    builder: (context, child) {
                      double currentSize = 0.5;
                      if (_sheetController.isAttached) {
                        currentSize = _sheetController.size;
                      }
                      double opacity = 0.0;
                      if (currentSize > 0.5 && maxFraction > 0.5) {
                        opacity = ((currentSize - 0.5) / (maxFraction - 0.5))
                                .clamp(0.0, 1.0) *
                            0.5;
                      }

                      if (opacity <= 0.0) return const SizedBox.shrink();

                      return Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            _sheetController.animateTo(0.5,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          },
                          child: Container(
                            color: Colors.black.withOpacity(opacity),
                          ),
                        ),
                      );
                    },
                  ),
                  // Back button overlay (Not covered by dark overlay)
                  AnimatedBuilder(
                    animation: _sheetController,
                    builder: (context, child) {
                      double posSize = 0.5;
                      if (_sheetController.isAttached) {
                        posSize = _sheetController.size;
                      }
                      return Positioned(
                        bottom: (posSize * constraints.maxHeight) + 16,
                        left: 16,
                        child: child!,
                      );
                    },
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: kDarkGreen, size: 20),
                      ),
                    ),
                  ),
                  // Bottom Sheet
                  DraggableScrollableSheet(
                    controller: _sheetController,
                    initialChildSize: 0.5,
                    minChildSize: minFraction,
                    maxChildSize: maxFraction,
                    snap: true,
                    snapSizes: const [0.5],
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              physics: const ClampingScrollPhysics(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(24)),
                                boxShadow: _isScrolled
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                children: [
                                  // Drag handle
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 12, bottom: 8),
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                  // List Header
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${farmers.length} farmers near you ${radius == 0.0 ? '' : '· within ${radius.toInt()} km'}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (isLoading)
                                          const SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: kDarkGreen),
                                          ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _sheetController.animateTo(0.5,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: _isListView
                                                      ? kHighlightGreen
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: _isListView
                                                          ? kHighlightGreen
                                                          : Colors.grey[300]!),
                                                ),
                                                child: Icon(Icons.list,
                                                    size: 20,
                                                    color: _isListView
                                                        ? Colors.white
                                                        : Colors.black87),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                _sheetController.animateTo(
                                                    minFraction,
                                                    duration: const Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.easeInOut);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: !_isListView
                                                      ? kHighlightGreen
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: !_isListView
                                                          ? kHighlightGreen
                                                          : Colors.grey[300]!),
                                                ),
                                                child: Icon(Icons.map_outlined,
                                                    size: 20,
                                                    color: !_isListView
                                                        ? Colors.white
                                                        : Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ),
                            // List
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    if (notification.metrics.axis ==
                                        Axis.vertical) {
                                      bool scrolled =
                                          notification.metrics.pixels > 2.0;
                                      if (scrolled != _isScrolled) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          if (mounted) {
                                            setState(
                                                () => _isScrolled = scrolled);
                                          }
                                        });
                                      }
                                    }
                                    return false;
                                  },
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 24),
                                    itemCount: farmers.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 16),
                                    itemBuilder: (context, index) {
                                      return _buildFarmerCard(farmers[index],
                                          isFirst: index == 0);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildFarmerCard(NearbyFarmerData farmer, {bool isFirst = false}) {
    final isSelected = _selectedFarmerId == farmer.id;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedFarmerId = farmer.id);
        final lat = farmer.mainLocation?.latitude ?? farmer.latitude;
        final lng = farmer.mainLocation?.longitude ?? farmer.longitude;
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(lat, lng)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: isSelected ? kHighlightGreen : Colors.grey[200]!,
              width: 1.5),
        ),
        child: Column(
          children: [
            // Header info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3E8), // light green
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(farmer.iconPath,
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmer.name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${farmer.category} · ${farmer.subCategory}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: farmer.tags.map((tag) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: tag == 'Organic'
                                      ? const Color(0xFFE8F3E8)
                                      : (tag == 'Community seller'
                                          ? const Color(0xFFE3F2FD)
                                          : const Color(0xFFFFF3E0)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: tag == 'Organic'
                                        ? const Color(0xFF2E7D32)
                                        : (tag == 'Community seller'
                                            ? const Color(0xFF1565C0)
                                            : const Color(0xFFE65100)),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${farmer.distance}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kHighlightGreen),
                    ),
                    Text(
                      'km away',
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          '${farmer.rating} (${farmer.reviewCount})',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            // Products and Actions
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...farmer.products
                            .map((p) => Row(
                                  children: [
                                    Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                            color:
                                                farmer.category == 'Aquaculture'
                                                    ? const Color(0xFFD97706)
                                                    : kHighlightGreen,
                                            shape: BoxShape.circle)),
                                    const SizedBox(width: 4),
                                    Text(p.name,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[800])),
                                    const SizedBox(width: 8),
                                  ],
                                ))
                            ,
                        if (farmer.extraProductsCount > 0)
                          Text('+${farmer.extraProductsCount} more',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey[600],
                                  height: 1.1)),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          'chat',
                          extra: {
                            'farmerName': farmer.name,
                            'farmerAvatar': farmer.iconPath,
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.chat_bubble_outline,
                                size: 14, color: Colors.black87),
                            const SizedBox(width: 4),
                            Text('Chat',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final mockFarmer = Farmer(
                          id: farmer.id,
                          userId: 'u1',
                          name: farmer.name,
                          description: 'A great farmer',
                          latitude: farmer.latitude,
                          longitude: farmer.longitude,
                          address: '',
                          rating: farmer.rating,
                          totalReviews: farmer.reviewCount,
                          totalProducts: farmer.products.length +
                              farmer.extraProductsCount,
                          specialties: farmer.tags,
                          isVerified: true,
                          hasMapFeature: true,
                          joinedDate: DateTime.now(),
                          isOnline: farmer.isOpen,
                        );
                        context.push(AppRouter.farmerDetail, extra: mockFarmer);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: farmer.name == 'Fish Factory'
                              ? const Color(0xFFB87333)
                              : kHighlightGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Visit',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            // Status and Branches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   children: [
                //     Container(
                //       width: 6,
                //       height: 6,
                //       decoration: BoxDecoration(
                //         color: farmer.isOpen ? kHighlightGreen : Colors.grey,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //     const SizedBox(width: 6),
                //     Text(
                //       farmer.statusText,
                //       style: TextStyle(
                //           fontSize: 11,
                //           color:
                //               farmer.isOpen ? kHighlightGreen : Colors.grey[700]),
                //     ),
                //     if (farmer.statusSubText.isNotEmpty)
                //       Text(
                //         ' · ${farmer.statusSubText}',
                //         style: TextStyle(
                //             fontSize: 11, color: Colors.grey[600]),
                //       ),
                //   ],
                // ),
                const SizedBox(), // Placeholder for removed opening time Row
                if (farmer.cabang.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_expandedCabangFarmers.contains(farmer.id)) {
                          _expandedCabangFarmers.remove(farmer.id);
                        } else {
                          _expandedCabangFarmers.add(farmer.id);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(PhosphorIconsRegular.mapPin, size: 12, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            '${farmer.cabang.length} Branches',
                            style: TextStyle(fontSize: 10, color: Colors.orange[800], fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _expandedCabangFarmers.contains(farmer.id)
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 14,
                            color: Colors.orange[800],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Expanded Branches List
            if (farmer.cabang.isNotEmpty)
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: _expandedCabangFarmers.contains(farmer.id)
                      ? const BoxConstraints(maxHeight: double.infinity)
                      : const BoxConstraints(maxHeight: 0.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 12),
                        Text(
                          'Available at these locations:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kDarkGreen),
                        ),
                        const SizedBox(height: 8),
                        ...farmer.cabang.map((branch) => GestureDetector(
                              onTap: () {
                                setState(() => _selectedFarmerId = farmer.id);
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLng(LatLng(branch.latitude, branch.longitude)),
                                );
                              },
                              child: Container(
                                color: Colors.transparent, // Ensure it catches taps
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(PhosphorIconsFill.mapPin, size: 16, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            branch.name,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            branch.address ?? 'No address available',
                                            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (branch.distance != null)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2.0),
                                              child: Text(
                                                '${branch.distance} km away',
                                                style: TextStyle(fontSize: 10, color: kHighlightGreen, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
