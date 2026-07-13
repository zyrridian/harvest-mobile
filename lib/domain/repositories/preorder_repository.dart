import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/domain/entities/create_preorder_campaign_params.dart';

abstract class PreOrderRepository {
  // Future<Either<Failure, PreOrderResponseEntity>> getPreOrderData({
  //   String? status,
  // });

  Future<Either<Failure, Map<String, dynamic>>> reservePreOrder({
    required String harvestId,
    required int quantity,
  });

  Future<Either<Failure, PreorderCampaign>> createCampaign(CreatePreorderCampaignParams params);
  Future<Either<Failure, List<PreorderCampaign>>> getActiveCampaigns();
  Future<Either<Failure, List<PreorderCampaign>>> getMyCampaigns();
  Future<Either<Failure, Map<String, dynamic>>> reserveSpot(String id, int quantity, String deliveryMethod, String? addressId);
  Future<Either<Failure, Map<String, dynamic>>> payDeposit(String id, String paymentMethod);
  Future<Either<Failure, Map<String, dynamic>>> arrangePickup(String id, DateTime pickupTime);
  Future<Either<Failure, Map<String, dynamic>>> cancelReservation(String id);
}
