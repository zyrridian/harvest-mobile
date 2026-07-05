import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';

abstract class PreorderRepository {
  /// Fetch preorder data for the dashboard
  Future<Either<Failure, PreOrderResponseEntity>> getPreorderData({
    double? latitude,
    double? longitude,
  });

  Future<Either<Failure, List<PreorderCampaign>>> getActiveCampaigns();

  Future<Either<Failure, Map<String, dynamic>>> reservePreOrder({
    required String harvestId,
    required int quantity,
  });
}
