import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/route_plan_controller.dart';
import '../../orders/providers/farmer_orders_controller.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class RoutePlanScreen extends ConsumerStatefulWidget {
  const RoutePlanScreen({super.key});

  @override
  ConsumerState<RoutePlanScreen> createState() => _RoutePlanScreenState();
}

class _RoutePlanScreenState extends ConsumerState<RoutePlanScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final routePlanState = ref.watch(routePlanControllerProvider);
    final routePlanController = ref.read(routePlanControllerProvider.notifier);
    
    // Also fetch orders so we can generate the route
    final ordersState = ref.watch(farmerOrdersControllerProvider(status: 'all'));

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'Route Plan',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkGreen),
        actions: [
          ordersState.maybeWhen(
            data: (orders) {
              final deliveryOrders = orders.where((o) => o.deliveryMethod == 'farmer_delivery').toList();
              if (deliveryOrders.isEmpty) return const SizedBox.shrink();

              return TextButton.icon(
                onPressed: () async {
                  final orderIds = deliveryOrders.map<String>((e) => e.id).toList();
                  final success = await routePlanController.createRoutePlan(orderIds);
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Route Plan Generated Successfully!')),
                    );
                  }
                },
                icon: const Icon(PhosphorIconsRegular.magicWand, color: kAccentOrange, size: 20),
                label: Text(
                  'Regenerate',
                  style: GoogleFonts.inter(
                    color: kAccentOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(context, routePlanController),
          Expanded(
            child: routePlanState.maybeWhen(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: kDarkGreen)),
              error: (error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error, style: GoogleFonts.inter(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => routePlanController.refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (routes) {
                if (routes.isEmpty) {
                  return _buildEmptyState(context, ordersState, routePlanController);
                }
                
                // Assuming one route per day for simplicity
                final route = routes.first;
                return _buildRouteDetails(context, route);
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, dynamic controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kDarkGreen,
            ),
          ),
          IconButton(
            icon: const Icon(PhosphorIconsRegular.calendar, color: kAccentOrange),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: kDarkGreen,
                        onPrimary: Colors.white,
                        onSurface: kDarkGreen,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
                controller.setDate(picked);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, dynamic ordersState, dynamic routePlanController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(PhosphorIconsRegular.mapTrifold, size: 64, color: kTextGrey),
          const SizedBox(height: 16),
          Text(
            'No route plan for this date',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a new route plan based on pending orders.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: kTextGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ordersState.maybeWhen(
            data: (orders) {
              final deliveryOrders = orders.where((o) => o.deliveryMethod == 'farmer_delivery').toList();
              
              if (deliveryOrders.isEmpty) {
                return Text(
                  'No pending deliveries for today.',
                  style: GoogleFonts.inter(
                    color: kAccentOrange,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return ElevatedButton.icon(
                onPressed: () async {
                  final orderIds = deliveryOrders.map<String>((e) => e.id).toList();
                  final success = await routePlanController.createRoutePlan(orderIds);
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Route Plan Generated Successfully!')),
                    );
                  }
                },
                icon: const Icon(PhosphorIconsRegular.magicWand, color: Colors.white),
                label: Text('Generate Route Plan',
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            orElse: () => const CircularProgressIndicator(color: kDarkGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteDetails(BuildContext context, dynamic route) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kDarkGreen,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(PhosphorIconsRegular.mapPinLine, '${route.stopCount}', 'Stops'),
              _buildStatItem(PhosphorIconsRegular.path, '${route.totalDistanceKm} km', 'Distance'),
              _buildStatItem(PhosphorIconsRegular.clock, '${route.estimatedMinutes} min', 'Est. Time'),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: route.stops.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final stop = route.stops[index];
              return _buildStopCard(stop);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openGoogleMaps(),
              icon: const Icon(PhosphorIconsRegular.navigationArrow, color: Colors.white),
              label: Text(
                'Open in Google Maps',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: kAccentOrange, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            color: kTextGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStopCard(dynamic stop) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F5F2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${stop.stopOrder}',
              style: GoogleFonts.inter(
                color: kDarkGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop.recipientName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kDarkGreen,
                  ),
                ),
                if (stop.orderNumber != null)
                  Text(
                    'Order: ${stop.orderNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: kTextGrey,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(PhosphorIconsRegular.mapPin, size: 16, color: kAccentOrange),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        stop.addressLabel,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: kTextGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: stop.status == 'completed' ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              stop.status.toUpperCase(),
              style: GoogleFonts.inter(
                color: stop.status == 'completed' ? Colors.green : kAccentOrange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGoogleMaps() async {
    final state = ref.read(routePlanControllerProvider);
    
    // Safety check - we know it's Data if it got this far.
    final routes = state.whenOrNull(data: (r) => r);
    if (routes == null || routes.isEmpty) return;
    
    final route = routes.first;
    if (route.stops.isEmpty) return;

    // Use the first stop as destination and remaining as waypoints.
    final firstStop = route.stops.first;
    
    // We ideally need lat/lng. If we only have address label, we'll try to query it.
    String url = 'https://www.google.com/maps/dir/?api=1';
    
    if (firstStop.addressLat != null && firstStop.addressLng != null) {
      url += '&destination=${firstStop.addressLat},${firstStop.addressLng}';
    } else {
      url += '&destination=${Uri.encodeComponent(firstStop.addressLabel)}';
    }

    if (route.stops.length > 1) {
      final waypoints = route.stops.skip(1).map((s) {
        if (s.addressLat != null && s.addressLng != null) {
          return '${s.addressLat},${s.addressLng}';
        }
        return Uri.encodeComponent(s.addressLabel);
      }).join('|');
      url += '&waypoints=$waypoints';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Google Maps')),
        );
      }
    }
  }
}
