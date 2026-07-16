import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:harvest_app/features/storefront/domain/entities/home.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = HomeInitial;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.data(Home data) = HomeData;
  const factory HomeState.error(String message) = HomeError;
}
