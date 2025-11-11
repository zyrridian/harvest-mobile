import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../../data/models/conversation_model.dart';
import '../../../providers/messaging_providers.dart';

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
    final conversationsAsync =
        ref.watch(conversationsProvider({'filter': _selectedFilter}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
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
          final stats = conversationsData['stats'] as Map<String, dynamic>;

          if (conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 64, color: Colors.grey[400]),
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
              if (stats['unread_conversations'] > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active,
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
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
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

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;

  const _ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final participant = conversation.participant;
    final lastMessage = conversation.lastMessage;

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
          if (participant.isOnline)
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
                child:
                    const Icon(Icons.push_pin, size: 12, color: Colors.white),
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
            const Icon(Icons.verified, size: 16, color: Colors.blue),
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
                Icon(Icons.shopping_bag_outlined,
                    size: 14, color: Colors.grey[600]),
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
          if (lastMessage != null) ...[
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
            Icon(Icons.notifications_off, size: 16, color: Colors.grey[500]),
        ],
      ),
      onTap: () {
        context.push(
            '${AppRouter.chat}?conversationId=${conversation.conversationId}');
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays == 0) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
