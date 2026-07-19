import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class GetMyCampaignsUseCase {
  final PreorderRepository repository;

  GetMyCampaignsUseCase(this.repository);

  Future<Either<Failure, List<FarmerPreorderCampaign>>> call() {
    return repository.getMyCampaigns();
  }
}
