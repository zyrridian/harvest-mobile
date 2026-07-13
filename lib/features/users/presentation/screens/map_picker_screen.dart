import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);

class MapPickerScreen extends StatefulWidget {
  final LatLng initialLocation;

  const MapPickerScreen({
    super.key,
    required this.initialLocation,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late LatLng _selectedLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pick Location',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              _selectedLocation = position.target;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
          ),
          // Center Marker Pin
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0), // Adjust to point to exact center
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
          // Actions
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'my_location',
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.my_location, color: kDarkGreen),
                  onPressed: () {
                    // Could use geolocator to get current position, but for now just move to initial
                    _mapController?.animateCamera(
                      CameraUpdate.newLatLng(widget.initialLocation),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _selectedLocation),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDarkGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
