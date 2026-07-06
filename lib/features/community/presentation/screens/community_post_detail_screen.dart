import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/community_post.dart';
import '../../domain/entities/community_comment.dart';
import '../providers/community_controller.dart';
import '../providers/post_detail_controller.dart';
import '../providers/community_controller.dart';

class CommunityPostDetailScreen extends ConsumerStatefulWidget {
  final CommunityPost post;

  const CommunityPostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<CommunityPostDetailScreen> createState() =>
      _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState
    extends ConsumerState<CommunityPostDetailScreen> {
  final _commentController = TextEditingController();
  String? _replyToCommentId;
  String? _replyToUserId;
  String? _replyToUserName;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    // Add \@mention if replying
    String content = _commentController.text.trim();
    if (_replyToUserName != null && !content.startsWith('@$_replyToUserName')) {
      content = '@$_replyToUserName $content';
    }

    ref.read(postDetailControllerProvider(widget.post.id).notifier).addComment(
          content,
          parentId: _replyToCommentId,
          replyToUserId: _replyToUserId,
        );

    _commentController.clear();
    setState(() {
      _replyToCommentId = null;
      _replyToUserId = null;
      _replyToUserName = null;
    });
  }

  void _setReplyContext(CommunityComment comment) {
    setState(() {
      // If replying to a reply, parentId is the top-level comment id
      _replyToCommentId = comment.parentId ?? comment.id;
      _replyToUserId = comment.user.id;
      _replyToUserName = comment.user.name;
    });
    FocusScope.of(context).requestFocus(); // Show keyboard
  }

  void _deletePost() async {
    final useCase = ref.read(deletePostUseCaseProvider);
    final result = await useCase.call(postId: widget.post.id);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        ref
            .read(communityControllerProvider.notifier)
            .setFilter('All Posts'); // refresh feed
        Navigator.pop(context);
      },
    );
  }

  void _showPostOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Handle edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deletePost();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postDetailControllerProvider(widget.post.id));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildPostHeader(),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 8,
                    color: Colors.grey.shade100,
                  ),
                ),
                state.maybeWhen(
                  data: (data) {
                    if (data.data.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('No comments yet')),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final comment = data.data[index];
                          return _buildCommentThread(comment);
                        },
                        childCount: data.data.length,
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (msg) => SliverFillRemaining(
                    child: Center(child: Text(msg)),
                  ),
                  orElse: () => const SliverFillRemaining(child: SizedBox()),
                ),
              ],
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: widget.post.user.avatarUrl != null
                    ? NetworkImage(widget.post.user.avatarUrl!)
                    : null,
                child: widget.post.user.avatarUrl == null
                    ? Icon(Icons.person_outline, color: Colors.grey.shade500)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.user.name,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    Text(
                      DateFormat('M/d/yyyy').format(widget.post.createdAt),
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: _showPostOptions,
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            widget.post.title,
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.post.content,
            style: GoogleFonts.inter(fontSize: 16, height: 1.5),
          ),

          if (widget.post.images.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...widget.post.images
                .map((url) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(url,
                            width: double.infinity, fit: BoxFit.cover),
                      ),
                    ))
                .toList(),
          ],

          if (widget.post.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: widget.post.tags
                  .map((t) => Text(
                        '#${t.tag}',
                        style: GoogleFonts.inter(
                            color: const Color(0xFF166534),
                            fontWeight: FontWeight.w500),
                      ))
                  .toList(),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Wrap(
            spacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.post.isLikedByUser
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 20,
                    color: widget.post.isLikedByUser
                        ? Colors.red
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text('${widget.post.likesCount}'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text('${widget.post.commentsCount}'),
                ],
              ),
              Icon(Icons.share_outlined, size: 20, color: Colors.grey.shade600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentThread(CommunityComment comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCommentItem(comment, isReply: false),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 48.0), // Indent replies
            child: Column(
              children: comment.replies
                  .map((reply) => _buildCommentItem(reply, isReply: true))
                  .toList(),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildCommentItem(CommunityComment comment, {required bool isReply}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isReply ? 0 : 16, 16, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade100,
            backgroundImage: comment.user.avatarUrl != null
                ? NetworkImage(comment.user.avatarUrl!)
                : null,
            child: comment.user.avatarUrl == null
                ? Icon(Icons.person_outline,
                    size: 16, color: Colors.grey.shade500)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user.name,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    if (isReply && comment.replyToUser != null) ...[
                      Text(' replied to ',
                          style: GoogleFonts.inter(
                              fontSize: 13, color: Colors.grey.shade600)),
                      Flexible(
                        child: Text(
                          '@${comment.replyToUser!.name}',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: const Color(0xFF166534)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('M/d/yyyy').format(comment.createdAt),
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: GoogleFonts.inter(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(postDetailControllerProvider(widget.post.id)
                                .notifier)
                            .toggleCommentLike(
                                comment.id, comment.isLikedByUser);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            comment.isLikedByUser
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 16,
                            color: comment.isLikedByUser
                                ? Colors.red
                                : Colors.grey.shade500,
                          ),
                          if (comment.likesCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '${comment.likesCount}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: comment.isLikedByUser
                                    ? Colors.red
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _setReplyContext(comment),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.reply,
                              size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text('Reply',
                              style: GoogleFonts.inter(
                                  fontSize: 13, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                    Icon(Icons.delete_outline,
                        size: 16, color: Colors.grey.shade500),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_replyToUserName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 4),
              child: Row(
                children: [
                  Text('Replying to ',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.grey.shade600)),
                  Text('@$_replyToUserName',
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _replyToUserName = null;
                        _replyToUserId = null;
                        _replyToCommentId = null;
                      });
                    },
                    child: Icon(Icons.close,
                        size: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: GoogleFonts.inter(
                        color: Colors.grey.shade500, fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _submitComment(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Color(0xFF166534)),
                onPressed: _submitComment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
