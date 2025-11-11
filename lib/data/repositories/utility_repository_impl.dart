import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/uploaded_image.dart';
import '../../domain/entities/uploaded_video.dart';
import '../../domain/entities/share_content.dart';
import '../../domain/repositories/utility_repository.dart';
import '../datasources/remote/utility_remote_datasource.dart';

class UtilityRepositoryImpl implements UtilityRepository {
  final UtilityRemoteDataSource remoteDataSource;

  UtilityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UploadedImage>> uploadImage(
    File image,
    String type,
    bool? resize,
    int? quality,
  ) async {
    try {
      final result = await remoteDataSource.uploadImage(
        image,
        type,
        resize,
        quality,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoUploadInitiated>> uploadVideo(
    File video,
    String type,
    bool? generateThumbnail,
  ) async {
    try {
      final result = await remoteDataSource.uploadVideo(
        video,
        type,
        generateThumbnail,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoUploadProgress>> getVideoUploadProgress(
    String uploadId,
  ) async {
    try {
      final result = await remoteDataSource.getVideoUploadProgress(uploadId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShareContent>> share(
    String type,
    String id,
    String? platform,
  ) async {
    try {
      final result = await remoteDataSource.share(type, id, platform);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
