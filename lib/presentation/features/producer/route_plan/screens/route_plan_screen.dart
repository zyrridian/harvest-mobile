import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routePlanState = ref.watch(routePlanControllerProvider);
    final routePlanController = ref.read(routePlanControllerProvider.notifier);
    final ordersState = ref.watch(farmerOrdersControllerProvider(status: 'all'));

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'Route Plan',
          style: TextStyle(
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
                  final orderIds = deliveryOrders.map((e) => e.id.toString()).toList();
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
                  style: TextStyle(
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
              loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
              error: (error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error, style: TextStyle(color: Colors.red)),
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
                final route = routes.first;
                return _buildRouteDetails(context, route, routePlanController);
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
            style: TextStyle(
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate a new route plan based on pending orders.',
            style: TextStyle(
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
                  style: TextStyle(
                    color: kAccentOrange,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return ElevatedButton.icon(
                onPressed: () async {
                  final orderIds = deliveryOrders.map((e) => e.id.toString()).toList();
                  final success = await routePlanController.createRoutePlan(orderIds);
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Route Plan Generated Successfully!')),
                    );
                  }
                },
                icon: const Icon(PhosphorIconsRegular.magicWand, color: Colors.white),
                label: Text('Generate Route Plan',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildRouteDetails(BuildContext context, dynamic route, RoutePlanController controller) {
    return Column(
      children: [
        _buildMapPreview(route),
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
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: route.stops.length,
            onReorder: (oldIndex, newIndex) async {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final stops = List.of(route.stops);
              final stop = stops.removeAt(oldIndex);
              stops.insert(newIndex, stop);
              
              final stopIds = stops.map<String>((s) => s.stopId).toList();
              await controller.reorderStops(route.routeId, stopIds);
            },
            itemBuilder: (context, index) {
              final stop = route.stops[index];
              return _buildStopCard(stop, route.routeId, controller, key: ValueKey(stop.stopId));
            },
          ),
        ),
        _buildRouteExecutionControls(context, route, controller),
      ],
    );
  }

  Widget _buildMapPreview(dynamic route) {
    if (route.stops.isEmpty) return const SizedBox.shrink();

    final validStops = route.stops.where((s) => s.requiresManualNavigation != true && s.addressLat != null && s.addressLng != null).toList();
    
    if (validStops.isEmpty) {
      return Container(
        height: 150,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorderColor),
        ),
        child: Center(
          child: Text(
            'All stops require manual navigation.\nMap preview unavailable.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kTextGrey),
          ),
        ),
      );
    }

    final initialTarget = LatLng(validStops.first.addressLat, validStops.first.addressLng);
    
    final markers = validStops.map<Marker>((s) {
      return Marker(
        markerId: MarkerId(s.stopId),
        position: LatLng(s.addressLat, s.addressLng),
        infoWindow: InfoWindow(title: s.recipientName, snippet: s.addressLabel),
      );
    }).toSet();

    final polyline = Polyline(
      polylineId: const PolylineId('route_line'),
      color: kAccentOrange,
      width: 4,
      points: validStops.map<LatLng>((s) => LatLng(s.addressLat, s.addressLng)).toList(),
    );

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 12,
          ),
          markers: markers,
          polylines: {polyline},
          onMapCreated: (GoogleMapController c) {
            _mapController = c;
            // Optionally fit map to bounds here
          },
          myLocationEnabled: true,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: kAccentOrange, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: kTextGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStopCard(dynamic stop, String routeId, RoutePlanController controller, {required Key key}) {
    final isDelivered = stop.status == 'delivered';
    final isFailed = stop.status == 'failed';
    
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  style: TextStyle(
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kDarkGreen,
                      ),
                    ),
                    if (stop.orderNumber != null)
                      Text(
                        'Order: ${stop.orderNumber}',
                        style: TextStyle(
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
                            style: TextStyle(
                              fontSize: 13,
                              color: kTextGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (stop.requiresManualNavigation == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Requires Manual Navigation',
                          style: TextStyle(fontSize: 11, color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDelivered ? const Color(0xFFE8F5E9) : (isFailed ? const Color(0xFFFFEBEE) : const Color(0xFFFFF3E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  stop.status.toUpperCase(),
                  style: TextStyle(
                    color: isDelivered ? Colors.green : (isFailed ? Colors.red : kAccentOrange),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(PhosphorIconsRegular.phoneCall, color: kPrimaryGreen),
                onPressed: () {
                   // Add phone call logic
                },
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _openStopInMaps(stop),
                icon: const Icon(PhosphorIconsRegular.navigationArrow, size: 16, color: kPrimaryGreen),
                label: const Text('Navigate'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryGreen,
                  side: const BorderSide(color: kPrimaryGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(0, 40), // Override global infinite width
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(width: 8),
              if (!isDelivered && !isFailed)
                ElevatedButton(
                  onPressed: () async {
                    await controller.updateStopStatus(routeId, stop.stopId, 'delivered');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size(0, 40), // Override global infinite width
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Delivered'),
                ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRouteExecutionControls(BuildContext context, dynamic route, RoutePlanController controller) {
    if (route.status == 'draft') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await controller.updateRouteStatus(route.routeId, 'in_progress');
            },
            icon: const Icon(PhosphorIconsRegular.playCircle, color: Colors.white),
            label: Text(
              'Start Route',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAccentOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    } else if (route.status == 'in_progress') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              await controller.updateRouteStatus(route.routeId, 'completed');
            },
            icon: const Icon(PhosphorIconsRegular.checkCircle, color: Colors.white),
            label: Text(
              'Complete Route',
              style: TextStyle(
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
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _openStopInMaps(dynamic stop) async {
    String url = 'https://www.google.com/maps/dir/?api=1';
    
    if (stop.requiresManualNavigation != true && stop.addressLat != null && stop.addressLng != null) {
      url += '&destination=${stop.addressLat},${stop.addressLng}';
    } else {
      url += '&destination=${Uri.encodeComponent(stop.addressLabel)}';
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
