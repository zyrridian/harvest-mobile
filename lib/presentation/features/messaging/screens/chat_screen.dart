import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../domain/entities/message.dart';
import '../../../../domain/entities/conversation.dart';
import '../../../providers/messaging_providers.dart';
import '../providers/chat_socket_providers.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────
const _kBg = Color(0xFFF7F8FC);
const _kDarkGreen = Color(0xFF1A2F25);
const _kBubbleMe = Color(0xFF1A2F25);
const _kBubbleThem = Color(0xFFFFFFFF);
const _kInputBg = Color(0xFFFFFFFF);
const _kGrey = Color(0xFF9CA3AF);
const _kOnlineGreen = Color(0xFF22C55E);

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  /// Passed from the farmer detail so the header looks right immediately,
  /// before the conversation detail loads from the server.
  final String? farmerName;
  final String? farmerAvatar;

  const ChatScreen({
    super.key,
    required this.conversationId,
    this.farmerName,
    this.farmerAvatar,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Messages managed locally for real-time optimistic UI
  final List<Message> _messages = [];
  bool _isTyping = false; // other user is typing
  bool _isSendingTyping = false; // we are typing
  Timer? _typingTimer;
  StreamSubscription<Message>? _newMessageSub;
  StreamSubscription<Map<String, dynamic>>? _typingStartSub;
  StreamSubscription<Map<String, dynamic>>? _typingStopSub;
  StreamSubscription<Map<String, dynamic>>? _readAckSub;

  late AnimationController _sendBtnController;
  late Animation<double> _sendBtnScale;

  @override
  void initState() {
    super.initState();

    _sendBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _sendBtnScale = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _sendBtnController, curve: Curves.easeOut),
    );

    _inputController.addListener(_onInputChanged);

    // Connect socket and join conversation
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupSocket());
  }

  Future<void> _setupSocket() async {
    final connect = ref.read(connectChatSocketProvider);
    await connect.connect();

    ref.read(joinConversationProvider).call(widget.conversationId);
    ref.read(markConversationReadProvider).call(widget.conversationId);

    final repo = ref.read(chatSocketRepositoryProvider);

    _newMessageSub = repo.onNewMessage.listen((msg) {
      if (msg.sender.userId != 'me') {
        // only add incoming – ours are optimistic
        setState(() => _messages.add(msg));
        _scrollToBottom();
      }
    });

    _typingStartSub = repo.onTypingStart.listen((data) {
      if (data['conversation_id'] == widget.conversationId) {
        setState(() => _isTyping = true);
      }
    });

    _typingStopSub = repo.onTypingStop.listen((data) {
      if (data['conversation_id'] == widget.conversationId) {
        setState(() => _isTyping = false);
      }
    });

    _readAckSub = repo.onMessageReadAck.listen((data) {
      if (data['conversation_id'] == widget.conversationId) {
        // Mark all our messages as read
        setState(() {
          for (int i = 0; i < _messages.length; i++) {
            _messages[i] = _messages[i];
          }
        });
      }
    });
  }

  void _onInputChanged() {
    final typing = _inputController.text.isNotEmpty;
    if (typing && !_isSendingTyping) {
      _isSendingTyping = true;
      ref.read(sendSocketTypingIndicatorProvider).start(widget.conversationId);
    }
    // Reset the typing-stop debounce timer
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      if (_isSendingTyping) {
        _isSendingTyping = false;
        ref.read(sendSocketTypingIndicatorProvider).stop(widget.conversationId);
      }
    });
    setState(() {}); // rebuild send button visibility
  }

  void _sendMessage() {
    final content = _inputController.text.trim();
    if (content.isEmpty) return;

    HapticFeedback.lightImpact();

    // Bounce animation
    _sendBtnController.forward().then((_) => _sendBtnController.reverse());

    // Optimistic UI: add to list immediately
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimistic = Message(
      messageId: tempId,
      sender: const MessageUser(userId: 'me', name: 'You'),
      type: 'text',
      content: content,
      timestamp: DateTime.now(),
      isRead: false,
    );
    setState(() => _messages.add(optimistic));
    _inputController.clear();
    _scrollToBottom();

    // Emit via socket
    ref.read(sendSocketMessageProvider).call(
          conversationId: widget.conversationId,
          content: content,
          tempId: tempId,
        );

    // Stop typing indicator
    _typingTimer?.cancel();
    if (_isSendingTyping) {
      _isSendingTyping = false;
      ref.read(sendSocketTypingIndicatorProvider).stop(widget.conversationId);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _newMessageSub?.cancel();
    _typingStartSub?.cancel();
    _typingStopSub?.cancel();
    _readAckSub?.cancel();
    _typingTimer?.cancel();
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    _scrollController.dispose();
    _sendBtnController.dispose();
    // Stop typing on exit
    ref.read(sendSocketTypingIndicatorProvider).stop(widget.conversationId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversationAsync =
        ref.watch(conversationDetailProvider(widget.conversationId));

    // Seed messages from REST snapshot on first load
    conversationAsync.whenData((detail) {
      if (_messages.isEmpty && detail.messages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _messages.addAll(detail.messages));
            _scrollToBottom();
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          _buildAppBar(conversationAsync),
          Expanded(child: _buildMessageList()),
          if (_isTyping) _buildTypingIndicator(),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────

  Widget _buildAppBar(AsyncValue<ConversationDetail> conversationAsync) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F5F5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 8),
              conversationAsync.when(
                data: (detail) => _buildHeaderInfo(
                  name: detail.participant.name,
                  avatar: detail.participant.profilePicture,
                  isOnline: detail.participant.isOnline,
                ),
                loading: () => _buildHeaderInfo(
                  name: widget.farmerName ?? 'Farmer',
                  avatar: widget.farmerAvatar,
                  isOnline: false,
                ),
                error: (_, __) => _buildHeaderInfo(
                  name: widget.farmerName ?? 'Farmer',
                  avatar: widget.farmerAvatar,
                  isOnline: false,
                ),
              ),
              const SizedBox(width: 8),
              _buildHeaderAction(
                Icons.phone_outlined,
                onTap: () {},
              ),
              const SizedBox(width: 4),
              _buildHeaderAction(
                Icons.more_vert_rounded,
                onTap: () => _showOptionsSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo({
    required String name,
    String? avatar,
    required bool isOnline,
  }) {
    return Expanded(
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: _kDarkGreen.withValues(alpha:0.1),
                backgroundImage: avatar != null && avatar.startsWith('http')
                    ? CachedNetworkImageProvider(avatar)
                    : null,
                onBackgroundImageError: avatar != null && avatar.startsWith('http')
                    ? (_, __) {}
                    : null,
                child: avatar == null || !avatar.startsWith('http')
                    ? Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'F',
                        style: GoogleFonts.dmSans(
                            color: _kDarkGreen, fontWeight: FontWeight.w700),
                      )
                    : null,
              ),
              if (isOnline)
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _kOnlineGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _kDarkGreen,
                  ),
                ),
                Text(
                  isOnline ? 'Online' : 'Tap to view profile',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: isOnline ? _kOnlineGreen : _kGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 19, color: _kDarkGreen),
      ),
    );
  }

  // ── Message List ───────────────────────────────────────────────────────────

  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _kDarkGreen.withValues(alpha:0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.chat_bubble_outline_rounded,
                  size: 34, color: _kDarkGreen.withValues(alpha:0.4)),
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _kDarkGreen,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Say hello to start the conversation!',
              style: GoogleFonts.dmSans(fontSize: 13, color: _kGrey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.sender.userId == 'me' ||
            message.sender.userId == 'usr_123'; // fallback for REST mock
        final prevMessage = index > 0 ? _messages[index - 1] : null;
        final showDateDivider = prevMessage == null ||
            !_isSameDay(prevMessage.timestamp, message.timestamp);
        final showAvatar = !isMe &&
            (index == _messages.length - 1 ||
                _messages[index + 1].sender.userId != message.sender.userId);

        return Column(
          children: [
            if (showDateDivider) _buildDateDivider(message.timestamp),
            _ChatBubble(
              message: message,
              isMe: isMe,
              showAvatar: showAvatar,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateDivider(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    String label;
    if (_isSameDay(date, now)) {
      label = 'Today';
    } else if (_isSameDay(date, yesterday)) {
      label = 'Yesterday';
    } else {
      label = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                  fontSize: 11, color: _kGrey, fontWeight: FontWeight.w600),
            ),
          ),
          const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ── Typing indicator ────────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        children: [
          _TypingDots(),
          const SizedBox(width: 8),
          Text(
            'typing…',
            style: GoogleFonts.dmSans(fontSize: 12, color: _kGrey),
          ),
        ],
      ),
    );
  }

  // ── Input Bar ──────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    final hasText = _inputController.text.isNotEmpty;

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.add_rounded, color: _kDarkGreen, size: 22),
                ),
              ),
              const SizedBox(width: 8),
              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: _kInputBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _inputController,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    style: GoogleFonts.dmSans(fontSize: 14, color: _kDarkGreen),
                    decoration: InputDecoration(
                      hintText: 'Message…',
                      hintStyle: GoogleFonts.dmSans(
                          fontSize: 14, color: const Color(0xFFBCC0C4)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Send button
              AnimatedBuilder(
                animation: _sendBtnScale,
                builder: (_, child) => Transform.scale(
                  scale: _sendBtnScale.value,
                  child: child,
                ),
                child: GestureDetector(
                  onTap: hasText ? _sendMessage : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: hasText ? _kDarkGreen : const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: hasText
                          ? [
                              BoxShadow(
                                color: _kDarkGreen.withValues(alpha:0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: hasText ? Colors.white : _kGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Options bottom sheet ───────────────────────────────────────────────────

  void _showOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _sheetTile(Icons.volume_off_outlined, 'Mute Notifications'),
              _sheetTile(Icons.search, 'Search in Conversation'),
              _sheetTile(Icons.block, 'Block User', color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetTile(IconData icon, String label, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? _kDarkGreen, size: 22),
      title: Text(label,
          style: GoogleFonts.dmSans(
              color: color ?? _kDarkGreen, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pop(context),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chat Bubble
// ─────────────────────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final bool showAvatar;

  const _ChatBubble({
    required this.message,
    required this.isMe,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 4,
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            SizedBox(
              width: 32,
              child: showAvatar
                  ? CircleAvatar(
                      radius: 14,
                      backgroundColor: _kDarkGreen.withValues(alpha:0.1),
                      backgroundImage: message.sender.profilePicture != null &&
                              message.sender.profilePicture!.startsWith('http')
                          ? CachedNetworkImageProvider(
                              message.sender.profilePicture!)
                          : null,
                      onBackgroundImageError: message.sender.profilePicture != null &&
                              message.sender.profilePicture!.startsWith('http')
                          ? (_, __) {}
                          : null,
                      child: message.sender.profilePicture == null
                          ? Text(
                              message.sender.name.isNotEmpty
                                  ? message.sender.name[0].toUpperCase()
                                  : 'F',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: _kDarkGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    )
                  : null,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isMe ? _kBubbleMe : _kBubbleThem,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildContent(),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.timestamp),
                      style: GoogleFonts.dmSans(fontSize: 10, color: _kGrey),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 3),
                      Icon(
                        message.isRead
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 13,
                        color: message.isRead ? _kDarkGreen : _kGrey,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (message.type) {
      case 'text':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            message.content ?? '',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: isMe ? Colors.white : _kDarkGreen,
              height: 1.4,
            ),
          ),
        );

      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          child: message.images != null && message.images!.isNotEmpty
              ? Image.network(
                  message.images!.first.url,
                  width: 200,
                  fit: BoxFit.cover,
                )
              : const SizedBox.shrink(),
        );

      case 'product':
        return _ProductCard(message: message, isMe: isMe);

      case 'order':
        return _OrderCard(message: message, isMe: isMe);

      case 'voice':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_fill_rounded,
                  color: isMe ? Colors.white : _kDarkGreen, size: 28),
              const SizedBox(width: 8),
              Text(
                '${message.voice?.duration ?? 0}s',
                style: GoogleFonts.dmSans(
                  color: isMe ? Colors.white : _kDarkGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );

      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            message.content ?? '(unsupported message)',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: isMe ? Colors.white70 : _kGrey,
            ),
          ),
        );
    }
  }

  String _formatTime(DateTime t) =>
      '${t.hour}:${t.minute.toString().padLeft(2, '0')}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Product card embedded in message
// ─────────────────────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _ProductCard({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final product = message.product;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product?.image != null && product!.image!.startsWith('http'))
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.image!,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            product?.name ?? '',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isMe ? Colors.white : _kDarkGreen,
            ),
          ),
          Text(
            'Rp ${product?.price ?? 0}/${product?.unit ?? ''}',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: isMe ? Colors.white70 : _kGrey,
            ),
          ),
          if (message.text != null) ...[
            const SizedBox(height: 4),
            Text(
              message.text!,
              style: GoogleFonts.dmSans(
                  fontSize: 13, color: isMe ? Colors.white : _kDarkGreen),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Order card embedded in message
// ─────────────────────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final Message message;
  final bool isMe;
  const _OrderCard({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final order = message.order;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 16, color: isMe ? Colors.white70 : _kGrey),
              const SizedBox(width: 4),
              Text(
                'Order',
                style: GoogleFonts.dmSans(
                    fontSize: 11, color: isMe ? Colors.white70 : _kGrey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '#${order?.orderNumber ?? ''}',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isMe ? Colors.white : _kDarkGreen,
            ),
          ),
          Text(
            'Status: ${order?.status ?? ''}',
            style: GoogleFonts.dmSans(
                fontSize: 12, color: isMe ? Colors.white70 : _kGrey),
          ),
          if (message.text != null) ...[
            const SizedBox(height: 4),
            Text(
              message.text!,
              style: GoogleFonts.dmSans(
                  fontSize: 13, color: isMe ? Colors.white : _kDarkGreen),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated typing dots
// ─────────────────────────────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final delay = i / 3;
          final t = (_ctrl.value - delay).clamp(0.0, 1.0);
          final offset = (t < 0.5 ? t * 2 : 2 - t * 2);
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Transform.translate(
              offset: Offset(0, -4 * offset),
              child: Container(
                width: 7,
                height: 7,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: _kGrey),
              ),
            ),
          );
        }),
      ),
    );
  }
}
