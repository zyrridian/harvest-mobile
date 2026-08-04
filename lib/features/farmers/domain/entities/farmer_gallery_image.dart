import 'package:equatable/equatable.dart';

class FarmerGalleryImage extends Equatable {
  final String id;
  final String imageUrl;
  final String? caption;
  final DateTime createdAt;

  const FarmerGalleryImage({
    required this.id,
    required this.imageUrl,
    this.caption,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, imageUrl, caption, createdAt];
}
