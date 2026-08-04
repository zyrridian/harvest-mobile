// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExploreModelImpl _$$ExploreModelImplFromJson(Map<String, dynamic> json) =>
    _$ExploreModelImpl(
      liveStreams: (json['live_streams'] as List<dynamic>?)
              ?.map((e) =>
                  ExploreLiveStreamModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      inSeason: (json['in_season'] as List<dynamic>?)
              ?.map((e) =>
                  ExploreInSeasonModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      groupBuys: (json['group_buys'] as List<dynamic>?)
              ?.map((e) =>
                  ExploreGroupBuyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nearbyFarmers: (json['nearby_farmers'] as List<dynamic>?)
              ?.map((e) =>
                  ExploreNearbyFarmerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activePreorders: (json['active_preorders'] as List<dynamic>?)
              ?.map((e) =>
                  ExplorePreOrderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) =>
                  ExploreExperienceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExploreModelImplToJson(_$ExploreModelImpl instance) =>
    <String, dynamic>{
      'live_streams': instance.liveStreams,
      'in_season': instance.inSeason,
      'group_buys': instance.groupBuys,
      'nearby_farmers': instance.nearbyFarmers,
      'active_preorders': instance.activePreorders,
      'experiences': instance.experiences,
    };

_$ExploreLiveStreamModelImpl _$$ExploreLiveStreamModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExploreLiveStreamModelImpl(
      id: json['id'] as String,
      farmerName: json['farmer_name'] as String,
      title: json['title'] as String,
      thumbnail: json['thumbnail'] as String,
      viewers: (json['viewers'] as num).toInt(),
      streamUrl: json['stream_url'] as String,
    );

Map<String, dynamic> _$$ExploreLiveStreamModelImplToJson(
        _$ExploreLiveStreamModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmer_name': instance.farmerName,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'viewers': instance.viewers,
      'stream_url': instance.streamUrl,
    };

_$ExploreInSeasonModelImpl _$$ExploreInSeasonModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExploreInSeasonModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      farmsCount: (json['farms_count'] as num).toInt(),
    );

Map<String, dynamic> _$$ExploreInSeasonModelImplToJson(
        _$ExploreInSeasonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'farms_count': instance.farmsCount,
    };

_$ExploreGroupBuyModelImpl _$$ExploreGroupBuyModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExploreGroupBuyModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      farmName: json['farm_name'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num).toDouble(),
      image: json['image'] as String,
      joinedCount: (json['joined_count'] as num).toInt(),
      targetCount: (json['target_count'] as num).toInt(),
    );

Map<String, dynamic> _$$ExploreGroupBuyModelImplToJson(
        _$ExploreGroupBuyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'farm_name': instance.farmName,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'image': instance.image,
      'joined_count': instance.joinedCount,
      'target_count': instance.targetCount,
    };

_$ExploreNearbyFarmerModelImpl _$$ExploreNearbyFarmerModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExploreNearbyFarmerModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      coverImage: json['cover_image'] as String,
      rating: (json['rating'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ExploreNearbyFarmerModelImplToJson(
        _$ExploreNearbyFarmerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cover_image': instance.coverImage,
      'rating': instance.rating,
      'distance_km': instance.distanceKm,
      'specialties': instance.specialties,
    };

_$ExplorePreOrderModelImpl _$$ExplorePreOrderModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExplorePreOrderModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      farmerName: json['farmer_name'] as String,
      image: json['image'] as String,
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      daysLeft: (json['days_left'] as num).toInt(),
    );

Map<String, dynamic> _$$ExplorePreOrderModelImplToJson(
        _$ExplorePreOrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'farmer_name': instance.farmerName,
      'image': instance.image,
      'progress_percentage': instance.progressPercentage,
      'days_left': instance.daysLeft,
    };

_$ExploreExperienceModelImpl _$$ExploreExperienceModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ExploreExperienceModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      dateString: json['date_string'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );

Map<String, dynamic> _$$ExploreExperienceModelImplToJson(
        _$ExploreExperienceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'date_string': instance.dateString,
      'price': instance.price,
      'image': instance.image,
    };
