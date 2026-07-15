import 'package:equatable/equatable.dart';

class SourcingBuyer extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;

  const SourcingBuyer({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}

class SourcingRequest extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status;
  final double? budget;
  final DateTime? requiredBy;
  final DateTime createdAt;
  final int offersCount;
  final SourcingBuyer? buyer;

  const SourcingRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.budget,
    this.requiredBy,
    required this.createdAt,
    this.offersCount = 0,
    this.buyer,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        budget,
        requiredBy,
        createdAt,
        offersCount,
        buyer,
      ];
}
