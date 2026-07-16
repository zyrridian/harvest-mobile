import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class DeletePreorderCampaignUseCase {
  final PreorderRepository repository;

  DeletePreorderCampaignUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteCampaign(id);
  }
}
