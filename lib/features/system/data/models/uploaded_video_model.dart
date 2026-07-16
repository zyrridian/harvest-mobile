import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/uploaded_video.dart';

part 'uploaded_video_model.g.dart';

@JsonSerializable()
class VideoUploadInitiatedModel {
  @JsonKey(name: 'upload_id')
  final String uploadId;
  final String status;
  @JsonKey(name: 'progress_url')
  final String progressUrl;

  const VideoUploadInitiatedModel({
    required this.uploadId,
    required this.status,
    required this.progressUrl,
  });

  factory VideoUploadInitiatedModel.fromJson(Map<String, dynamic> json) =>
      _$VideoUploadInitiatedModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUploadInitiatedModelToJson(this);

  VideoUploadInitiated toEntity() {
    return VideoUploadInitiated(
      uploadId: uploadId,
      status: status,
      progressUrl: progressUrl,
    );
  }
}

@JsonSerializable()
class UploadedVideoModel {
  @JsonKey(name: 'video_id')
  final String videoId;
  final String url;
  @JsonKey(name: 'hls_url')
  final String hlsUrl;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  final int duration;
  final int size;
  final String format;
  final String resolution;

  const UploadedVideoModel({
    required this.videoId,
    required this.url,
    required this.hlsUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.size,
    required this.format,
    required this.resolution,
  });

  factory UploadedVideoModel.fromJson(Map<String, dynamic> json) =>
      _$UploadedVideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedVideoModelToJson(this);

  UploadedVideo toEntity() {
    return UploadedVideo(
      videoId: videoId,
      url: url,
      hlsUrl: hlsUrl,
      thumbnailUrl: thumbnailUrl,
      duration: duration,
      size: size,
      format: format,
      resolution: resolution,
    );
  }
}

@JsonSerializable()
class VideoUploadProgressModel {
  @JsonKey(name: 'upload_id')
  final String uploadId;
  final String status;
  final int progress;
  final UploadedVideoModel? video;
  @JsonKey(name: 'completed_at')
  final String? completedAt;

  const VideoUploadProgressModel({
    required this.uploadId,
    required this.status,
    required this.progress,
    this.video,
    this.completedAt,
  });

  factory VideoUploadProgressModel.fromJson(Map<String, dynamic> json) =>
      _$VideoUploadProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUploadProgressModelToJson(this);

  VideoUploadProgress toEntity() {
    return VideoUploadProgress(
      uploadId: uploadId,
      status: _parseStatus(status),
      progress: progress,
      video: video?.toEntity(),
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
    );
  }

  VideoUploadStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'uploading':
        return VideoUploadStatus.uploading;
      case 'processing':
        return VideoUploadStatus.processing;
      case 'completed':
        return VideoUploadStatus.completed;
      case 'failed':
        return VideoUploadStatus.failed;
      default:
        return VideoUploadStatus.uploading;
    }
  }
}
