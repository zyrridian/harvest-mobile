import 'package:equatable/equatable.dart';

class FarmerProfile extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? profileImage;
  final String? coverImage;
  final String address;
  final String? city;
  final String? state;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final List<String> specialties;
  final bool isVerified;

  const FarmerProfile({
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

  @override
  List<Object?> get props => [
        id,
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
        isVerified,
      ];
}
