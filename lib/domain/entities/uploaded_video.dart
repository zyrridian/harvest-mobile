import 'package:equatable/equatable.dart';

enum VideoUploadStatus { uploading, processing, completed, failed }

class VideoUploadProgress extends Equatable {
  final String uploadId;
  final VideoUploadStatus status;
  final int progress;
  final UploadedVideo? video;
  final DateTime? completedAt;

  const VideoUploadProgress({
    required this.uploadId,
    required this.status,
    required this.progress,
    this.video,
    this.completedAt,
  });

  @override
  List<Object?> get props => [uploadId, status, progress, video, completedAt];
}

class UploadedVideo extends Equatable {
  final String videoId;
  final String url;
  final String hlsUrl;
  final String thumbnailUrl;
  final int duration;
  final int size;
  final String format;
  final String resolution;

  const UploadedVideo({
    required this.videoId,
    required this.url,
    required this.hlsUrl,
    required this.thumbnailUrl,
    required this.duration,
    required this.size,
    required this.format,
    required this.resolution,
  });

  @override
  List<Object?> get props => [
        videoId,
        url,
        hlsUrl,
        thumbnailUrl,
        duration,
        size,
        format,
        resolution,
      ];
}

class VideoUploadInitiated extends Equatable {
  final String uploadId;
  final String status;
  final String progressUrl;

  const VideoUploadInitiated({
    required this.uploadId,
    required this.status,
    required this.progressUrl,
  });

  @override
  List<Object?> get props => [uploadId, status, progressUrl];
}
