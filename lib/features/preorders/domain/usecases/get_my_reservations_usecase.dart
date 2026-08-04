import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder.dart';
import 'package:harvest_app/features/preorders/domain/repositories/preorder_repository.dart';

class GetMyReservationsUseCase {
  final PreorderRepository repository;

  GetMyReservationsUseCase(this.repository);

  Future<Either<Failure, List<PreOrderReservation>>> call() async {
    return await repository.getMyReservations();
  }
}
