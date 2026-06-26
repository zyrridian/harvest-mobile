import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/domain/repositories/preorder_repository.dart';

class GetActiveCampaignsUseCase {
  final PreOrderRepository repository;

  GetActiveCampaignsUseCase(this.repository);

  Future<Either<Failure, List<PreorderCampaign>>> call() {
    return repository.getActiveCampaigns();
  }
}
