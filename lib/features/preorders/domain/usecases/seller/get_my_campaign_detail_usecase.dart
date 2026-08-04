import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign_detail.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class GetMyCampaignDetailUseCase {
  final PreorderRepository repository;

  GetMyCampaignDetailUseCase(this.repository);

  Future<Either<Failure, FarmerPreorderCampaignDetail>> call(String id) async {
    return await repository.getFarmerCampaignDetail(id);
  }
}
