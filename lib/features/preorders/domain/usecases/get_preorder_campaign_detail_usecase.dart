import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class GetPreorderCampaignDetailUseCase {
  final PreorderRepository repository;

  GetPreorderCampaignDetailUseCase(this.repository);

  Future<Either<Failure, PreorderCampaign>> call(String id) async {
    return await repository.getCampaignDetail(id);
  }
}
