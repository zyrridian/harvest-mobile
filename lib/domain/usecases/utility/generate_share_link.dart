import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/share_content.dart';
import '../../repositories/utility_repository.dart';

class GenerateShareLink {
  final UtilityRepository repository;

  GenerateShareLink(this.repository);

  Future<Either<Failure, ShareContent>> call({
    required String type,
    required String id,
    String? platform,
  }) async {
    return await repository.share(type, id, platform);
  }
}
