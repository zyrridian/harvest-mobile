import 'package:json_annotation/json_annotation.dart';
import '../../../../domain/entities/drop_point.dart';

part 'drop_point_model.g.dart';

@JsonSerializable(createFactory: false)
class DropPointModel {
  final String id;
  final String name;
  final String description;
  @JsonKey(name: 'what_we_sell')
  final String whatWeSell;
  final double latitude;
  final double longitude;
  final String address;
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final List<String> tags;
  @JsonKey(name: 'operating_hours')
  final String operatingHours;

  DropPointModel({
    required this.id,
    required this.name,
    required this.description,
    required this.whatWeSell,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.imageUrl,
    required this.isActive,
    required this.tags,
    required this.operatingHours,
  });

  factory DropPointModel.fromJson(Map<String, dynamic> json) {
    return DropPointModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      whatWeSell: (json['what_we_sell'] ?? json['whatWeSell']) as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      imageUrl: (json['image_url'] ?? json['imageUrl'] ?? '') as String,
      isActive: (json['is_active'] ?? json['isActive'] ?? false) as bool,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      operatingHours: (json['operating_hours'] ?? json['operatingHours'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => _$DropPointModelToJson(this);

  DropPoint toEntity() {
    return DropPoint(
      id: id,
      name: name,
      description: description,
      whatWeSell: whatWeSell,
      latitude: latitude,
      longitude: longitude,
      address: address,
      imageUrl: imageUrl,
      isActive: isActive,
      tags: tags,
      operatingHours: operatingHours,
    );
  }

  factory DropPointModel.fromEntity(DropPoint entity) {
    return DropPointModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      whatWeSell: entity.whatWeSell,
      latitude: entity.latitude,
      longitude: entity.longitude,
      address: entity.address,
      imageUrl: entity.imageUrl,
      isActive: entity.isActive,
      tags: entity.tags,
      operatingHours: entity.operatingHours,
    );
  }
}
