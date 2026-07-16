import 'package:harvest_app/features/farmers/domain/entities/farmer_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'farmer_profile_model.g.dart';

@JsonSerializable()
class FarmerProfileResponseModel {
  final String status;
  final FarmerProfileModel data;

  FarmerProfileResponseModel({required this.status, required this.data});

  factory FarmerProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerProfileResponseModelToJson(this);
}

@JsonSerializable()
class FarmerProfileModel {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'cover_image')
  final String? coverImage;
  final String address;
  final String? city;
  final String? state;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final List<String> specialties;
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  FarmerProfileModel({
    required this.id,
    required this.name,
    required this.description,
    this.profileImage,
    this.coverImage,
    required this.address,
    this.city,
    this.state,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    required this.specialties,
    required this.isVerified,
  });

  factory FarmerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$FarmerProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$FarmerProfileModelToJson(this);

  FarmerProfile toEntity() {
    return FarmerProfile(
      id: id,
      name: name,
      description: description,
      profileImage: profileImage,
      coverImage: coverImage,
      address: address,
      city: city,
      state: state,
      latitude: latitude,
      longitude: longitude,
      phoneNumber: phoneNumber,
      specialties: specialties,
      isVerified: isVerified,
    );
  }
}
