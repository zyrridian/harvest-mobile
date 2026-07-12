import 'package:harvest_app/domain/entities/farm_profile_request.dart';

class FarmProfileRequestModel extends FarmProfileRequest {
  const FarmProfileRequestModel({
    required super.name,
    super.description,
    super.profileImage,
    super.coverImage,
    super.address,
    super.city,
    super.state,
    super.latitude,
    super.longitude,
    super.phoneNumber,
    super.specialties,
  });

  factory FarmProfileRequestModel.fromEntity(FarmProfileRequest entity) {
    return FarmProfileRequestModel(
      name: entity.name,
      description: entity.description,
      profileImage: entity.profileImage,
      coverImage: entity.coverImage,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      latitude: entity.latitude,
      longitude: entity.longitude,
      phoneNumber: entity.phoneNumber,
      specialties: entity.specialties,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (profileImage != null) 'profile_image': profileImage,
      if (coverImage != null) 'cover_image': coverImage,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (specialties != null) 'specialties': specialties,
    };
  }
}
