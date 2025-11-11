import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/uploaded_image.dart';
import '../../repositories/utility_repository.dart';

class UploadImage {
  final UtilityRepository repository;

  UploadImage(this.repository);

  Future<Either<Failure, UploadedImage>> call({
    required File image,
    required String type,
    bool? resize,
    int? quality,
  }) async {
    return await repository.uploadImage(image, type, resize, quality);
  }
}
