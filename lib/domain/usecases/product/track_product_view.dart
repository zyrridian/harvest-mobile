import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/product_detail_repository.dart';

class TrackProductView {
  final ProductDetailRepository repository;

  TrackProductView(this.repository);

  Future<Either<Failure, void>> call(String productId) async {
    return await repository.trackProductView(productId);
  }
}
