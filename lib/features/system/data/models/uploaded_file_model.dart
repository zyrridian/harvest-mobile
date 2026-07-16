import '../../domain/entities/uploaded_file.dart';

class UploadedFileModel extends UploadedFile {
  const UploadedFileModel({
    required super.url,
    required super.filename,
    required super.size,
    required super.contentType,
  });

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) {
    return UploadedFileModel(
      url: json['url'] as String,
      filename: json['filename'] as String,
      size: json['size'] as int,
      contentType: json['contentType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'filename': filename,
      'size': size,
      'contentType': contentType,
    };
  }

  UploadedFile toEntity() {
    return UploadedFile(
      url: url,
      filename: filename,
      size: size,
      contentType: contentType,
    );
  }
}
