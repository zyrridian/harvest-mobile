import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../domain/entities/uploaded_file.dart';
import '../../../../domain/repositories/utility_repository.dart';

class UploadFileUseCase {
  final UtilityRepository repository;

  UploadFileUseCase(this.repository);

  Future<Either<Failure, UploadedFile>> call(File file) async {
    return await repository.uploadFile(file);
  }
}
