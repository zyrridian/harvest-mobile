import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/router/app_router.dart';
import '../../data/models/conversation_model.dart';
import '../../../../presentation/providers/messaging_providers.dart';
import '../providers/chat_socket_providers.dart';
import '../../../../core/utils/time_utils.dart';

class ConversationsListScreen extends ConsumerStatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  ConsumerState<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState
    extends ConsumerState<ConversationsListScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    // Auto-refresh the list when socket events happen
    ref.listen(newMessageStreamProvider, (_, __) {
      ref.invalidate(conversationsProvider);
    });
    ref.listen(readAckStreamProvider, (_, __) {
      ref.invalidate(conversationsProvider);
    });

    final conversationsAsync = ref.watch(conversationsProvider((
      filter: _selectedFilter,
      search: null,
      page: 1,
      limit: 20,
    )));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: Color(0xFF1A2F25)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.main);
            }
          },
        ),
        title: Text(
          'Messages',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF1A2F25),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
        ),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Messages')),
              const PopupMenuItem(value: 'unread', child: Text('Unread')),
              const PopupMenuItem(value: 'orders', child: Text('Orders')),
              const PopupMenuItem(value: 'general', child: Text('General')),
            ],
          ),
        ],
      ),
      body: conversationsAsync.when(
        data: (data) {
          final conversationsData = data['data'] as Map<String, dynamic>;
          final conversations = (conversationsData['conversations'] as List)
              .map((json) => ConversationModel.fromJson(json))
              .toList();
          final stats = conversationsData['stats'] as Map<String, dynamic>?;

          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PhosphorIcon(PhosphorIconsRegular.chatCircle,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start chatting with sellers',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Stats Card
              if (stats != null && stats['unread_conversations'] > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      PhosphorIcon(PhosphorIconsRegular.bellRinging,
                          color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'You have ${stats['unread_conversations']} unread conversation(s) with ${stats['total_unread_messages']} new message(s)',
                        style: TextStyle(color: Colors.blue[900], fontSize: 13),
                      ),
                    ],
                  ),
                ),

              // Conversations List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(conversationsProvider);
                  },
                  child: ListView.separated(
                    itemCount: conversations.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      return _ConversationTile(conversation: conversation);
                    },
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PhosphorIcon(PhosphorIconsRegular.warningCircle,
                  size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(conversationsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationTile extends ConsumerWidget {
  final ConversationModel conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participant = conversation.participant;
    final lastMessage = conversation.lastMessage;

    final typingState = ref.watch(typingIndicatorNotifierProvider);
    final typingUsers = typingState[conversation.conversationId] ?? {};
    final isTyping = typingUsers.contains(participant.userId);

    final presenceState = ref.watch(userPresenceNotifierProvider);
    final userPresence = presenceState[participant.userId];
    final isOnline = userPresence?.isOnline ?? participant.isOnline;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: participant.profilePicture != null
                ? NetworkImage(participant.profilePicture!)
                : null,
            child: participant.profilePicture == null
                ? Text(participant.name[0].toUpperCase())
                : null,
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          if (conversation.pinned)
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const PhosphorIcon(PhosphorIconsRegular.pushPin,
                    size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              participant.name,
              style: TextStyle(
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          if (participant.verified)
            const PhosphorIcon(PhosphorIconsRegular.checkCircle,
                size: 16, color: Colors.blue),
          const SizedBox(width: 4),
          if (conversation.type == 'order')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Order',
                style: TextStyle(fontSize: 10, color: Colors.orange[900]),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (conversation.product != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                PhosphorIcon(PhosphorIconsRegular.shoppingBag,
                    size: 14, color: Colors.blue[700]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    conversation.product!.name,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (isTyping) ...[
            const SizedBox(height: 4),
            const Text(
              'Typing...',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ] else if (lastMessage != null) ...[
            const SizedBox(height: 4),
            Text(
              lastMessage.preview,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: conversation.unreadCount > 0
                    ? Colors.black87
                    : Colors.grey[600],
                fontWeight: conversation.unreadCount > 0
                    ? FontWeight.w500
                    : FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (lastMessage != null)
            Text(
              _formatTime(lastMessage.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: conversation.unreadCount > 0
                    ? Colors.blue
                    : Colors.grey[600],
              ),
            ),
          if (conversation.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                conversation.unreadCount > 9
                    ? '9+'
                    : conversation.unreadCount.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          if (conversation.muted)
            PhosphorIcon(PhosphorIconsRegular.bellSlash,
                size: 16, color: Colors.grey[500]),
        ],
      ),
      onTap: () {
        context
            .push(
                '${AppRouter.chat}?conversationId=${conversation.conversationId}')
            .then((_) {
          // Refresh the list when returning from the chat
          ref.invalidate(conversationsProvider);
        });
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    return TimeUtils.formatMessageTime(timestamp);
  }
}
