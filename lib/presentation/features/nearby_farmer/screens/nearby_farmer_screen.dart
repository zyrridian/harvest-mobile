import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest_app/presentation/features/nearby_farmer/providers/nearby_farmer_controller.dart';
import 'package:harvest_app/presentation/features/nearby_farmer/providers/nearby_farmer_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nearbyFarmerControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Icon(Icons.chevron_left, color: kDarkGreen),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Nearby Farmers',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Icon(Icons.tune, color: kDarkGreen),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: state.when(
        initial: () => const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (err) => Center(child: Text('Error: $err')),
        data: (farmers) {
          return Column(
            children: [
              // Map Area
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(-6.200000, 106.816666),
                        zoom: 13,
                      ),
                      onMapCreated: (controller) => _mapController = controller,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                    // Search bar overlay
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              child: Text(
                                'Search area or farmer name...',
                                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Organic', style: GoogleFonts.inter(fontSize: 12)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Open now', style: GoogleFonts.inter(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Legend overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            _buildLegendItem(const Color(0xFF4A7C38), 'Produce'),
                            const SizedBox(width: 12),
                            _buildLegendItem(const Color(0xFFD97706), 'Aquaculture'),
                            const SizedBox(width: 12),
                            _buildLegendItem(Colors.grey, 'Closed'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // List Header
              Container(
                color: kBgColor,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${farmers.length} farmers near you · within 3 km',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Icon(Icons.list, size: 20),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Icon(Icons.map_outlined, size: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: farmers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildFarmerCard(farmers[index], isFirst: index == 0);
                  },
                ),
              ),
            ],
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
          style: GoogleFonts.inter(fontSize: 10, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildFarmerCard(NearbyFarmerData farmer, {bool isFirst = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isFirst ? kHighlightGreen : Colors.grey[200]!, width: isFirst ? 1.5 : 1),
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
                  child: Text(farmer.iconPath, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmer.name,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkGreen),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${farmer.category} · ${farmer.subCategory}',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: farmer.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: tag == 'Organic' ? const Color(0xFFE8F3E8) : (tag == 'Community seller' ? const Color(0xFFE3F2FD) : const Color(0xFFFFF3E0)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: tag == 'Organic' ? const Color(0xFF2E7D32) : (tag == 'Community seller' ? const Color(0xFF1565C0) : const Color(0xFFE65100)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${farmer.distance}',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: kHighlightGreen),
                  ),
                  Text(
                    'km away',
                    style: GoogleFonts.inter(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        '${farmer.rating} (${farmer.reviewCount})',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[700]),
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
                child: Row(
                  children: [
                    ...farmer.products.map((p) => Row(
                      children: [
                        Container(width: 6, height: 6, decoration: BoxDecoration(color: farmer.category == 'Aquaculture' ? const Color(0xFFD97706) : kHighlightGreen, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text(p.name, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[800])),
                        const SizedBox(width: 8),
                      ],
                    )).toList(),
                    if (farmer.extraProductsCount > 0)
                      Text('+${farmer.extraProductsCount}\nmore', style: GoogleFonts.inter(fontSize: 9, color: Colors.grey[600], height: 1.1)),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 14, color: Colors.black87),
                        const SizedBox(width: 4),
                        Text('Chat', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: farmer.name == 'Fish Factory' ? const Color(0xFFB87333) : Colors.white,
                      border: Border.all(color: farmer.name == 'Fish Factory' ? const Color(0xFFB87333) : Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Visit',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: farmer.name == 'Fish Factory' ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          // Status
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: farmer.isOpen ? kHighlightGreen : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                farmer.statusText,
                style: GoogleFonts.inter(fontSize: 11, color: farmer.isOpen ? kHighlightGreen : Colors.grey[700]),
              ),
              if (farmer.statusSubText.isNotEmpty)
                Text(
                  ' · ${farmer.statusSubText}',
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[700]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
