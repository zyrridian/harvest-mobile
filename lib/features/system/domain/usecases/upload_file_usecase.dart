import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<Either<Failure, UploadedFile>> uploadFromPath(String path) async {
    if (kIsWeb) {
      final file = XFile(path);
      final bytes = await file.readAsBytes();
      final filename = file.name.isNotEmpty ? file.name : 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg';
      return await repository.uploadBytes(bytes, filename);
    } else {
      return await repository.uploadFile(File(path));
    }
  }
}
