import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/domain/entities/preorder.dart';

abstract class PreOrderRepository {
  Future<Either<Failure, PreOrderResponseEntity>> getPreOrderData({
    String? status,
  });

  Future<Either<Failure, Map<String, dynamic>>> reservePreOrder({
    required String harvestId,
    required int quantity,
  });
}
