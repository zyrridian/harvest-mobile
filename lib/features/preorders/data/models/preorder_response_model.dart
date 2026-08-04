import 'package:harvest_app/features/preorders/data/models/preorder_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preorder_response_model.g.dart';

@JsonSerializable()
class PreOrderApiResponse {
  final String status;
  final PreOrderModel? data;
  final String? message;

  PreOrderApiResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory PreOrderApiResponse.fromJson(Map<String, dynamic> json) =>
      _$PreOrderApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PreOrderApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}
