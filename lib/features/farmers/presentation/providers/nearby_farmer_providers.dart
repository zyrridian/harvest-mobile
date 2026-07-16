import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../data/datasources/remote/nearby_farmer_remote_datasource.dart';
import '../../../../data/repositories/nearby_farmer_repository_impl.dart';
import '../../../../domain/repositories/nearby_farmer_repository.dart';
import '../../../../domain/usecases/get_nearby_farmers_usecase.dart';

final nearbyFarmerRemoteDataSourceProvider = Provider<NearbyFarmerRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NearbyFarmerRemoteDataSourceImpl(apiService);
});

final nearbyFarmerRepositoryProvider = Provider<NearbyFarmerRepository>((ref) {
  final remoteDataSource = ref.watch(nearbyFarmerRemoteDataSourceProvider);
  return NearbyFarmerRepositoryImpl(remoteDataSource);
});

final getNearbyFarmersUsecaseProvider = Provider<GetNearbyFarmersUsecase>((ref) {
  final repository = ref.watch(nearbyFarmerRepositoryProvider);
  return GetNearbyFarmersUsecase(repository);
});
