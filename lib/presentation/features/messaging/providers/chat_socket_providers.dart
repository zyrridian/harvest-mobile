import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../data/datasources/remote/chat_socket_service.dart';
import '../../../../data/repositories/chat_socket_repository_impl.dart';
import '../../../../domain/repositories/chat_socket_repository.dart';
import '../../../../domain/usecases/messaging/connect_chat_socket.dart';
import '../../../../domain/usecases/messaging/join_conversation.dart';
import '../../../../domain/usecases/messaging/mark_conversation_read.dart';
import '../../../../domain/usecases/messaging/send_socket_message.dart';
import '../../../../domain/usecases/messaging/send_socket_typing_indicator.dart';

// ── Low-level service ──────────────────────────────────────────────────────

/// Singleton-scoped [ChatSocketService].  
/// Kept alive for the lifetime of the app so the socket stays open.
final chatSocketServiceProvider = Provider<ChatSocketService>((ref) {
  final service = ChatSocketService();
  ref.onDispose(service.dispose);
  return service;
});

// ── Repository ─────────────────────────────────────────────────────────────

final chatSocketRepositoryProvider = Provider<ChatSocketRepository>((ref) {
  final service = ref.watch(chatSocketServiceProvider);
  final storage = ref.watch(secureStorageProvider);
  return ChatSocketRepositoryImpl(service, storage);
});

// ── Use cases ──────────────────────────────────────────────────────────────

final connectChatSocketProvider = Provider<ConnectChatSocket>((ref) {
  return ConnectChatSocket(ref.watch(chatSocketRepositoryProvider));
});

final joinConversationProvider = Provider<JoinConversation>((ref) {
  return JoinConversation(ref.watch(chatSocketRepositoryProvider));
});

final sendSocketMessageProvider = Provider<SendSocketMessage>((ref) {
  return SendSocketMessage(ref.watch(chatSocketRepositoryProvider));
});

final markConversationReadProvider = Provider<MarkConversationRead>((ref) {
  return MarkConversationRead(ref.watch(chatSocketRepositoryProvider));
});

final sendSocketTypingIndicatorProvider =
    Provider<SendSocketTypingIndicator>((ref) {
  return SendSocketTypingIndicator(ref.watch(chatSocketRepositoryProvider));
});

// ── Convenience stream providers ───────────────────────────────────────────

/// Exposes the live `message:new` stream for any widget to listen to.
final newMessageStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(chatSocketRepositoryProvider).onNewMessage;
});

/// Exposes typing-start events.
final typingStartStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(chatSocketRepositoryProvider).onTypingStart;
});

/// Exposes typing-stop events.
final typingStopStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(chatSocketRepositoryProvider).onTypingStop;
});

/// Exposes read-receipt acknowledgement events.
final readAckStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(chatSocketRepositoryProvider).onMessageReadAck;
});

/// Exposes user online/offline events combined in one stream.
final userPresenceStreamProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.watch(chatSocketRepositoryProvider);
  return repo.onUserOnline
      .map((e) => {...e, 'status': 'online'})
      .mergeWith([
        repo.onUserOffline.map((e) => {...e, 'status': 'offline'}),
      ]);
});

/// Exposes socket-level error messages.
final socketErrorStreamProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(chatSocketRepositoryProvider).onError;
});

/// Extension for merging streams – avoids bringing in rx_dart.
extension _StreamMerge<T> on Stream<T> {
  Stream<T> mergeWith(List<Stream<T>> others) async* {
    final streams = [this, ...others];
    // Simple merge: listen to each stream and yield items.
    final controller = _BroadcastStreamMerger<T>(streams);
    yield* controller.stream;
  }
}

class _BroadcastStreamMerger<T> {
  late final Stream<T> stream;
  _BroadcastStreamMerger(List<Stream<T>> streams) {
    stream = Stream.multi((controller) {
      for (final s in streams) {
        s.listen(
          controller.add,
          onError: controller.addError,
        );
      }
    });
  }
}
