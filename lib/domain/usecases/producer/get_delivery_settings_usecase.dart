import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/delivery_settings.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class GetDeliverySettingsUseCase {
  final ProducerRepository repository;

  GetDeliverySettingsUseCase(this.repository);

  Future<Either<Failure, DeliverySettings>> call() async {
    return await repository.getDeliverySettings();
  }
}
