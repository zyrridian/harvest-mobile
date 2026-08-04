import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign_detail.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/features/preorders/domain/entities/create_preorder_campaign_params.dart';

abstract class PreorderRepository {
  Future<Either<Failure, List<PreorderCampaign>>> getActiveCampaigns(
      {String? filter, double? latitude, double? longitude});

  Future<Either<Failure, PreorderCampaign>> getCampaignDetail(String id);

  Future<Either<Failure, Map<String, dynamic>>> reservePreOrder({
    required String harvestId,
    required int quantity,
  });

  Future<Either<Failure, PreorderCampaign>> createCampaign(
      CreatePreorderCampaignParams params);
  Future<Either<Failure, PreorderCampaign>> updateCampaign(
      String id, CreatePreorderCampaignParams params);
  Future<Either<Failure, PreorderCampaign>> updateCampaignStatus(
      String id, String status);
  Future<Either<Failure, void>> deleteCampaign(String id);
  Future<Either<Failure, List<PreOrderReservation>>> getMyReservations();
  Future<Either<Failure, Map<String, dynamic>>> reserveSpot(
      String id, int quantity, String deliveryMethod, String? addressId);
  Future<Either<Failure, Map<String, dynamic>>> arrangePickup(
      String id, DateTime pickupTime);
  Future<Either<Failure, Map<String, dynamic>>> cancelReservation(String id);
  Future<Either<Failure, Map<String, dynamic>>> completeReservation(String id);
  Future<Either<Failure, Map<String, dynamic>>> fulfillCampaign(String id);

  /// Farmer
  Future<Either<Failure, List<FarmerPreorderCampaign>>> getMyCampaigns();
  Future<Either<Failure, FarmerPreorderCampaignDetail>> getFarmerCampaignDetail(
      String id);
}
