import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/home.dart';
import 'package:harvest_app/features/storefront/domain/repositories/home_repository.dart';

class GetHomeUseCase {
  final HomeRepository repository;

  GetHomeUseCase(this.repository);

  Future<Either<Failure, Home>> call() async {
    return await repository.getHomeData();
  }
}
