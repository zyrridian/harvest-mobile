import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/system/domain/entities/master.dart';

abstract class MasterRepository {
  Future<Either<Failure, List<Province>>> getProvinces();
  Future<Either<Failure, List<City>>> getCities({required int provinceId});
  Future<Either<Failure, List<District>>> getDistricts({required int cityId});
}
