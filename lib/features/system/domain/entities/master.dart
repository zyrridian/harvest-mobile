import 'package:equatable/equatable.dart';

class Province extends Equatable {
  final int id;
  final String name;

  const Province({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class City extends Equatable {
  final int id;
  final int provinceId;
  final String name;

  const City({
    required this.id,
    required this.provinceId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, provinceId, name];
}

class District extends Equatable {
  final int id;
  final int cityId;
  final String name;

  const District({
    required this.id,
    required this.cityId,
    required this.name,
  });

  @override
  List<Object?> get props => [id, cityId, name];
}
