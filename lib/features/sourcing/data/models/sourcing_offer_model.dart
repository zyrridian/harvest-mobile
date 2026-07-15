import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sourcing_offer.dart';

part 'sourcing_offer_model.freezed.dart';
part 'sourcing_offer_model.g.dart';

@freezed
class SourcingOfferFarmerModel with _$SourcingOfferFarmerModel {
  const factory SourcingOfferFarmerModel({
    required String id,
    required String name,
    @JsonKey(name: 'profile_image') String? profileImage,
    required double rating,
    @JsonKey(name: 'is_verified') required bool isVerified,
  }) = _SourcingOfferFarmerModel;

  factory SourcingOfferFarmerModel.fromJson(Map<String, dynamic> json) =>
      _$SourcingOfferFarmerModelFromJson(json);
}

extension SourcingOfferFarmerModelX on SourcingOfferFarmerModel {
  SourcingOfferFarmer toEntity() {
    return SourcingOfferFarmer(
      id: id,
      name: name,
      profileImage: profileImage,
      rating: rating,
      isVerified: isVerified,
    );
  }
}

@freezed
class SourcingOfferModel with _$SourcingOfferModel {
  const factory SourcingOfferModel({
    required String id,
    required double price,
    String? notes,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    SourcingOfferFarmerModel? farmer,
  }) = _SourcingOfferModel;

  factory SourcingOfferModel.fromJson(Map<String, dynamic> json) =>
      _$SourcingOfferModelFromJson(json);
}

extension SourcingOfferModelX on SourcingOfferModel {
  SourcingOffer toEntity() {
    return SourcingOffer(
      id: id,
      price: price,
      notes: notes,
      status: status,
      createdAt: createdAt,
      farmer: farmer?.toEntity(),
    );
  }
}
