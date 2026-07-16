// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      activeOrder: json['active_order'] == null
          ? null
          : HomeActiveOrderModel.fromJson(
              json['active_order'] as Map<String, dynamic>),
      farmerUpdates: (json['farmer_updates'] as List<dynamic>?)
              ?.map((e) =>
                  HomeFarmerUpdateModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weeklyStaples: (json['weekly_staples'] as List<dynamic>?)
              ?.map((e) =>
                  HomeWeeklyStapleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'active_order': instance.activeOrder?.toJson(),
      'farmer_updates': instance.farmerUpdates.map((e) => e.toJson()).toList(),
      'weekly_staples': instance.weeklyStaples.map((e) => e.toJson()).toList(),
    };

HomeActiveOrderModel _$HomeActiveOrderModelFromJson(
        Map<String, dynamic> json) =>
    HomeActiveOrderModel(
      id: json['id'] as String,
      status: json['status'] as String,
      productName: json['product_name'] as String,
      farmerName: json['farmer_name'] as String,
    );

Map<String, dynamic> _$HomeActiveOrderModelToJson(
        HomeActiveOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'product_name': instance.productName,
      'farmer_name': instance.farmerName,
    };

HomeFarmerUpdateModel _$HomeFarmerUpdateModelFromJson(
        Map<String, dynamic> json) =>
    HomeFarmerUpdateModel(
      id: json['id'] as String,
      farmerName: json['farmer_name'] as String,
      farmerAvatar: json['farmer_avatar'] as String,
      content: json['content'] as String,
      timeAgo: json['time_ago'] as String,
    );

Map<String, dynamic> _$HomeFarmerUpdateModelToJson(
        HomeFarmerUpdateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'farmer_name': instance.farmerName,
      'farmer_avatar': instance.farmerAvatar,
      'content': instance.content,
      'time_ago': instance.timeAgo,
    };

HomeWeeklyStapleModel _$HomeWeeklyStapleModelFromJson(
        Map<String, dynamic> json) =>
    HomeWeeklyStapleModel(
      id: json['id'] as String,
      name: json['name'] as String,
      quantityLabel: json['quantity_label'] as String,
      price: _priceFromJson(json['price']),
      currency: json['currency'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$HomeWeeklyStapleModelToJson(
        HomeWeeklyStapleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity_label': instance.quantityLabel,
      'price': instance.price,
      'currency': instance.currency,
      'image': instance.image,
    };
