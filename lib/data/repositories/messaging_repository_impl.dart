import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../datasources/remote/messaging_remote_datasource.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  final MessagingRemoteDataSource remoteDataSource;

  MessagingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getConversations({
    String filter = 'all',
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getConversations(
        filter: filter,
        search: search,
        page: page,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationDetail>> getConversationDetail({
    required String conversationId,
    int page = 1,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    try {
      final result = await remoteDataSource.getConversationDetail(
        conversationId: conversationId,
        page: page,
        limit: limit,
        beforeMessageId: beforeMessageId,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> startConversation({
    required String recipientId,
    required String type,
    String? orderId,
    String? productId,
    String? initialMessage,
  }) async {
    try {
      final result = await remoteDataSource.startConversation(
        recipientId: recipientId,
        type: type,
        orderId: orderId,
        productId: productId,
        initialMessage: initialMessage,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String type,
    String? content,
    List<String>? imagePaths,
    String? productId,
    String? orderId,
    String? voicePath,
    String? replyToMessageId,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        conversationId: conversationId,
        type: type,
        content: content,
        imagePaths: imagePaths,
        productId: productId,
        orderId: orderId,
        voicePath: voicePath,
        replyToMessageId: replyToMessageId,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> editMessage({
    required String messageId,
    required String content,
  }) async {
    try {
      final result = await remoteDataSource.editMessage(
        messageId: messageId,
        content: content,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage({
    required String messageId,
    String deleteFor = 'me',
  }) async {
    try {
      final result = await remoteDataSource.deleteMessage(
        messageId: messageId,
        deleteFor: deleteFor,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markMessageAsRead({
    required String messageId,
  }) async {
    try {
      final result = await remoteDataSource.markMessageAsRead(
        messageId: messageId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead({
    required String conversationId,
  }) async {
    try {
      final result = await remoteDataSource.markConversationAsRead(
        conversationId: conversationId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addReaction({
    required String messageId,
    required String emoji,
  }) async {
    try {
      final result = await remoteDataSource.addReaction(
        messageId: messageId,
        emoji: emoji,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> removeReaction({
    required String messageId,
  }) async {
    try {
      final result = await remoteDataSource.removeReaction(
        messageId: messageId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    try {
      final result = await remoteDataSource.sendTypingIndicator(
        conversationId: conversationId,
        isTyping: isTyping,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> muteConversation({
    required String conversationId,
    int? duration,
  }) async {
    try {
      final result = await remoteDataSource.muteConversation(
        conversationId: conversationId,
        duration: duration,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unmuteConversation({
    required String conversationId,
  }) async {
    try {
      final result = await remoteDataSource.unmuteConversation(
        conversationId: conversationId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> pinConversation({
    required String conversationId,
  }) async {
    try {
      final result = await remoteDataSource.pinConversation(
        conversationId: conversationId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unpinConversation({
    required String conversationId,
  }) async {
    try {
      final result = await remoteDataSource.unpinConversation(
        conversationId: conversationId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> deleteConversation({
    required String conversationId,
  }) async {
    try {
      final result = await remoteDataSource.deleteConversation(
        conversationId: conversationId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> blockUser({
    required String userId,
  }) async {
    try {
      final result = await remoteDataSource.blockUser(
        userId: userId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unblockUser({
    required String userId,
  }) async {
    try {
      final result = await remoteDataSource.unblockUser(
        userId: userId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BlockedUser>>> getBlockedUsers() async {
    try {
      final result = await remoteDataSource.getBlockedUsers();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
