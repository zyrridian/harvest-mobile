import 'package:equatable/equatable.dart';

class DropPoint extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? whatWeSell;
  final double latitude;
  final double longitude;
  final String? address;
  final String? imageUrl;
  final bool isActive;
  final List<String> tags;
  final String? operatingHours;

  const DropPoint({
    required this.id,
    required this.name,
    this.description,
    this.whatWeSell,
    required this.latitude,
    required this.longitude,
    this.address,
    this.imageUrl,
    required this.isActive,
    required this.tags,
    this.operatingHours,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        whatWeSell,
        latitude,
        longitude,
        address,
        imageUrl,
        isActive,
        tags,
        operatingHours,
      ];
}
