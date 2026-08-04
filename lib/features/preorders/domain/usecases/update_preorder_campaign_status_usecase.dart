import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class UpdatePreorderCampaignStatusUseCase {
  final PreorderRepository repository;

  UpdatePreorderCampaignStatusUseCase(this.repository);

  Future<Either<Failure, PreorderCampaign>> call(String id, String status) {
    return repository.updateCampaignStatus(id, status);
  }
}
