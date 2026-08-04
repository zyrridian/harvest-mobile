import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/uploaded_file.dart';
import '../entities/share_content.dart';

abstract class UtilityRepository {
  Future<Either<Failure, UploadedFile>> uploadFile(File file);

  Future<Either<Failure, ShareContent>> share(
    String type,
    String id,
    String? platform,
  );
}
