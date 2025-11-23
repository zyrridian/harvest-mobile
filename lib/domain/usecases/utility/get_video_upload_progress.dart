import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/uploaded_video.dart';
import '../../repositories/utility_repository.dart';

class GetVideoUploadProgress {
  final UtilityRepository repository;

  GetVideoUploadProgress(this.repository);

  Future<Either<Failure, VideoUploadProgress>> call(String uploadId) async {
    return await repository.getVideoUploadProgress(uploadId);
  }
}
