import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/message.dart';
import '../../../providers/messaging_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    _messageController.clear();

    // Send message
    final sendMessageUsecase = ref.read(sendMessageUsecaseProvider);
    final result = await sendMessageUsecase(
      conversationId: widget.conversationId,
      type: 'text',
      content: content,
    );

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${failure.message}')),
        );
      },
      (message) {
        // Refresh conversation
        ref.invalidate(conversationDetailProvider(widget.conversationId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversationAsync =
        ref.watch(conversationDetailProvider(widget.conversationId));

    return Scaffold(
      appBar: AppBar(
        title: conversationAsync.when(
          data: (detail) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(detail.participant.name),
              Text(
                detail.participant.isOnline ? 'Online' : 'Offline',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options (mute, block, etc.)
            },
          ),
        ],
      ),
      body: conversationAsync.when(
        data: (detail) => Column(
          children: [
            // Order info banner if conversation is about an order
            if (detail.order != null)
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${detail.order!.orderNumber}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Status: ${detail.order!.status}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to order detail
                      },
                      child: const Text('View'),
                    ),
                  ],
                ),
              ),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: detail.messages.length,
                itemBuilder: (context, index) {
                  final message =
                      detail.messages[detail.messages.length - 1 - index];
                  final isMe =
                      message.sender.userId == 'usr_123'; // Current user
                  return _MessageBubble(message: message, isMe: isMe);
                },
              ),
            ),

            // Quick Replies (if available)
            if (detail.quickReplies.isNotEmpty)
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: detail.quickReplies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(detail.quickReplies[index]),
                        onPressed: () {
                          _messageController.text = detail.quickReplies[index];
                        },
                      ),
                    );
                  },
                ),
              ),

            // Message Input
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // Show attachment options (image, product, etc.)
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
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
                onPressed: () => ref.invalidate(
                    conversationDetailProvider(widget.conversationId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: message.sender.profilePicture != null
                  ? NetworkImage(message.sender.profilePicture!)
                  : null,
              child: message.sender.profilePicture == null
                  ? Text(message.sender.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 12))
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 8),
                    child: Text(
                      message.sender.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                  ),
                  child: _buildMessageContent(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  child: Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ),
                if (message.reactions != null && message.reactions!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 4,
                      children: message.reactions!.map((reaction) {
                        return Text(reaction.emoji,
                            style: const TextStyle(fontSize: 16));
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message.type) {
      case 'text':
        return Text(
          message.content ?? '',
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        );

      case 'image':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.images != null)
              ...message.images!.map((img) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        img.thumbnailUrl ?? img.url,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            if (message.text != null)
              Text(
                message.text!,
                style: TextStyle(color: isMe ? Colors.white : Colors.black87),
              ),
          ],
        );

      case 'product':
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.product?.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    message.product!.image!,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                message.product?.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Rp ${message.product?.price}'),
              if (message.text != null) ...[
                const SizedBox(height: 4),
                Text(message.text!),
              ],
            ],
          ),
        );

      case 'order':
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Order',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                message.order?.orderNumber ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Status: ${message.order?.status}'),
              Text('Total: Rp ${message.order?.totalAmount}'),
              if (message.text != null) ...[
                const SizedBox(height: 4),
                Text(message.text!),
              ],
            ],
          ),
        );

      case 'voice':
        return Row(
          children: [
            Icon(Icons.play_circle_filled,
                color: isMe ? Colors.white : Colors.blue),
            const SizedBox(width: 8),
            Text(
              '${message.voice?.duration}s',
              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
            ),
          ],
        );

      default:
        return Text(
          'Unsupported message type: ${message.type}',
          style: TextStyle(color: isMe ? Colors.white70 : Colors.grey),
        );
    }
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
