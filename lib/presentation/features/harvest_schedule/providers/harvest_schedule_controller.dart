import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'harvest_schedule_state.dart';

part 'harvest_schedule_controller.g.dart';

@riverpod
class HarvestScheduleController extends _$HarvestScheduleController {
  @override
  HarvestScheduleState build() {
    _fetchData();
    return const HarvestScheduleState.loading();
  }

  Future<void> _fetchData() async {
    state = const HarvestScheduleState.loading();
    await Future.delayed(const Duration(milliseconds: 800));

    final items = [
      HarvestScheduleItem(
        id: '1',
        title: 'Tomat Cherry Merah',
        farmerName: 'Green Valley Farm',
        distance: 1.7,
        imageUrl: '🍅',
        statusText: 'Now',
        price: 56000,
        badges: ['Ready to pick', 'Pre-ordered'],
        descriptionText: '5 kg reserved · paid Rp 14.000 deposit',
        actionButton1: 'Chat\nfarmer',
        actionButton2: 'Arrange\npickup',
        dateGroup: 'TODAY — JUN 13',
        isToday: true,
      ),
      HarvestScheduleItem(
        id: '2',
        title: 'Beras Pandan Wangi',
        farmerName: 'Fresh Fields Co.',
        distance: 2.6,
        imageUrl: '🌾',
        statusText: '3',
        price: 120000,
        badges: ['Pending confirmation'],
        descriptionText: '10 kg reserved · deposit pending',
        actionButton1: 'View\ndetails',
        actionButton2: 'Pay\ndeposit',
        dateGroup: 'MON, JUN 16',
      ),
      HarvestScheduleItem(
        id: '3',
        title: 'Strawberry Ganitri Batch #4',
        farmerName: 'Sunrise Organic',
        distance: 0.7,
        imageUrl: '🍓',
        statusText: '3',
        price: 84000,
        badges: ['Confirmed', 'Pre-ordered'],
        descriptionText: '3 kg reserved',
        actionButton1: '',
        actionButton2: '',
        dateGroup: 'MON, JUN 16',
      ),
      HarvestScheduleItem(
        id: '4',
        title: 'Ikan Salmon Trout Whole F.',
        farmerName: 'Fish Factory',
        distance: 2.6,
        imageUrl: '🐠',
        statusText: '15',
        price: 2280000,
        badges: ['Just reserved'],
        descriptionText: '2 kg reserved',
        actionButton1: '',
        actionButton2: '',
        dateGroup: 'SAT, JUN 28',
      ),
    ];

    state = HarvestScheduleState.data(HarvestScheduleData(
      thisWeekCount: 3,
      readyTodayCount: 1,
      thisMonthCount: 12,
      items: items,
    ));
  }
}
