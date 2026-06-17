import 'package:harvest_app/data/models/marketplace/marketplace_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marketplace_response_model.g.dart';

@JsonSerializable()
class MarketplaceApiResponse {
  final String status;
  final MarketplaceModel? data;
  final String? message;

  MarketplaceApiResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory MarketplaceApiResponse.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}
