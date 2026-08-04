import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmers_controller.dart';
import '../../../../core/error/failure.dart';
import '../repositories/farmer_repository.dart';

final followFarmerUseCaseProvider = Provider<FollowFarmerUseCase>((ref) {
  return FollowFarmerUseCase(ref.read(farmerRepositoryProvider));
});

class FollowFarmerUseCase {
  final FarmerRepository repository;

  FollowFarmerUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.followFarmer(id);
  }
}
