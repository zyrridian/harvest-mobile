import 'package:harvest_app/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/domain/usecases/preorder/get_my_campaigns_usecase.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'farmer_campaigns_controller.g.dart';

final getMyCampaignsUseCaseProvider = Provider<GetMyCampaignsUseCase>((ref) {
  return GetMyCampaignsUseCase(ref.watch(preOrderRepositoryProvider));
});

@riverpod
class FarmerCampaignsController extends _$FarmerCampaignsController {
  @override
  AsyncValue<List<PreorderCampaign>> build() {
    _fetchCampaigns();
    return const AsyncValue.loading();
  }

  Future<void> _fetchCampaigns({bool showLoading = true}) async {
    if (showLoading) {
      state = const AsyncValue.loading();
    }
    try {
      final usecase = ref.read(getMyCampaignsUseCaseProvider);
      final result = await usecase.call();
      result.fold(
        (failure) {
          state = AsyncValue.error(failure.message, StackTrace.current);
        },
        (campaigns) {
          state = AsyncValue.data(campaigns);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<void> refresh() async {
    await _fetchCampaigns(showLoading: false);
  }
}
