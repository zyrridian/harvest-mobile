import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../data/datasources/remote/chat_socket_service.dart';
import '../../data/repositories/chat_socket_repository_impl.dart';
import '../../domain/repositories/chat_socket_repository.dart';
import '../../domain/usecases/connect_chat_socket.dart';

import '../../domain/usecases/mark_conversation_read.dart';
import '../../domain/usecases/send_socket_message.dart';
import '../../domain/usecases/send_socket_typing_indicator.dart';

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

// ── Global State Notifiers ─────────────────────────────────────────────────

class UserPresence {
  final bool isOnline;
  final DateTime? lastSeen;
  UserPresence({required this.isOnline, this.lastSeen});
}

class UserPresenceNotifier extends StateNotifier<Map<String, UserPresence>> {
  UserPresenceNotifier() : super({});

  void setOnline(String userId) {
    state = {
      ...state,
      userId: UserPresence(isOnline: true, lastSeen: DateTime.now()),
    };
  }

  void setOffline(String userId, DateTime lastSeen) {
    state = {
      ...state,
      userId: UserPresence(isOnline: false, lastSeen: lastSeen),
    };
  }
}

final userPresenceNotifierProvider = StateNotifierProvider<UserPresenceNotifier, Map<String, UserPresence>>((ref) {
  final notifier = UserPresenceNotifier();
  final repo = ref.watch(chatSocketRepositoryProvider);

  final subOnline = repo.onUserOnline.listen((event) {
    final userId = event['userId']?.toString(); // CamelCase based on backend schema
    if (userId != null) {
      notifier.setOnline(userId);
    }
  });

  final subOffline = repo.onUserOffline.listen((event) {
    final userId = event['userId']?.toString();
    final lastSeenStr = event['last_seen']?.toString();
    DateTime? lastSeen;
    if (lastSeenStr != null) {
      lastSeen = DateTime.tryParse(lastSeenStr);
    }
    if (userId != null) {
      notifier.setOffline(userId, lastSeen ?? DateTime.now());
    }
  });

  ref.onDispose(() {
    subOnline.cancel();
    subOffline.cancel();
  });

  return notifier;
});

class TypingIndicatorNotifier extends StateNotifier<Map<String, Set<String>>> {
  TypingIndicatorNotifier() : super({});

  void startTyping(String conversationId, String userId) {
    final currentSet = state[conversationId] ?? {};
    state = {
      ...state,
      conversationId: {...currentSet, userId},
    };
  }

  void stopTyping(String conversationId, String userId) {
    final currentSet = state[conversationId] ?? {};
    final newSet = {...currentSet};
    newSet.remove(userId);
    state = {
      ...state,
      conversationId: newSet,
    };
  }
}

final typingIndicatorNotifierProvider = StateNotifierProvider<TypingIndicatorNotifier, Map<String, Set<String>>>((ref) {
  final notifier = TypingIndicatorNotifier();
  final repo = ref.watch(chatSocketRepositoryProvider);

  final subStart = repo.onTypingStart.listen((event) {
    final convId = event['conversation_id']?.toString();
    final userId = event['user_id']?.toString();
    if (convId != null && userId != null) {
      notifier.startTyping(convId, userId);
    }
  });

  final subStop = repo.onTypingStop.listen((event) {
    final convId = event['conversation_id']?.toString();
    final userId = event['user_id']?.toString();
    if (convId != null && userId != null) {
      notifier.stopTyping(convId, userId);
    }
  });

  ref.onDispose(() {
    subStart.cancel();
    subStop.cancel();
  });

  return notifier;
});
