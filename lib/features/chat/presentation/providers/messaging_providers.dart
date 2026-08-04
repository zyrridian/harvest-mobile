import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../community/data/datasources/remote/messaging_remote_datasource.dart';
import '../../../community/data/repositories/messaging_repository_impl.dart';
import '../../../community/domain/repositories/messaging_repository.dart';
import '../../../community/domain/usecases/block_user.dart';
import '../../../community/domain/usecases/delete_message.dart';
import '../../../community/domain/usecases/get_conversation_detail.dart';
import '../../../community/domain/usecases/get_conversations.dart';
import '../../../community/domain/usecases/mark_conversation_as_read.dart';
import '../../../community/domain/usecases/send_message.dart';
import '../../../community/domain/usecases/send_typing_indicator.dart';
import '../../../community/domain/usecases/start_conversation.dart';

// Data Source Provider – now backed by the real Dio instance
final messagingRemoteDataSourceProvider =
    Provider<MessagingRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return MessagingRemoteDataSourceImpl(dio);
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

typedef ConversationsFilter = ({
  String filter,
  String? search,
  int page,
  int limit,
});

// Conversations list provider
final conversationsProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, ConversationsFilter>(
        (ref, params) async {
  final usecase = ref.read(getConversationsUsecaseProvider);
  final result = await usecase(
    filter: params.filter,
    search: params.search,
    page: params.page,
    limit: params.limit,
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
