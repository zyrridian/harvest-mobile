import 'package:equatable/equatable.dart';

class Farmer extends Equatable {
  final String id;
  final String farmerId;
  final FarmerProfile farmerProfile;
  final String name;
  final String description;
  final String whatWeSell;
  final double latitude;
  final double longitude;
  final String address;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final double distance;

  // Compatibility getter to minimize UI changes immediately
  bool get hasMapFeature => true;
  String get profileImage => farmerProfile.profileImage ?? '';
  String get coverImage => imageUrl ?? farmerProfile.profileImage ?? '';
  double get rating => farmerProfile.rating;
  String get city => farmerProfile.city;
  bool get isVerified => farmerProfile.isVerified;
  List<String> get specialties => [whatWeSell];
  bool get isOnline => isActive;

  const Farmer({
    required this.id,
    required this.farmerId,
    required this.farmerProfile,
    required this.name,
    required this.description,
    required this.whatWeSell,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.distance = 0.0,
  });

  /// Format distance for display
  String get distanceLabel {
    if (distance < 1) {
      return '${(distance * 1000).toInt()}m away';
    }
    return '${distance.toStringAsFixed(1)}km away';
  }

  @override
  List<Object?> get props => [
        id,
        farmerId,
        farmerProfile,
        name,
        description,
        whatWeSell,
        latitude,
        longitude,
        address,
        imageUrl,
        isActive,
        createdAt,
        distance,
      ];
}

class FarmerProfile extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final bool isVerified;
  final double rating;
  final String city;

  const FarmerProfile({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isVerified,
    required this.rating,
    required this.city,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        profileImage,
        isVerified,
        rating,
        city,
      ];
}
