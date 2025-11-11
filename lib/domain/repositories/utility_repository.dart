import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/uploaded_image.dart';
import '../entities/uploaded_video.dart';
import '../entities/share_content.dart';

abstract class UtilityRepository {
  Future<Either<Failure, UploadedImage>> uploadImage(
    File image,
    String type,
    bool? resize,
    int? quality,
  );

  Future<Either<Failure, VideoUploadInitiated>> uploadVideo(
    File video,
    String type,
    bool? generateThumbnail,
  );

  Future<Either<Failure, VideoUploadProgress>> getVideoUploadProgress(
    String uploadId,
  );

  Future<Either<Failure, ShareContent>> share(
    String type,
    String id,
    String? platform,
  );
}
