import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/farmer.dart';

part 'farmer_model.g.dart';

@JsonSerializable()
class FarmerModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  final String description;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'cover_image')
  final String? coverImage;
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? state;
  final double rating;
  @JsonKey(name: 'total_reviews')
  final int totalReviews;
  @JsonKey(name: 'total_products')
  final int totalProducts;
  @JsonKey(defaultValue: [])
  final List<String?> specialties;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'has_map_feature')
  final bool hasMapFeature;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? email;
  @JsonKey(name: 'joined_date')
  final String joinedDate;
  @JsonKey(name: 'is_online')
  final bool isOnline;
  final double? distance;
  // Detail only fields
  @JsonKey(name: 'verification_badge')
  final String? verificationBadge;
  @JsonKey(name: 'response_rate')
  final double? responseRate;
  @JsonKey(name: 'followers_count')
  final int? followersCount;

  FarmerModel({
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

  factory FarmerModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerModelToJson(this);

  Farmer toEntity() {
    return Farmer(
      id: id,
      userId: userId,
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
      distance: distance,
      verificationBadge: verificationBadge,
      responseRate: responseRate,
      followersCount: followersCount,
    );
  }

  factory FarmerModel.fromEntity(Farmer entity) {
    return FarmerModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      description: entity.description,
      profileImage: entity.profileImage,
      coverImage: entity.coverImage,
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      rating: entity.rating,
      totalReviews: entity.totalReviews,
      totalProducts: entity.totalProducts,
      specialties: entity.specialties,
      isVerified: entity.isVerified,
      hasMapFeature: entity.hasMapFeature,
      phoneNumber: entity.phoneNumber,
      email: entity.email,
      joinedDate: entity.joinedDate.toIso8601String(),
      isOnline: entity.isOnline,
      distance: entity.distance,
      verificationBadge: entity.verificationBadge,
      responseRate: entity.responseRate,
      followersCount: entity.followersCount,
    );
  }
}
