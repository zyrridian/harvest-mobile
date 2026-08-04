import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/explore.dart';

part 'explore_model.freezed.dart';
part 'explore_model.g.dart';

@freezed
class ExploreModel with _$ExploreModel {
  const ExploreModel._();

  const factory ExploreModel({
    @JsonKey(name: 'live_streams') @Default([]) List<ExploreLiveStreamModel> liveStreams,
    @JsonKey(name: 'in_season') @Default([]) List<ExploreInSeasonModel> inSeason,
    @JsonKey(name: 'group_buys') @Default([]) List<ExploreGroupBuyModel> groupBuys,
    @JsonKey(name: 'nearby_farmers') @Default([]) List<ExploreNearbyFarmerModel> nearbyFarmers,
    @JsonKey(name: 'active_preorders') @Default([]) List<ExplorePreOrderModel> activePreorders,
    @Default([]) List<ExploreExperienceModel> experiences,
  }) = _ExploreModel;

  factory ExploreModel.fromJson(Map<String, dynamic> json) =>
      _$ExploreModelFromJson(json);

  Explore toEntity() {
    return Explore(
      liveStreams: liveStreams.map((e) => e.toEntity()).toList(),
      inSeason: inSeason.map((e) => e.toEntity()).toList(),
      groupBuys: groupBuys.map((e) => e.toEntity()).toList(),
      nearbyFarmers: nearbyFarmers.map((e) => e.toEntity()).toList(),
      activePreorders: activePreorders.map((e) => e.toEntity()).toList(),
      experiences: experiences.map((e) => e.toEntity()).toList(),
    );
  }
}

@freezed
class ExploreLiveStreamModel with _$ExploreLiveStreamModel {
  const ExploreLiveStreamModel._();

  const factory ExploreLiveStreamModel({
    required String id,
    @JsonKey(name: 'farmer_name') required String farmerName,
    required String title,
    required String thumbnail,
    required int viewers,
    @JsonKey(name: 'stream_url') required String streamUrl,
  }) = _ExploreLiveStreamModel;

  factory ExploreLiveStreamModel.fromJson(Map<String, dynamic> json) =>
      _$ExploreLiveStreamModelFromJson(json);

  ExploreLiveStream toEntity() {
    return ExploreLiveStream(
      id: id,
      farmerName: farmerName,
      title: title,
      thumbnail: thumbnail,
      viewers: viewers,
      streamUrl: streamUrl,
    );
  }
}

@freezed
class ExploreInSeasonModel with _$ExploreInSeasonModel {
  const ExploreInSeasonModel._();

  const factory ExploreInSeasonModel({
    required String id,
    required String title,
    required String image,
    @JsonKey(name: 'farms_count') required int farmsCount,
  }) = _ExploreInSeasonModel;

  factory ExploreInSeasonModel.fromJson(Map<String, dynamic> json) =>
      _$ExploreInSeasonModelFromJson(json);

  ExploreInSeason toEntity() {
    return ExploreInSeason(
      id: id,
      title: title,
      image: image,
      farmsCount: farmsCount,
    );
  }
}

@freezed
class ExploreGroupBuyModel with _$ExploreGroupBuyModel {
  const ExploreGroupBuyModel._();

  const factory ExploreGroupBuyModel({
    required String id,
    required String title,
    @JsonKey(name: 'farm_name') required String farmName,
    required double price,
    @JsonKey(name: 'original_price') required double originalPrice,
    required String image,
    @JsonKey(name: 'joined_count') required int joinedCount,
    @JsonKey(name: 'target_count') required int targetCount,
  }) = _ExploreGroupBuyModel;

  factory ExploreGroupBuyModel.fromJson(Map<String, dynamic> json) =>
      _$ExploreGroupBuyModelFromJson(json);

  ExploreGroupBuy toEntity() {
    return ExploreGroupBuy(
      id: id,
      title: title,
      farmName: farmName,
      price: price,
      originalPrice: originalPrice,
      image: image,
      joinedCount: joinedCount,
      targetCount: targetCount,
    );
  }
}

@freezed
class ExploreNearbyFarmerModel with _$ExploreNearbyFarmerModel {
  const ExploreNearbyFarmerModel._();

  const factory ExploreNearbyFarmerModel({
    required String id,
    required String name,
    @JsonKey(name: 'cover_image') required String coverImage,
    required double rating,
    @JsonKey(name: 'distance_km') required double distanceKm,
    @Default([]) List<String> specialties,
  }) = _ExploreNearbyFarmerModel;

  factory ExploreNearbyFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$ExploreNearbyFarmerModelFromJson(json);

  ExploreNearbyFarmer toEntity() {
    return ExploreNearbyFarmer(
      id: id,
      name: name,
      coverImage: coverImage,
      rating: rating,
      distanceKm: distanceKm,
      specialties: specialties,
    );
  }
}

@freezed
class ExplorePreOrderModel with _$ExplorePreOrderModel {
  const ExplorePreOrderModel._();

  const factory ExplorePreOrderModel({
    required String id,
    required String title,
    @JsonKey(name: 'farmer_name') required String farmerName,
    required String image,
    @JsonKey(name: 'progress_percentage') required double progressPercentage,
    @JsonKey(name: 'days_left') required int daysLeft,
  }) = _ExplorePreOrderModel;

  factory ExplorePreOrderModel.fromJson(Map<String, dynamic> json) =>
      _$ExplorePreOrderModelFromJson(json);

  ExplorePreOrder toEntity() {
    return ExplorePreOrder(
      id: id,
      title: title,
      farmerName: farmerName,
      image: image,
      progressPercentage: progressPercentage,
      daysLeft: daysLeft,
    );
  }
}

@freezed
class ExploreExperienceModel with _$ExploreExperienceModel {
  const ExploreExperienceModel._();

  const factory ExploreExperienceModel({
    required String id,
    required String title,
    required String location,
    @JsonKey(name: 'date_string') required String dateString,
    required double price,
    required String image,
  }) = _ExploreExperienceModel;

  factory ExploreExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$ExploreExperienceModelFromJson(json);

  ExploreExperience toEntity() {
    return ExploreExperience(
      id: id,
      title: title,
      location: location,
      dateString: dateString,
      price: price,
      image: image,
    );
  }
}
