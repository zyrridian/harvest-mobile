import 'package:harvest_app/domain/entities/home.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeModel {
  final List<HomeCategoriesModel> categories;
  @JsonKey(name: 'pre_orders')
  final List<HomePreOrdersModel> preOrders;
  @JsonKey(name: 'nearby_farmers')
  final HomeNearbyFarmersModel nearbyFarmers;
  @JsonKey(name: 'fresh_today')
  final List<HomeFreshTodayModel> freshToday;

  HomeModel({
    required this.categories,
    required this.preOrders,
    required this.nearbyFarmers,
    required this.freshToday,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);

  Home toEntity() {
    return Home(
      categories: categories.map((e) => e.toEntity()).toList(),
      preOrders: preOrders.map((e) => e.toEntity()).toList(),
      nearbyFarmers: nearbyFarmers.toEntity(),
      freshToday: freshToday.map((e) => e.toEntity()).toList(),
    );
  }

  factory HomeModel.fromEntity(Home home) {
    return HomeModel(
      categories: home.categories
          .map((e) => HomeCategoriesModel.fromEntity(e))
          .toList(),
      preOrders:
          home.preOrders.map((e) => HomePreOrdersModel.fromEntity(e)).toList(),
      nearbyFarmers: HomeNearbyFarmersModel.fromEntity(home.nearbyFarmers),
      freshToday: home.freshToday
          .map((e) => HomeFreshTodayModel.fromEntity(e))
          .toList(),
    );
  }
}

@JsonSerializable()
class HomeCategoriesModel {
  final String id;
  final String name;
  final String slug;
  final String emoji;
  @JsonKey(name: 'gradient_colors')
  final List<String> gradientColors;
  @JsonKey(name: 'product_count')
  final int productCount;

  HomeCategoriesModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.emoji,
    required this.gradientColors,
    required this.productCount,
  });

  factory HomeCategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCategoriesModelToJson(this);

  HomeCategories toEntity() {
    return HomeCategories(
      id: id,
      name: name,
      slug: slug,
      emoji: emoji,
      gradientColors: gradientColors,
      productCount: productCount,
    );
  }

  factory HomeCategoriesModel.fromEntity(HomeCategories category) {
    return HomeCategoriesModel(
      id: category.id,
      name: category.name,
      slug: category.slug,
      emoji: category.emoji,
      gradientColors: category.gradientColors,
      productCount: category.productCount,
    );
  }
}

@JsonSerializable()
class HomePreOrdersModel {
  final String id;
  final String name;
  final String? slug;
  final double? price;
  final String? currency;
  final String? unit;
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @JsonKey(name: 'harvest_date')
  final DateTime? harvestDate;
  @JsonKey(name: 'target_amount')
  final int? targetAmount;
  @JsonKey(name: 'current_booked')
  final int? currentBooked;
  @JsonKey(name: 'is_harvest')
  final bool? isHarvest;
  @JsonKey(name: 'days_until_harvest')
  final int? daysUntilHarvest;
  @JsonKey(name: 'countdown_label')
  final String? countdownLabel;
  @JsonKey(name: 'is_organic')
  final bool? isOrganic;
  final String? image;
  final HomePreOrdersFarmerModel? farmer;

  HomePreOrdersModel({
    required this.id,
    required this.name,
    this.slug,
    this.price,
    this.currency,
    this.unit,
    this.stockQuantity,
    this.harvestDate,
    this.targetAmount,
    this.currentBooked,
    this.isHarvest,
    this.daysUntilHarvest,
    this.countdownLabel,
    this.isOrganic,
    this.image,
    this.farmer,
  });

  factory HomePreOrdersModel.fromJson(Map<String, dynamic> json) =>
      _$HomePreOrdersModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomePreOrdersModelToJson(this);

  HomePreOrders toEntity() {
    return HomePreOrders(
      id: id,
      name: name,
      slug: slug,
      price: price,
      currency: currency,
      unit: unit,
      stockQuantity: stockQuantity,
      harvestDate: harvestDate,
      targetAmount: targetAmount,
      currentBooked: currentBooked,
      isHarvest: isHarvest,
      daysUntilHarvest: daysUntilHarvest,
      countdownLabel: countdownLabel,
      isOrganic: isOrganic,
      image: image,
      farmer: farmer?.toEntity(),
    );
  }

  factory HomePreOrdersModel.fromEntity(HomePreOrders preOrder) {
    return HomePreOrdersModel(
      id: preOrder.id,
      name: preOrder.name,
      slug: preOrder.slug,
      price: preOrder.price,
      currency: preOrder.currency,
      unit: preOrder.unit,
      stockQuantity: preOrder.stockQuantity,
      harvestDate: preOrder.harvestDate,
      targetAmount: preOrder.targetAmount,
      currentBooked: preOrder.currentBooked,
      isHarvest: preOrder.isHarvest,
      daysUntilHarvest: preOrder.daysUntilHarvest,
      countdownLabel: preOrder.countdownLabel,
      isOrganic: preOrder.isOrganic,
      image: preOrder.image,
      farmer: preOrder.farmer != null
          ? HomePreOrdersFarmerModel.fromEntity(preOrder.farmer!)
          : null,
    );
  }
}

@JsonSerializable()
class HomePreOrdersFarmerModel {
  final String name;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'is_verified')
  final bool? isVerified;

  HomePreOrdersFarmerModel({
    required this.name,
    this.profileImage,
    this.isVerified,
  });

  factory HomePreOrdersFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$HomePreOrdersFarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomePreOrdersFarmerModelToJson(this);

  HomePreOrdersFarmer toEntity() {
    return HomePreOrdersFarmer(
      name: name,
      profileImage: profileImage,
      isVerified: isVerified,
    );
  }

  factory HomePreOrdersFarmerModel.fromEntity(HomePreOrdersFarmer farmer) {
    return HomePreOrdersFarmerModel(
      name: farmer.name,
      profileImage: farmer.profileImage,
      isVerified: farmer.isVerified,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class HomeNearbyFarmersModel {
  final int count;
  @JsonKey(name: 'radius_km')
  final int radiusKm;
  final List<HomeFarmerModel> farmers;

  HomeNearbyFarmersModel({
    required this.count,
    required this.radiusKm,
    required this.farmers,
  });

  factory HomeNearbyFarmersModel.fromJson(Map<String, dynamic> json) =>
      _$HomeNearbyFarmersModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeNearbyFarmersModelToJson(this);

  HomeNearbyFarmers toEntity() {
    return HomeNearbyFarmers(
      count: count,
      radiusKm: radiusKm,
      farmers: farmers.map((e) => e.toEntity()).toList(),
    );
  }

  factory HomeNearbyFarmersModel.fromEntity(HomeNearbyFarmers nearbyFarmers) {
    return HomeNearbyFarmersModel(
      count: nearbyFarmers.count,
      radiusKm: nearbyFarmers.radiusKm,
      farmers: nearbyFarmers.farmers
          .map((e) => HomeFarmerModel.fromEntity(e))
          .toList(),
    );
  }
}

@JsonSerializable()
class HomeFarmerModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  final double? latitude;
  final double? longitude;
  final String? address;
  final double? rating;
  @JsonKey(name: 'total_products')
  final int? totalProducts;
  @JsonKey(name: 'is_verified')
  final bool? isVerified;
  @JsonKey(name: 'distance_km')
  final double? distanceKm;

  HomeFarmerModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.rating,
    required this.totalProducts,
    required this.isVerified,
    required this.distanceKm,
  });

  factory HomeFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$HomeFarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFarmerModelToJson(this);

  HomeFarmer toEntity() {
    return HomeFarmer(
      id: id,
      userId: userId,
      name: name,
      profileImage: profileImage,
      latitude: latitude,
      longitude: longitude,
      address: address,
      rating: rating,
      totalProducts: totalProducts,
      isVerified: isVerified,
      distanceKm: distanceKm,
    );
  }

  factory HomeFarmerModel.fromEntity(HomeFarmer farmer) {
    return HomeFarmerModel(
      id: farmer.id,
      userId: farmer.userId,
      name: farmer.name,
      profileImage: farmer.profileImage,
      latitude: farmer.latitude,
      longitude: farmer.longitude,
      address: farmer.address,
      rating: farmer.rating,
      totalProducts: farmer.totalProducts,
      isVerified: farmer.isVerified,
      distanceKm: farmer.distanceKm,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class HomeFreshTodayModel {
  final String id;
  final String name;
  final String slug;
  final double price;
  final String currency;
  final String unit;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  final double rating;
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @JsonKey(name: 'is_organic')
  final bool isOrganic;
  final String? image;
  final HomeFreshTodayFarmerModel farmer;

  HomeFreshTodayModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.currency,
    required this.unit,
    required this.stockQuantity,
    required this.rating,
    required this.reviewCount,
    required this.isOrganic,
    required this.image,
    required this.farmer,
  });

  factory HomeFreshTodayModel.fromJson(Map<String, dynamic> json) =>
      _$HomeFreshTodayModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFreshTodayModelToJson(this);

  HomeFreshToday toEntity() {
    return HomeFreshToday(
      id: id,
      name: name,
      slug: slug,
      price: price,
      currency: currency,
      unit: unit,
      stockQuantity: stockQuantity,
      rating: rating,
      reviewCount: reviewCount,
      isOrganic: isOrganic,
      image: image,
      farmer: farmer.toEntity(),
    );
  }

  factory HomeFreshTodayModel.fromEntity(HomeFreshToday freshToday) {
    return HomeFreshTodayModel(
      id: freshToday.id,
      name: freshToday.name,
      slug: freshToday.slug,
      price: freshToday.price,
      currency: freshToday.currency,
      unit: freshToday.unit,
      stockQuantity: freshToday.stockQuantity,
      rating: freshToday.rating,
      reviewCount: freshToday.reviewCount,
      isOrganic: freshToday.isOrganic,
      image: freshToday.image,
      farmer: HomeFreshTodayFarmerModel.fromEntity(freshToday.farmer),
    );
  }
}

@JsonSerializable()
class HomeFreshTodayFarmerModel {
  final String name;
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  HomeFreshTodayFarmerModel({
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  factory HomeFreshTodayFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$HomeFreshTodayFarmerModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeFreshTodayFarmerModelToJson(this);

  HomeFreshTodayFarmer toEntity() {
    return HomeFreshTodayFarmer(
      name: name,
      profileImage: profileImage,
      isVerified: isVerified,
    );
  }

  factory HomeFreshTodayFarmerModel.fromEntity(HomeFreshTodayFarmer farmer) {
    return HomeFreshTodayFarmerModel(
      name: farmer.name,
      profileImage: farmer.profileImage,
      isVerified: farmer.isVerified,
    );
  }
}
