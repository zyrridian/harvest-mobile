import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class GetMyCampaignsUseCase {
  final PreorderRepository repository;

  GetMyCampaignsUseCase(this.repository);

  Future<Either<Failure, List<PreorderCampaign>>> call() {
    return repository.getMyCampaigns();
  }
}
