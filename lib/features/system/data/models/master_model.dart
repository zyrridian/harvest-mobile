import 'package:json_annotation/json_annotation.dart';
import 'package:harvest_app/features/system/domain/entities/master.dart';

part 'master_model.g.dart';

@JsonSerializable()
class ProvinceModel {
  final int id;
  final String name;

  ProvinceModel({
    required this.id,
    required this.name,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) =>
      _$ProvinceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProvinceModelToJson(this);

  Province toEntity() {
    return Province(id: id, name: name);
  }

  factory ProvinceModel.fromEntity(Province province) {
    return ProvinceModel(id: province.id, name: province.name);
  }
}

@JsonSerializable()
class CityModel {
  final int id;
  @JsonKey(name: 'province_id')
  final int provinceId;
  final String name;

  CityModel({
    required this.id,
    required this.provinceId,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);

  City toEntity() {
    return City(id: id, provinceId: provinceId, name: name);
  }

  factory CityModel.fromEntity(City city) {
    return CityModel(
      id: city.id,
      provinceId: city.provinceId,
      name: city.name,
    );
  }
}

@JsonSerializable()
class DistrictModel {
  final int id;
  @JsonKey(name: 'city_id')
  final int cityId;
  final String name;

  DistrictModel({
    required this.id,
    required this.cityId,
    required this.name,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) =>
      _$DistrictModelFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictModelToJson(this);

  District toEntity() {
    return District(id: id, cityId: cityId, name: name);
  }

  factory DistrictModel.fromEntity(District district) {
    return DistrictModel(
      id: district.id,
      cityId: district.cityId,
      name: district.name,
    );
  }
}
