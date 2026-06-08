import 'package:equatable/equatable.dart';

class Home extends Equatable {
  final List<HomeCategories> categories;
  final List<HomePreOrders> preOrders;
  final HomeNearbyFarmers nearbyFarmers;
  final List<HomeFreshToday> freshToday;

  const Home({
    required this.categories,
    required this.preOrders,
    required this.nearbyFarmers,
    required this.freshToday,
  });

  @override
  List<Object?> get props => [
        categories,
        preOrders,
        nearbyFarmers,
        freshToday,
      ];

  Home copyWith({
    List<HomeCategories>? categories,
    List<HomePreOrders>? preOrders,
    HomeNearbyFarmers? nearbyFarmers,
    List<HomeFreshToday>? freshToday,
  }) {
    return Home(
      categories: categories ?? this.categories,
      preOrders: preOrders ?? this.preOrders,
      nearbyFarmers: nearbyFarmers ?? this.nearbyFarmers,
      freshToday: freshToday ?? this.freshToday,
    );
  }
}

class HomeCategories extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String emoji;
  final List<String> gradientColors;
  final int productCount;

  const HomeCategories({
    required this.id,
    required this.name,
    required this.slug,
    required this.emoji,
    required this.gradientColors,
    required this.productCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        emoji,
        gradientColors,
        productCount,
      ];

  HomeCategories copyWith({
    String? id,
    String? name,
    String? slug,
    String? emoji,
    List<String>? gradientColor,
    int? productCount,
  }) {
    return HomeCategories(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      emoji: emoji ?? this.emoji,
      gradientColors: gradientColor ?? this.gradientColors,
      productCount: productCount ?? this.productCount,
    );
  }
}

// TODO: UPDATE THIS CLASS TO MATCH API RESPONSE
class HomePreOrders extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;
  final double price;
  final double discountPrice;
  final String farmerName;
  final DateTime availableDate;

  const HomePreOrders({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discountPrice,
    required this.farmerName,
    required this.availableDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        price,
        discountPrice,
        farmerName,
        availableDate,
      ];

  HomePreOrders copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    double? discountPrice,
    String? farmerName,
    DateTime? availableDate,
  }) {
    return HomePreOrders(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      farmerName: farmerName ?? this.farmerName,
      availableDate: availableDate ?? this.availableDate,
    );
  }
}

class HomeNearbyFarmers extends Equatable {
  final int count;
  final int radiusKm;
  final List<HomeFarmer> farmers;

  const HomeNearbyFarmers({
    required this.count,
    required this.radiusKm,
    required this.farmers,
  });

  @override
  List<Object?> get props => [
        count,
        radiusKm,
        farmers,
      ];

  HomeNearbyFarmers copyWith({
    int? count,
    int? radiusKm,
    List<HomeFarmer>? farmers,
  }) {
    return HomeNearbyFarmers(
      count: count ?? this.count,
      radiusKm: radiusKm ?? this.radiusKm,
      farmers: farmers ?? this.farmers,
    );
  }
}

class HomeFarmer extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final double? latitude;
  final double? longitude;
  final String? address;
  final double? rating;
  final int? totalProducts;
  final bool? isVerified;
  final double? distanceKm;

  const HomeFarmer({
    required this.id,
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

  @override
  List<Object?> get props => [
        id,
        name,
        profileImage,
        latitude,
        longitude,
        address,
        rating,
        totalProducts,
        isVerified,
        distanceKm,
      ];

  HomeFarmer copyWith({
    String? id,
    String? name,
    String? profileImage,
    double? latitude,
    double? longitude,
    String? address,
    double? rating,
    int? totalProducts,
    bool? isVerified,
    double? distanceKm,
  }) {
    return HomeFarmer(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      totalProducts: totalProducts ?? this.totalProducts,
      isVerified: isVerified ?? this.isVerified,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}

class HomeFreshToday extends Equatable {
  final String id;
  final String name;
  final String slug;
  final double price;
  final String currency;
  final String unit;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final bool isOrganic;
  final String? image;
  final HomeFreshTodayFarmer farmer;

  const HomeFreshToday({
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

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        price,
        currency,
        unit,
        stockQuantity,
        rating,
        reviewCount,
        isOrganic,
        image,
        farmer,
      ];

  HomeFreshToday copyWith({
    String? id,
    String? name,
    String? slug,
    double? price,
    String? currency,
    String? unit,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    bool? isOrganic,
    String? image,
    HomeFreshTodayFarmer? farmer,
  }) {
    return HomeFreshToday(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOrganic: isOrganic ?? this.isOrganic,
      image: image ?? this.image,
      farmer: farmer ?? this.farmer,
    );
  }
}

class HomeFreshTodayFarmer extends Equatable {
  final String name;
  final String? profileImage;
  final bool isVerified;

  const HomeFreshTodayFarmer({
    required this.name,
    required this.profileImage,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [
        name,
        profileImage,
        isVerified,
      ];

  HomeFreshTodayFarmer copyWith({
    String? name,
    String? profileImage,
    bool? isVerified,
  }) {
    return HomeFreshTodayFarmer(
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
