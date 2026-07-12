import 'package:equatable/equatable.dart';

class FarmProfileRequest extends Equatable {
  final String name;
  final String? description;
  final String? profileImage;
  final String? coverImage;
  final String? address;
  final String? city;
  final String? state;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final List<String>? specialties;

  const FarmProfileRequest({
    required this.name,
    this.description,
    this.profileImage,
    this.coverImage,
    this.address,
    this.city,
    this.state,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.specialties,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        profileImage,
        coverImage,
        address,
        city,
        state,
        latitude,
        longitude,
        phoneNumber,
        specialties,
      ];
}
