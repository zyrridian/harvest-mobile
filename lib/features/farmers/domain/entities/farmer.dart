import 'package:equatable/equatable.dart';
import 'farmer_gallery_image.dart';

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
  final List<String?> specialties;
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
  final bool isFollowed;
  final List<FarmerGalleryImage> gallery;

  // Compatibility getters for the UI to reduce some breakage
  String get whatWeSell {
    if (specialties.isEmpty) return '';
    if (specialties.length == 1) return specialties.first ?? '';
    return '${specialties.first ?? ''} +${specialties.length - 1}';
  }

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
    this.isFollowed = false,
    this.gallery = const [],
  });

  Farmer copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? profileImage,
    String? coverImage,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? state,
    double? rating,
    int? totalReviews,
    int? totalProducts,
    List<String?>? specialties,
    bool? isVerified,
    bool? hasMapFeature,
    String? phoneNumber,
    String? email,
    DateTime? joinedDate,
    bool? isOnline,
    double? distance,
    String? verificationBadge,
    double? responseRate,
    int? followersCount,
    bool? isFollowed,
    List<FarmerGalleryImage>? gallery,
  }) {
    return Farmer(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalProducts: totalProducts ?? this.totalProducts,
      specialties: specialties ?? this.specialties,
      isVerified: isVerified ?? this.isVerified,
      hasMapFeature: hasMapFeature ?? this.hasMapFeature,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      joinedDate: joinedDate ?? this.joinedDate,
      isOnline: isOnline ?? this.isOnline,
      distance: distance ?? this.distance,
      verificationBadge: verificationBadge ?? this.verificationBadge,
      responseRate: responseRate ?? this.responseRate,
      followersCount: followersCount ?? this.followersCount,
      isFollowed: isFollowed ?? this.isFollowed,
      gallery: gallery ?? this.gallery,
    );
  }

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
        isFollowed,
        gallery,
      ];
}
