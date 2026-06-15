import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'preorder_state.dart';

part 'preorder_controller.g.dart';

@riverpod
class PreOrderController extends _$PreOrderController {
  @override
  PreOrderState build() {
    _fetchData();
    return const PreOrderState.loading();
  }

  Future<void> _fetchData() async {
    state = const PreOrderState.loading();
    await Future.delayed(const Duration(milliseconds: 800));

    // Dummy Data based on the design
    final availableHarvests = [
      PreOrderHarvest(
        id: 'h1',
        title: 'Strawberry Ganitri — Batch #4',
        farmerName: 'Sunrise Organic',
        distance: '0.7 km',
        imageUrl: '🍓',
        price: 28000,
        unit: 'kg',
        bookedQuantity: 87,
        totalQuantity: 100,
        daysLeft: 8,
        status: 'Almost full',
      ),
      PreOrderHarvest(
        id: 'h2',
        title: 'Ikan Salmon Trout Whole F...',
        farmerName: 'Fish Factory',
        distance: '2.6 km',
        imageUrl: '🐠',
        price: 1140000,
        unit: 'kg',
        bookedQuantity: 0,
        totalQuantity: 40,
        daysLeft: 156,
        status: 'Open',
      ),
    ];

    final activeReservations = [
      PreOrderReservation(
        id: 'r1',
        title: 'Tomat Cherry Merah',
        quantityStr: '5 kg',
        farmerName: 'Green Valley Farm',
        daysToHarvest: 12,
        imageUrl: '🍅',
        status: 'Confirmed',
      ),
      PreOrderReservation(
        id: 'r2',
        title: 'Beras Pandan Wangi',
        quantityStr: '10 kg',
        farmerName: 'Fresh Fields Co.',
        daysToHarvest: 45,
        imageUrl: '🌾',
        status: 'Pending',
      ),
    ];

    state = PreOrderState.data(PreOrderData(
      activeHarvests: 12,
      yourReservations: 3,
      avgSavings: '30%',
      availableHarvests: availableHarvests,
      activeReservations: activeReservations,
    ));
  }
}
