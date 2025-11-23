import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/uploaded_video.dart';
import '../../repositories/utility_repository.dart';

class UploadVideo {
  final UtilityRepository repository;

  UploadVideo(this.repository);

  Future<Either<Failure, VideoUploadInitiated>> call({
    required File video,
    required String type,
    bool? generateThumbnail,
  }) async {
    return await repository.uploadVideo(video, type, generateThumbnail);
  }
}
