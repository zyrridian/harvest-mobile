import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign_detail.dart';
import 'package:harvest_app/features/preorders/domain/usecases/seller/get_my_campaign_detail_usecase.dart';
import 'package:harvest_app/features/preorders/domain/usecases/seller/get_my_campaigns_usecase.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'farmer_campaigns_state.dart';
part 'farmer_campaigns_controller.g.dart';

final getMyCampaignsUseCaseProvider = Provider<GetMyCampaignsUseCase>((ref) {
  return GetMyCampaignsUseCase(ref.watch(preOrderRepositoryProvider));
});

final getFarmerCampaignDetailUseCaseProvider = Provider<GetMyCampaignDetailUseCase>((ref) {
  return GetMyCampaignDetailUseCase(ref.watch(preOrderRepositoryProvider));
});

final farmerCampaignDetailProvider = FutureProvider.family<FarmerPreorderCampaignDetail, String>((ref, id) async {
  final usecase = ref.read(getFarmerCampaignDetailUseCaseProvider);
  final result = await usecase.call(id);
  return result.fold(
    (failure) => throw failure,
    (detail) => detail,
  );
});

@riverpod
class FarmerCampaignsController extends _$FarmerCampaignsController {
  @override
  FarmerCampaignsState build() {
    _fetchCampaigns();
    return const FarmerCampaignsState.loading();
  }

  Future<void> _fetchCampaigns({bool showLoading = true}) async {
    if (showLoading) {
      state = const FarmerCampaignsState.loading();
    }
    try {
      final usecase = ref.read(getMyCampaignsUseCaseProvider);
      final result = await usecase.call();
      result.fold(
        (failure) {
          state = FarmerCampaignsState.error(failure.message);
        },
        (campaigns) {
          state = FarmerCampaignsState.data(campaigns);
        },
      );
    } catch (e) {
      state = FarmerCampaignsState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await _fetchCampaigns(showLoading: false);
  }
}
