import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sourcing_request.dart';

part 'sourcing_request_model.freezed.dart';
part 'sourcing_request_model.g.dart';

@freezed
class SourcingBuyerModel with _$SourcingBuyerModel {
  const factory SourcingBuyerModel({
    required String id,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _SourcingBuyerModel;

  factory SourcingBuyerModel.fromJson(Map<String, dynamic> json) =>
      _$SourcingBuyerModelFromJson(json);
}

extension SourcingBuyerModelX on SourcingBuyerModel {
  SourcingBuyer toEntity() {
    return SourcingBuyer(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
    );
  }
}

@freezed
class SourcingRequestModel with _$SourcingRequestModel {
  const factory SourcingRequestModel({
    required String id,
    required String title,
    required String description,
    required String status,
    double? budget,
    @JsonKey(name: 'required_by') DateTime? requiredBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'offers_count', defaultValue: 0) required int offersCount,
    SourcingBuyerModel? buyer,
  }) = _SourcingRequestModel;

  factory SourcingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SourcingRequestModelFromJson(json);
}

extension SourcingRequestModelX on SourcingRequestModel {
  SourcingRequest toEntity() {
    return SourcingRequest(
      id: id,
      title: title,
      description: description,
      status: status,
      budget: budget,
      requiredBy: requiredBy,
      createdAt: createdAt,
      offersCount: offersCount,
      buyer: buyer?.toEntity(),
    );
  }
}
