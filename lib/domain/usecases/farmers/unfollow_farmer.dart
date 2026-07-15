import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmers_controller.dart';
import '../../../core/error/failure.dart';
import '../../repositories/farmer_repository.dart';

final unfollowFarmerUseCaseProvider = Provider<UnfollowFarmerUseCase>((ref) {
  return UnfollowFarmerUseCase(ref.read(farmerRepositoryProvider));
});

class UnfollowFarmerUseCase {
  final FarmerRepository repository;

  UnfollowFarmerUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) async {
    return await repository.unfollowFarmer(id);
  }
}
