import 'package:equatable/equatable.dart';

class UploadedFile extends Equatable {
  final String url;
  final String filename;
  final int size;
  final String contentType;

  const UploadedFile({
    required this.url,
    required this.filename,
    required this.size,
    required this.contentType,
  });

  @override
  List<Object?> get props => [url, filename, size, contentType];
}
