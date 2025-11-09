import 'package:equatable/equatable.dart';

enum SubscriptionStatus { active, paused, cancelled }

enum SubscriptionFrequency { weekly, biweekly, monthly }

class Subscription extends Equatable {
  final String subscriptionId;
  final SubscriptionStatus status;
  final SubscriptionSeller seller;
  final List<SubscriptionItem> items;
  final SubscriptionFrequency frequency;
  final String frequencyLabel;
  final String deliveryDay;
  final String deliveryTime;
  final SubscriptionAddress deliveryAddress;
  final SubscriptionPricing pricing;
  final SubscriptionPaymentMethod paymentMethod;
  final NextDelivery nextDelivery;
  final SubscriptionSchedule schedule;
  final PauseOptions pauseOptions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.subscriptionId,
    required this.status,
    required this.seller,
    required this.items,
    required this.frequency,
    required this.frequencyLabel,
    required this.deliveryDay,
    required this.deliveryTime,
    required this.deliveryAddress,
    required this.pricing,
    required this.paymentMethod,
    required this.nextDelivery,
    required this.schedule,
    required this.pauseOptions,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        subscriptionId,
        status,
        seller,
        items,
        frequency,
        frequencyLabel,
        deliveryDay,
        deliveryTime,
        deliveryAddress,
        pricing,
        paymentMethod,
        nextDelivery,
        schedule,
        pauseOptions,
        createdAt,
        updatedAt,
      ];
}

class SubscriptionSeller extends Equatable {
  final String userId;
  final String name;
  final String profilePicture;
  final double rating;

  const SubscriptionSeller({
    required this.userId,
    required this.name,
    required this.profilePicture,
    required this.rating,
  });

  @override
  List<Object?> get props => [userId, name, profilePicture, rating];
}

class SubscriptionItem extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final String unit;
  final int price;
  final String image;

  const SubscriptionItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.image,
  });

  @override
  List<Object?> get props =>
      [productId, productName, quantity, unit, price, image];
}

class SubscriptionAddress extends Equatable {
  final String addressId;
  final String recipientName;
  final String fullAddress;

  const SubscriptionAddress({
    required this.addressId,
    required this.recipientName,
    required this.fullAddress,
  });

  @override
  List<Object?> get props => [addressId, recipientName, fullAddress];
}

class SubscriptionPricing extends Equatable {
  final int subtotal;
  final int deliveryFee;
  final int total;
  final int totalPerMonth;

  const SubscriptionPricing({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.totalPerMonth,
  });

  @override
  List<Object?> get props => [subtotal, deliveryFee, total, totalPerMonth];
}

class SubscriptionPaymentMethod extends Equatable {
  final String method;
  final String label;

  const SubscriptionPaymentMethod({
    required this.method,
    required this.label,
  });

  @override
  List<Object?> get props => [method, label];
}

class NextDelivery extends Equatable {
  final String date;
  final String status;
  final bool canSkip;
  final bool canModify;

  const NextDelivery({
    required this.date,
    required this.status,
    required this.canSkip,
    required this.canModify,
  });

  @override
  List<Object?> get props => [date, status, canSkip, canModify];
}

class SubscriptionSchedule extends Equatable {
  final String startDate;
  final String? endDate;
  final int totalDeliveries;
  final int completedDeliveries;
  final int skippedDeliveries;
  final List<UpcomingDelivery> upcomingDeliveries;

  const SubscriptionSchedule({
    required this.startDate,
    this.endDate,
    required this.totalDeliveries,
    required this.completedDeliveries,
    required this.skippedDeliveries,
    required this.upcomingDeliveries,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        totalDeliveries,
        completedDeliveries,
        skippedDeliveries,
        upcomingDeliveries,
      ];
}

class UpcomingDelivery extends Equatable {
  final String deliveryId;
  final String scheduledDate;
  final String status;

  const UpcomingDelivery({
    required this.deliveryId,
    required this.scheduledDate,
    required this.status,
  });

  @override
  List<Object?> get props => [deliveryId, scheduledDate, status];
}

class PauseOptions extends Equatable {
  final bool canPause;
  final int minPauseDuration;
  final int maxPauseDuration;

  const PauseOptions({
    required this.canPause,
    required this.minPauseDuration,
    required this.maxPauseDuration,
  });

  @override
  List<Object?> get props => [canPause, minPauseDuration, maxPauseDuration];
}

class SubscriptionSummary extends Equatable {
  final int totalActive;
  final int totalPaused;
  final int totalCancelled;
  final int totalMonthlySpending;

  const SubscriptionSummary({
    required this.totalActive,
    required this.totalPaused,
    required this.totalCancelled,
    required this.totalMonthlySpending,
  });

  @override
  List<Object?> get props =>
      [totalActive, totalPaused, totalCancelled, totalMonthlySpending];
}
