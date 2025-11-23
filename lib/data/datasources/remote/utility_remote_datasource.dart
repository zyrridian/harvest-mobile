import 'dart:io';
import '../../models/uploaded_image_model.dart';
import '../../models/uploaded_video_model.dart';
import '../../models/share_content_model.dart';

abstract class UtilityRemoteDataSource {
  Future<UploadedImageModel> uploadImage(
    File image,
    String type, // profile, product, farm, review, message, etc.
    bool? resize,
    int? quality,
  );
  Future<VideoUploadInitiatedModel> uploadVideo(
    File video,
    String type, // product, tutorial, farm, etc.
    bool? generateThumbnail,
  );
  Future<VideoUploadProgressModel> getVideoUploadProgress(String uploadId);
  Future<ShareContentModel> share(
    String type, // product, seller, article, post, etc.
    String id, // prd_123
    String? platform, // optional: whatsapp, facebook, twitter, instagram
  );
}

class UtilityRemoteDataSourceImpl implements UtilityRemoteDataSource {
  @override
  Future<UploadedImageModel> uploadImage(
    File image,
    String type,
    bool? resize,
    int? quality,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock success response
    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "Image uploaded successfully",
      "data": {
        "image_id": "img_1234567890",
        "url": "https://cdn.farmmarket.com/images/img_1234567890.jpg",
        "thumbnail_url":
            "https://cdn.farmmarket.com/images/thumb_img_1234567890.jpg",
        "medium_url":
            "https://cdn.farmmarket.com/images/medium_img_1234567890.jpg",
        "size": 245678, // bytes
        "width": 1920,
        "height": 1080,
        "format": "jpg",
        "uploaded_at": "2025-10-09T23:00:00Z"
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return UploadedImageModel.fromJson(data);
  }

  @override
  Future<VideoUploadInitiatedModel> uploadVideo(
    File video,
    String type, // product, tutorial, farm, etc.
    bool? generateThumbnail,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock success response
    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "message": "Video upload initiated",
      "data": {
        "upload_id": "upl_1234567890",
        "status": "processing",
        "progress_url": "/upload/video/upl_1234567890/progress"
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return VideoUploadInitiatedModel.fromJson(data);
  }

  @override
  Future<VideoUploadProgressModel> getVideoUploadProgress(
      String uploadId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock success response
    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "upload_id": uploadId,
        "status": "completed", // uploading, processing, completed, failed
        "progress": 100,
        "video": {
          "video_id": "vid_1234567890",
          "url": "https://cdn.farmmarket.com/videos/vid_1234567890.mp4",
          "hls_url":
              "https://cdn.farmmarket.com/videos/vid_1234567890/master.m3u8",
          "thumbnail_url":
              "https://cdn.farmmarket.com/videos/thumb_vid_1234567890.jpg",
          "duration": 120,
          "size": 15678900,
          "format": "mp4",
          "resolution": "1080p"
        },
        "completed_at": "2025-10-09T23:10:00Z"
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return VideoUploadProgressModel.fromJson(data);
  }

  @override
  Future<ShareContentModel> share(
    String type, // product, seller, article, post, etc.
    String id, // prd_123
    String? platform, // optional: whatsapp, facebook, twitter, instagram
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock success response
    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "share_url": "https://farmmarket.com/$type/$id",
        "short_url": "https://fmkt.co/abc123",
        "deep_link": "farmmarket://$type/$id",
        "share_text": "Check out this amazing $type on FarmMarket!",
        "platform_specific": {
          "whatsapp":
              "https://wa.me/?text=Check%20out%20this%20$type%20https://fmkt.co/abc123",
          "facebook":
              "https://www.facebook.com/sharer/sharer.php?u=https://fmkt.co/abc123",
          "twitter":
              "https://twitter.com/intent/tweet?url=https://fmkt.co/abc123&text=Check%20out%20this%20$type",
          "instagram": "Copy link to share on Instagram Stories"
        },
        "qr_code": "https://cdn.farmmarket.com/qr/abc123.png",
        "generated_at": DateTime.now().toIso8601String()
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return ShareContentModel.fromJson(data);
  }
}
