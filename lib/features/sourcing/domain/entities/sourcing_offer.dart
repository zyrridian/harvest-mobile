import 'package:equatable/equatable.dart';
import 'sourcing_request.dart';

class SourcingOfferFarmer extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final double rating;
  final bool isVerified;

  const SourcingOfferFarmer({
    required this.id,
    required this.name,
    this.profileImage,
    required this.rating,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [id, name, profileImage, rating, isVerified];
}

class SourcingOffer extends Equatable {
  final String id;
  final double price;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final SourcingOfferFarmer? farmer;
  final SourcingRequest? request;

  const SourcingOffer({
    required this.id,
    required this.price,
    this.notes,
    required this.status,
    required this.createdAt,
    this.farmer,
    this.request,
  });

  @override
  List<Object?> get props => [
        id,
        price,
        notes,
        status,
        createdAt,
        farmer,
        request,
      ];
}
