import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/remote/messaging_remote_datasource.dart';
import '../../data/repositories/messaging_repository_impl.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../../domain/usecases/messaging/block_user.dart';
import '../../domain/usecases/messaging/delete_message.dart';
import '../../domain/usecases/messaging/get_conversation_detail.dart';
import '../../domain/usecases/messaging/get_conversations.dart';
import '../../domain/usecases/messaging/mark_conversation_as_read.dart';
import '../../domain/usecases/messaging/send_message.dart';
import '../../domain/usecases/messaging/send_typing_indicator.dart';
import '../../domain/usecases/messaging/start_conversation.dart';

// Data Source Provider
final messagingRemoteDataSourceProvider =
    Provider<MessagingRemoteDataSource>((ref) {
  return MessagingRemoteDataSourceImpl();
});

// Repository Provider
final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(ref.read(messagingRemoteDataSourceProvider));
});

// Use-case Providers
final getConversationsUsecaseProvider = Provider<GetConversations>((ref) {
  return GetConversations(ref.read(messagingRepositoryProvider));
});

final getConversationDetailUsecaseProvider =
    Provider<GetConversationDetail>((ref) {
  return GetConversationDetail(ref.read(messagingRepositoryProvider));
});

final startConversationUsecaseProvider = Provider<StartConversation>((ref) {
  return StartConversation(ref.read(messagingRepositoryProvider));
});

final sendMessageUsecaseProvider = Provider<SendMessage>((ref) {
  return SendMessage(ref.read(messagingRepositoryProvider));
});

final markConversationAsReadUsecaseProvider =
    Provider<MarkConversationAsRead>((ref) {
  return MarkConversationAsRead(ref.read(messagingRepositoryProvider));
});

final deleteMessageUsecaseProvider = Provider<DeleteMessage>((ref) {
  return DeleteMessage(ref.read(messagingRepositoryProvider));
});

final sendTypingIndicatorUsecaseProvider = Provider<SendTypingIndicator>((ref) {
  return SendTypingIndicator(ref.read(messagingRepositoryProvider));
});

final blockUserUsecaseProvider = Provider<BlockUser>((ref) {
  return BlockUser(ref.read(messagingRepositoryProvider));
});

// Conversations list provider
final conversationsProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
        (ref, params) async {
  final usecase = ref.read(getConversationsUsecaseProvider);
  final result = await usecase(
    filter: params['filter'] as String? ?? 'all',
    search: params['search'] as String?,
    page: params['page'] as int? ?? 1,
    limit: params['limit'] as int? ?? 20,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// Conversation detail provider
final conversationDetailProvider =
    FutureProvider.family.autoDispose((ref, String conversationId) async {
  final usecase = ref.read(getConversationDetailUsecaseProvider);
  final result = await usecase(conversationId: conversationId);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});
