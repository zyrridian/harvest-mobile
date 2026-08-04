import 'package:equatable/equatable.dart';

class UploadedImage extends Equatable {
  final String imageId;
  final String url;
  final String thumbnailUrl;
  final String mediumUrl;
  final int size;
  final int width;
  final int height;
  final String format;
  final DateTime uploadedAt;

  const UploadedImage({
    required this.imageId,
    required this.url,
    required this.thumbnailUrl,
    required this.mediumUrl,
    required this.size,
    required this.width,
    required this.height,
    required this.format,
    required this.uploadedAt,
  });

  @override
  List<Object?> get props => [
        imageId,
        url,
        thumbnailUrl,
        mediumUrl,
        size,
        width,
        height,
        format,
        uploadedAt,
      ];
}
