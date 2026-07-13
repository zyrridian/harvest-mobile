import 'package:harvest_app/data/models/home/home_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_response_model.g.dart';

/// Model for home API response wrapper
@JsonSerializable()
class HomeApiResponse {
  final bool success;
  final HomeModel? data;
  final String? message;

  HomeApiResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory HomeApiResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeApiResponseToJson(this);

  bool get isSuccess => success;
}
