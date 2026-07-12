import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/dio_provider.dart';
import '../../features/system/data/datasources/remote/utility_remote_datasource.dart';
import '../../features/system/data/repositories/utility_repository_impl.dart';
import '../../domain/repositories/utility_repository.dart';
import '../../domain/usecases/utility/upload_file.dart';
import '../../domain/usecases/utility/generate_share_link.dart';

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
final uploadFileUseCaseProvider = Provider<UploadFile>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return UploadFile(repository);
});

final generateShareLinkUseCaseProvider = Provider<GenerateShareLink>((ref) {
  final repository = ref.watch(utilityRepositoryProvider);
  return GenerateShareLink(repository);
});
