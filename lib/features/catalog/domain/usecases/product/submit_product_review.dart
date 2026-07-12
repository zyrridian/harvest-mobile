import 'package:dartz/dartz.dart';
import 'package:harvest_app/core/error/failure.dart';
import 'package:harvest_app/features/catalog/domain/repositories/product_repository.dart';

class SubmitProductReview {
  final ProductRepository repository;

  SubmitProductReview(this.repository);

  Future<Either<Failure, void>> call({
    required String productId,
    required String content,
    required int rating,
    List<String> images = const [],
  }) async {
    return await repository.submitProductReview(
      productId: productId,
      content: content,
      rating: rating,
      images: images,
    );
  }
}
