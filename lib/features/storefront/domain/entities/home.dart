import 'package:equatable/equatable.dart';

class Home extends Equatable {
  final HomeActiveOrder? activeOrder;
  final List<HomeFarmerUpdate> farmerUpdates;
  final List<HomeWeeklyStaple> weeklyStaples;

  const Home({
    this.activeOrder,
    required this.farmerUpdates,
    required this.weeklyStaples,
  });

  @override
  List<Object?> get props => [
        activeOrder,
        farmerUpdates,
        weeklyStaples,
      ];

  Home copyWith({
    HomeActiveOrder? activeOrder,
    List<HomeFarmerUpdate>? farmerUpdates,
    List<HomeWeeklyStaple>? weeklyStaples,
  }) {
    return Home(
      activeOrder: activeOrder ?? this.activeOrder,
      farmerUpdates: farmerUpdates ?? this.farmerUpdates,
      weeklyStaples: weeklyStaples ?? this.weeklyStaples,
    );
  }
}

class HomeActiveOrder extends Equatable {
  final String id;
  final String status;
  final String productName;
  final String farmerName;

  const HomeActiveOrder({
    required this.id,
    required this.status,
    required this.productName,
    required this.farmerName,
  });

  @override
  List<Object?> get props => [id, status, productName, farmerName];

  HomeActiveOrder copyWith({
    String? id,
    String? status,
    String? productName,
    String? farmerName,
  }) {
    return HomeActiveOrder(
      id: id ?? this.id,
      status: status ?? this.status,
      productName: productName ?? this.productName,
      farmerName: farmerName ?? this.farmerName,
    );
  }
}

class HomeFarmerUpdate extends Equatable {
  final String id;
  final String farmerName;
  final String farmerAvatar;
  final String content;
  final String timeAgo;

  const HomeFarmerUpdate({
    required this.id,
    required this.farmerName,
    required this.farmerAvatar,
    required this.content,
    required this.timeAgo,
  });

  @override
  List<Object?> get props => [id, farmerName, farmerAvatar, content, timeAgo];

  HomeFarmerUpdate copyWith({
    String? id,
    String? farmerName,
    String? farmerAvatar,
    String? content,
    String? timeAgo,
  }) {
    return HomeFarmerUpdate(
      id: id ?? this.id,
      farmerName: farmerName ?? this.farmerName,
      farmerAvatar: farmerAvatar ?? this.farmerAvatar,
      content: content ?? this.content,
      timeAgo: timeAgo ?? this.timeAgo,
    );
  }
}

class HomeWeeklyStaple extends Equatable {
  final String id;
  final String name;
  final String quantityLabel;
  final double price;
  final String currency;
  final String image;

  const HomeWeeklyStaple({
    required this.id,
    required this.name,
    required this.quantityLabel,
    required this.price,
    required this.currency,
    required this.image,
  });

  @override
  List<Object?> get props => [id, name, quantityLabel, price, currency, image];

  HomeWeeklyStaple copyWith({
    String? id,
    String? name,
    String? quantityLabel,
    double? price,
    String? currency,
    String? image,
  }) {
    return HomeWeeklyStaple(
      id: id ?? this.id,
      name: name ?? this.name,
      quantityLabel: quantityLabel ?? this.quantityLabel,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      image: image ?? this.image,
    );
  }
}
