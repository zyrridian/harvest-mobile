import 'package:dartz/dartz.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';
import '../../core/error/failure.dart';

abstract class MessagingRepository {
  /// Get list of conversations
  Future<Either<Failure, Map<String, dynamic>>> getConversations({
    String filter = 'all',
    String? search,
    int page = 1,
    int limit = 20,
  });

  /// Get conversation detail with messages
  Future<Either<Failure, ConversationDetail>> getConversationDetail({
    required String conversationId,
    int page = 1,
    int limit = 50,
    String? beforeMessageId,
  });

  /// Start new conversation
  Future<Either<Failure, Map<String, dynamic>>> startConversation({
    required String recipientId,
    required String type,
    String? orderId,
    String? productId,
    String? initialMessage,
  });

  /// Send message in conversation
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String type,
    String? content,
    List<String>? imagePaths,
    String? productId,
    String? orderId,
    String? voicePath,
    String? replyToMessageId,
  });

  /// Edit message
  Future<Either<Failure, Map<String, dynamic>>> editMessage({
    required String messageId,
    required String content,
  });

  /// Delete message
  Future<Either<Failure, Map<String, dynamic>>> deleteMessage({
    required String messageId,
    String deleteFor = 'me',
  });

  /// Mark message as read
  Future<Either<Failure, Map<String, dynamic>>> markMessageAsRead({
    required String messageId,
  });

  /// Mark all messages in conversation as read
  Future<Either<Failure, Map<String, dynamic>>> markConversationAsRead({
    required String conversationId,
  });

  /// Add reaction to message
  Future<Either<Failure, Map<String, dynamic>>> addReaction({
    required String messageId,
    required String emoji,
  });

  /// Remove reaction from message
  Future<Either<Failure, Map<String, dynamic>>> removeReaction({
    required String messageId,
  });

  /// Send typing indicator
  Future<Either<Failure, Map<String, dynamic>>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  });

  /// Mute conversation
  Future<Either<Failure, Map<String, dynamic>>> muteConversation({
    required String conversationId,
    int? duration,
  });

  /// Unmute conversation
  Future<Either<Failure, Map<String, dynamic>>> unmuteConversation({
    required String conversationId,
  });

  /// Pin conversation
  Future<Either<Failure, Map<String, dynamic>>> pinConversation({
    required String conversationId,
  });

  /// Unpin conversation
  Future<Either<Failure, Map<String, dynamic>>> unpinConversation({
    required String conversationId,
  });

  /// Delete conversation
  Future<Either<Failure, Map<String, dynamic>>> deleteConversation({
    required String conversationId,
  });

  /// Block user
  Future<Either<Failure, Map<String, dynamic>>> blockUser({
    required String userId,
  });

  /// Unblock user
  Future<Either<Failure, Map<String, dynamic>>> unblockUser({
    required String userId,
  });

  /// Get blocked users
  Future<Either<Failure, List<BlockedUser>>> getBlockedUsers();
}
