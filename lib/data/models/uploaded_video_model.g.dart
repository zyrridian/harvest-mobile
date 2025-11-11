// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoUploadInitiatedModel _$VideoUploadInitiatedModelFromJson(
        Map<String, dynamic> json) =>
    VideoUploadInitiatedModel(
      uploadId: json['upload_id'] as String,
      status: json['status'] as String,
      progressUrl: json['progress_url'] as String,
    );

Map<String, dynamic> _$VideoUploadInitiatedModelToJson(
        VideoUploadInitiatedModel instance) =>
    <String, dynamic>{
      'upload_id': instance.uploadId,
      'status': instance.status,
      'progress_url': instance.progressUrl,
    };

UploadedVideoModel _$UploadedVideoModelFromJson(Map<String, dynamic> json) =>
    UploadedVideoModel(
      videoId: json['video_id'] as String,
      url: json['url'] as String,
      hlsUrl: json['hls_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      duration: (json['duration'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      format: json['format'] as String,
      resolution: json['resolution'] as String,
    );

Map<String, dynamic> _$UploadedVideoModelToJson(UploadedVideoModel instance) =>
    <String, dynamic>{
      'video_id': instance.videoId,
      'url': instance.url,
      'hls_url': instance.hlsUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'duration': instance.duration,
      'size': instance.size,
      'format': instance.format,
      'resolution': instance.resolution,
    };

VideoUploadProgressModel _$VideoUploadProgressModelFromJson(
        Map<String, dynamic> json) =>
    VideoUploadProgressModel(
      uploadId: json['upload_id'] as String,
      status: json['status'] as String,
      progress: (json['progress'] as num).toInt(),
      video: json['video'] == null
          ? null
          : UploadedVideoModel.fromJson(json['video'] as Map<String, dynamic>),
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$VideoUploadProgressModelToJson(
        VideoUploadProgressModel instance) =>
    <String, dynamic>{
      'upload_id': instance.uploadId,
      'status': instance.status,
      'progress': instance.progress,
      'video': instance.video,
      'completed_at': instance.completedAt,
    };
