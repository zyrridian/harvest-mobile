import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/uploaded_file.dart';
import '../repositories/utility_repository.dart';

class UploadFileUseCase {
  final UtilityRepository repository;

  UploadFileUseCase(this.repository);

  Future<Either<Failure, UploadedFile>> call(File file) async {
    return await repository.uploadFile(file);
  }

  Future<Either<Failure, UploadedFile>> uploadBytes(List<int> bytes, String filename) async {
    return await repository.uploadBytes(bytes, filename);
  }
}
