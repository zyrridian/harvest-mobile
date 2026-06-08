import 'package:equatable/equatable.dart';

enum FarmerStatus { active, onVacation, seasonal }

class Farmer extends Equatable {
  final String id;
  final String name;
  final String description;
  final String profileImage;
  final String coverImage;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final double rating;
  final int totalReviews;
  final int totalProducts;
  final List<String> specialties;
  final bool isVerified;
  final bool hasMapFeature;
  final String phoneNumber;
  final String email;
  final DateTime joinedDate;
  final bool isOnline;
  final double distance; // Distance from user in km

  // --- Pre-order & Harvest Schedule Fields ---
  final bool acceptsPreOrders;
  final int upcomingHarvestCount; // Number of upcoming harvests
  final DateTime? nextHarvestDate; // Nearest upcoming harvest
  final List<String>? upcomingProducts; // Products in upcoming harvests
  final FarmerStatus status;

  // --- Subscription & Radius Fields ---
  final bool isSubscribedByUser; // User subscribed to this farmer
  final int subscriberCount;
  final double?
      notifyRadius; // Radius (km) within which users get notifications
  final bool
      isWithinUserRadius; // Whether farmer is within user's preferred radius

  // --- Operating Schedule ---
  final List<String>? operatingDays; // Days farmer operates
  final String? operatingHours;
  final bool isCurrentlyOperating;

  // --- Perishable Product Stats ---
  final int perishableProductCount;
  final int regularProductCount;
  final double avgDeliveryTime; // Average delivery time in hours

  const Farmer({
    required this.id,
    required this.name,
    required this.description,
    required this.profileImage,
    required this.coverImage,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.state,
    required this.rating,
    required this.totalReviews,
    required this.totalProducts,
    required this.specialties,
    required this.isVerified,
    required this.hasMapFeature,
    required this.phoneNumber,
    required this.email,
    required this.joinedDate,
    required this.isOnline,
    this.distance = 0.0,
    // Pre-order & Harvest
    this.acceptsPreOrders = false,
    this.upcomingHarvestCount = 0,
    this.nextHarvestDate,
    this.upcomingProducts,
    this.status = FarmerStatus.active,
    // Subscription & Radius
    this.isSubscribedByUser = false,
    this.subscriberCount = 0,
    this.notifyRadius,
    this.isWithinUserRadius = false,
    // Operating Schedule
    this.operatingDays,
    this.operatingHours,
    this.isCurrentlyOperating = false,
    // Product Stats
    this.perishableProductCount = 0,
    this.regularProductCount = 0,
    this.avgDeliveryTime = 0.0,
  });

  /// Check if farmer has upcoming harvests this week
  bool get hasUpcomingHarvestsThisWeek {
    if (nextHarvestDate == null) return false;
    return nextHarvestDate!.difference(DateTime.now()).inDays <= 7;
  }

  /// Days until next harvest
  int? get daysUntilNextHarvest {
    if (nextHarvestDate == null) return null;
    return nextHarvestDate!.difference(DateTime.now()).inDays;
  }

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
        acceptsPreOrders,
        upcomingHarvestCount,
        nextHarvestDate,
        upcomingProducts,
        status,
        isSubscribedByUser,
        subscriberCount,
        notifyRadius,
        isWithinUserRadius,
        operatingDays,
        operatingHours,
        isCurrentlyOperating,
        perishableProductCount,
        regularProductCount,
        avgDeliveryTime,
      ];
}
