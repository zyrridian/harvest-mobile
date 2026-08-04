import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../data/datasources/remote/utility_remote_datasource.dart';
import '../../data/repositories/utility_repository_impl.dart';
import '../../domain/repositories/utility_repository.dart';
import '../../domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/generate_share_link_usecase.dart';

// Data Source Provider
final utilityDataSourceProvider = Provider<UtilityRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return UtilityRemoteDataSourceImpl(dio: dio);
});

// Repository Provider
final utilityRepositoryProvider = Provider<UtilityRepository>((ref) {
  final dataSource = ref.watch(utilityDataSourceProvider);
  return UtilityRepositoryImpl(remoteDataSource: dataSource);
});

// Use Case Providers
final uploadFileUseCaseProvider = Provider<UploadFileUseCase>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return UploadFileUseCase(repository);
});

final generateShareLinkUseCaseProvider =
    Provider<GenerateShareLinkUseCase>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return GenerateShareLinkUseCase(repository);
});
