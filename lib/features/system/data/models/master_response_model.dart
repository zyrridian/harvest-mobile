import 'package:json_annotation/json_annotation.dart';
import 'package:harvest_app/features/system/data/models/master_model.dart';

part 'master_response_model.g.dart';

@JsonSerializable()
class ProvincesApiResponse {
  final String status;
  final List<ProvinceModel>? data;
  final String? message;

  ProvincesApiResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory ProvincesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ProvincesApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProvincesApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}

@JsonSerializable()
class CitiesApiResponse {
  final String status;
  final List<CityModel>? data;
  final String? message;

  CitiesApiResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory CitiesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$CitiesApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CitiesApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}

@JsonSerializable()
class DistrictsApiResponse {
  final String status;
  final List<DistrictModel>? data;
  final String? message;

  DistrictsApiResponse({
    required this.status,
    this.data,
    this.message,
  });

  factory DistrictsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$DistrictsApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictsApiResponseToJson(this);

  bool get isSuccess => status == 'success';
}
