import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/utility_remote_datasource.dart';
import '../../data/repositories/utility_repository_impl.dart';
import '../../domain/repositories/utility_repository.dart';
import '../../domain/entities/uploaded_video.dart';
import '../../domain/usecases/utility/upload_image.dart';
import '../../domain/usecases/utility/upload_video.dart';
import '../../domain/usecases/utility/get_video_upload_progress.dart';
import '../../domain/usecases/utility/generate_share_link.dart';

// Data Source Provider
final utilityDataSourceProvider = Provider<UtilityRemoteDataSource>((ref) {
  return UtilityRemoteDataSourceImpl();
});

// Repository Provider
final utilityRepositoryProvider = Provider<UtilityRepository>((ref) {
  final dataSource = ref.watch(utilityDataSourceProvider);
  return UtilityRepositoryImpl(remoteDataSource: dataSource);
});

// Use Case Providers
final uploadImageUseCaseProvider = Provider<UploadImage>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return UploadImage(repository);
});

final uploadVideoUseCaseProvider = Provider<UploadVideo>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return UploadVideo(repository);
});

final getVideoUploadProgressUseCaseProvider =
    Provider<GetVideoUploadProgress>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return GetVideoUploadProgress(repository);
});

final generateShareLinkUseCaseProvider = Provider<GenerateShareLink>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return GenerateShareLink(repository);
});

// Video Upload Progress Provider (family for polling)
final videoUploadProgressProvider =
    FutureProvider.family<VideoUploadProgress, String>((ref, uploadId) async {
  final useCase = ref.watch(getVideoUploadProgressUseCaseProvider);
  final result = await useCase(uploadId);
  return result.fold(
    (failure) => throw Exception(failure.toString()),
    (progress) => progress,
  );
});
