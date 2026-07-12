import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:harvest_app/core/providers/db_provider.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/system/data/datasources/local/master_local_datasource.dart';
import 'package:harvest_app/features/system/data/datasources/remote/master_remote_datasource.dart';
import 'package:harvest_app/features/system/data/repositories/master_repository_impl.dart';
import 'package:harvest_app/features/system/domain/repositories/master_repository.dart';
import 'package:harvest_app/features/system/domain/entities/master.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'master_provider.g.dart';

@riverpod
MasterRepository masterRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: false));

  return MasterRepositoryImpl(
    remoteDataSource: MasterRemoteDataSourceImpl(dio),
    localDataSource: MasterLocalDataSourceImpl(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    ),
  );
}

@riverpod
Future<List<Province>> provinces(Ref ref) async {
  final repo = ref.watch(masterRepositoryProvider);
  final result = await repo.getProvinces();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
}

@riverpod
Future<List<City>> cities(Ref ref, int provinceId) async {
  final repo = ref.watch(masterRepositoryProvider);
  final result = await repo.getCities(provinceId: provinceId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
}

@riverpod
Future<List<District>> districts(Ref ref, int cityId) async {
  final repo = ref.watch(masterRepositoryProvider);
  final result = await repo.getDistricts(cityId: cityId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
}
