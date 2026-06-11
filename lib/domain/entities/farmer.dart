import 'package:equatable/equatable.dart';

class Farmer extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String? profileImage;
  final String? coverImage;
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? state;
  final double rating;
  final int totalReviews;
  final int totalProducts;
  final List<String> specialties;
  final bool isVerified;
  final bool hasMapFeature;
  final String? phoneNumber;
  final String? email;
  final DateTime joinedDate;
  final bool isOnline;
  final double? distance;
  // Detail only fields
  final String? verificationBadge;
  final double? responseRate;
  final int? followersCount;

  // Compatibility getters for the UI to reduce some breakage
  String get whatWeSell => specialties.isNotEmpty ? specialties.first : '';
  bool get isActive => isOnline;
  String? get imageUrl => coverImage;

  const Farmer({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.profileImage,
    this.coverImage,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.city,
    this.state,
    required this.rating,
    required this.totalReviews,
    required this.totalProducts,
    required this.specialties,
    required this.isVerified,
    required this.hasMapFeature,
    this.phoneNumber,
    this.email,
    required this.joinedDate,
    required this.isOnline,
    this.distance,
    this.verificationBadge,
    this.responseRate,
    this.followersCount,
  });

  /// Format distance for display
  String get distanceLabel {
    if (distance == null) return '';
    if (distance! < 1) {
      return '${(distance! * 1000).toInt()}m away';
    }
    return '${distance!.toStringAsFixed(1)}km away';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        profileImage,
        coverImage,
        latitude,
        longitude,
        address,
        city,
        state,
        rating,
        totalReviews,
        totalProducts,
        specialties,
        isVerified,
        hasMapFeature,
        phoneNumber,
        email,
        joinedDate,
        isOnline,
        distance,
        verificationBadge,
        responseRate,
        followersCount,
      ];
}
