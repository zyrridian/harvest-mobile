import 'package:equatable/equatable.dart';

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
  });

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
      ];
}
