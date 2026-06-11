import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/farmer.dart';

part 'farmer_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FarmerModel {
  final String id;
  @JsonKey(name: 'farmer_id')
  final String farmerId;
  final InnerFarmerModel farmer;
  final String name;
  final String description;
  @JsonKey(name: 'what_we_sell')
  final String whatWeSell;
  final double latitude;
  final double longitude;
  final String address;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final double? distance;

  FarmerModel({
    required this.id,
    required this.farmerId,
    required this.farmer,
    required this.name,
    required this.description,
    required this.whatWeSell,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.distance,
  });

  factory FarmerModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerModelToJson(this);

  Farmer toEntity() {
    return Farmer(
      id: id,
      farmerId: farmerId,
      farmerProfile: farmer.toEntity(),
      name: name,
      description: description,
      whatWeSell: whatWeSell,
      latitude: latitude,
      longitude: longitude,
      address: address,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: DateTime.parse(createdAt),
      distance: distance ?? 0.0,
    );
  }

  factory FarmerModel.fromEntity(Farmer farmerEntity) {
    return FarmerModel(
      id: farmerEntity.id,
      farmerId: farmerEntity.farmerId,
      farmer: InnerFarmerModel.fromEntity(farmerEntity.farmerProfile),
      name: farmerEntity.name,
      description: farmerEntity.description,
      whatWeSell: farmerEntity.whatWeSell,
      latitude: farmerEntity.latitude,
      longitude: farmerEntity.longitude,
      address: farmerEntity.address,
      imageUrl: farmerEntity.imageUrl,
      isActive: farmerEntity.isActive,
      createdAt: farmerEntity.createdAt.toIso8601String(),
      distance: farmerEntity.distance,
    );
  }
}

@JsonSerializable()
class InnerFarmerModel {
  final String id;
  final String name;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  final double rating;
  final String city;

  InnerFarmerModel({
    required this.id,
    required this.name,
    this.profileImage,
    required this.isVerified,
    required this.rating,
    required this.city,
  });

  factory InnerFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$InnerFarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$InnerFarmerModelToJson(this);

  FarmerProfile toEntity() {
    return FarmerProfile(
      id: id,
      name: name,
      profileImage: profileImage,
      isVerified: isVerified,
      rating: rating,
      city: city,
    );
  }

  factory InnerFarmerModel.fromEntity(FarmerProfile profile) {
    return InnerFarmerModel(
      id: profile.id,
      name: profile.name,
      profileImage: profile.profileImage,
      isVerified: profile.isVerified,
      rating: profile.rating,
      city: profile.city,
    );
  }
}
