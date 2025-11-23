import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repositories/messaging_repository.dart';

class GetConversations {
  final MessagingRepository repository;

  GetConversations(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    String filter = 'all',
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    return await repository.getConversations(
      filter: filter,
      search: search,
      page: page,
      limit: limit,
    );
  }
}
