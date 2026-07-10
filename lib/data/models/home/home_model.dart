import 'package:harvest_app/domain/entities/home.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeModel {
  @JsonKey(name: 'active_order')
  final HomeActiveOrderModel? activeOrder;
  @JsonKey(name: 'farmer_updates')
  final List<HomeFarmerUpdateModel> farmerUpdates;
  @JsonKey(name: 'weekly_staples')
  final List<HomeWeeklyStapleModel> weeklyStaples;

  HomeModel({
    this.activeOrder,
    required this.farmerUpdates,
    required this.weeklyStaples,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);

  Home toEntity() {
    return Home(
      activeOrder: activeOrder?.toEntity(),
      farmerUpdates: farmerUpdates.map((e) => e.toEntity()).toList(),
      weeklyStaples: weeklyStaples.map((e) => e.toEntity()).toList(),
    );
  }

  factory HomeModel.fromEntity(Home home) {
    return HomeModel(
      activeOrder: home.activeOrder != null
          ? HomeActiveOrderModel.fromEntity(home.activeOrder!)
          : null,
      farmerUpdates: home.farmerUpdates
          .map((e) => HomeFarmerUpdateModel.fromEntity(e))
          .toList(),
      weeklyStaples: home.weeklyStaples
          .map((e) => HomeWeeklyStapleModel.fromEntity(e))
          .toList(),
    );
  }
}

@JsonSerializable()
class HomeActiveOrderModel {
  final String id;
  final String status;
  @JsonKey(name: 'product_name')
  final String productName;
  @JsonKey(name: 'farmer_name')
  final String farmerName;

  HomeActiveOrderModel({
    required this.id,
    required this.status,
    required this.productName,
    required this.farmerName,
  });

  factory HomeActiveOrderModel.fromJson(Map<String, dynamic> json) =>
      _$HomeActiveOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeActiveOrderModelToJson(this);

  HomeActiveOrder toEntity() {
    return HomeActiveOrder(
      id: id,
      status: status,
      productName: productName,
      farmerName: farmerName,
    );
  }

  factory HomeActiveOrderModel.fromEntity(HomeActiveOrder entity) {
    return HomeActiveOrderModel(
      id: entity.id,
      status: entity.status,
      productName: entity.productName,
      farmerName: entity.farmerName,
    );
  }
}

@JsonSerializable()
class HomeFarmerUpdateModel {
  final String id;
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  @JsonKey(name: 'farmer_avatar')
  final String farmerAvatar;
  final String content;
  @JsonKey(name: 'time_ago')
  final String timeAgo;

  HomeFarmerUpdateModel({
    required this.id,
    required this.farmerName,
    required this.farmerAvatar,
    required this.content,
    required this.timeAgo,
  });

  factory HomeFarmerUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$HomeFarmerUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFarmerUpdateModelToJson(this);

  HomeFarmerUpdate toEntity() {
    return HomeFarmerUpdate(
      id: id,
      farmerName: farmerName,
      farmerAvatar: farmerAvatar,
      content: content,
      timeAgo: timeAgo,
    );
  }

  factory HomeFarmerUpdateModel.fromEntity(HomeFarmerUpdate entity) {
    return HomeFarmerUpdateModel(
      id: entity.id,
      farmerName: entity.farmerName,
      farmerAvatar: entity.farmerAvatar,
      content: entity.content,
      timeAgo: entity.timeAgo,
    );
  }
}

@JsonSerializable()
class HomeWeeklyStapleModel {
  final String id;
  final String name;
  @JsonKey(name: 'quantity_label')
  final String quantityLabel;
  final double price;
  final String currency;
  final String image;

  HomeWeeklyStapleModel({
    required this.id,
    required this.name,
    required this.quantityLabel,
    required this.price,
    required this.currency,
    required this.image,
  });

  factory HomeWeeklyStapleModel.fromJson(Map<String, dynamic> json) =>
      _$HomeWeeklyStapleModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeWeeklyStapleModelToJson(this);

  HomeWeeklyStaple toEntity() {
    return HomeWeeklyStaple(
      id: id,
      name: name,
      quantityLabel: quantityLabel,
      price: price,
      currency: currency,
      image: image,
    );
  }

  factory HomeWeeklyStapleModel.fromEntity(HomeWeeklyStaple entity) {
    return HomeWeeklyStapleModel(
      id: entity.id,
      name: entity.name,
      quantityLabel: entity.quantityLabel,
      price: entity.price,
      currency: entity.currency,
      image: entity.image,
    );
  }
}
