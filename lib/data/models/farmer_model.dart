import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/farmer.dart';

part 'farmer_model.g.dart';

@JsonSerializable()
class FarmerModel {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'profile_image')
  final String profileImage;
  @JsonKey(name: 'cover_image')
  final String coverImage;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String state;
  final double rating;
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @JsonKey(name: 'total_products')
  final int totalProducts;
  final List<String> specialties;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'has_map_feature')
  final bool hasMapFeature;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String email;
  @JsonKey(name: 'joined_date')
  final String joinedDate;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  final double? distance;

  FarmerModel({
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
    this.distance,
  });

  factory FarmerModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerModelToJson(this);

  Farmer toEntity() {
    return Farmer(
      id: id,
      name: name,
      description: description,
      profileImage: profileImage,
      coverImage: coverImage,
      latitude: latitude,
      longitude: longitude,
      address: address,
      city: city,
      state: state,
      rating: rating,
      totalReviews: totalReviews,
      totalProducts: totalProducts,
      specialties: specialties,
      isVerified: isVerified,
      hasMapFeature: hasMapFeature,
      phoneNumber: phoneNumber,
      email: email,
      joinedDate: DateTime.parse(joinedDate),
      isOnline: isOnline,
      distance: distance ?? 0.0,
    );
  }

  factory FarmerModel.fromEntity(Farmer farmer) {
    return FarmerModel(
      id: farmer.id,
      name: farmer.name,
      description: farmer.description,
      profileImage: farmer.profileImage,
      coverImage: farmer.coverImage,
      latitude: farmer.latitude,
      longitude: farmer.longitude,
      address: farmer.address,
      city: farmer.city,
      state: farmer.state,
      rating: farmer.rating,
      totalReviews: farmer.totalReviews,
      totalProducts: farmer.totalProducts,
      specialties: farmer.specialties,
      isVerified: farmer.isVerified,
      hasMapFeature: farmer.hasMapFeature,
      phoneNumber: farmer.phoneNumber,
      email: farmer.email,
      joinedDate: farmer.joinedDate.toIso8601String(),
      isOnline: farmer.isOnline,
      distance: farmer.distance,
    );
  }
}
