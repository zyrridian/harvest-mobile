import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/delivery_settings.dart';
import 'package:harvest_app/domain/repositories/producer_repository.dart';

class UpdateDeliverySettingsUseCase {
  final ProducerRepository repository;

  UpdateDeliverySettingsUseCase(this.repository);

  Future<Either<Failure, DeliverySettings>> call(DeliverySettings settings) async {
    return await repository.updateDeliverySettings(settings);
  }
}
