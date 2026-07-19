import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign.dart';

part 'farmer_campaigns_state.freezed.dart';

@freezed
class FarmerCampaignsState with _$FarmerCampaignsState {
  const factory FarmerCampaignsState.initial() = FarmerCampaignsInitial;
  const factory FarmerCampaignsState.loading() = FarmerCampaignsLoading;
  const factory FarmerCampaignsState.data(List<FarmerPreorderCampaign> data) = FarmerCampaignsData;
  const factory FarmerCampaignsState.error(String message) = FarmerCampaignsError;
}
