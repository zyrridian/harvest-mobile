import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import 'package:intl/intl.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../domain/entities/community_comment.dart';
import '../providers/community_controller.dart';
import '../providers/post_detail_controller.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';

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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat.yMMMd().format(date);
    }
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

  void _deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close screen
              try {
                await ref
                    .read(communityControllerProvider.notifier)
                    .deletePost(widget.post.id);
              } catch (e) {
                // error handled
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editPost() {
    final titleController = TextEditingController(text: widget.post.title);
    final contentController = TextEditingController(text: widget.post.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              final newTitle = titleController.text.trim();
              final newContent = contentController.text.trim();
              if (newTitle.isNotEmpty && newContent.isNotEmpty) {
                Navigator.pop(context);
                try {
                  await ref
                      .read(communityControllerProvider.notifier)
                      .editPost(widget.post.id, newTitle, newContent);
                } catch (e) {
                  // error handled
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String? _getValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty || !url.startsWith('http')) {
      return null;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postDetailControllerProvider(widget.post.id));
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );

    return WebConstrainedBox(
      maxWidth: 600,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
                color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(postDetailControllerProvider(widget.post.id));
                },
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
                              return _buildCommentThread(
                                  comment, currentUserId);
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
                      orElse: () =>
                          const SliverFillRemaining(child: SizedBox()),
                    ),
                  ],
                ),
              ),
            ),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    final postsState = ref.watch(communityControllerProvider);
    final CommunityPost currentPost = postsState.maybeWhen(
      data: (data) => data.data
          .firstWhere((p) => p.id == widget.post.id, orElse: () => widget.post),
      orElse: () => widget.post,
    );

    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );

    final isMyPost = currentPost.userId == currentUserId;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author
          // Author
          GestureDetector(
            onTap: () {
              if (currentPost.farmer != null) {
                context.push(
                  AppRouter.farmerDetail,
                  extra: Farmer(
                    id: currentPost.farmer!.id,
                    userId: currentPost.userId,
                    name: currentPost.farmer!.name,
                    description: '',
                    latitude: 0,
                    longitude: 0,
                    address: '',
                    rating: 0,
                    totalReviews: 0,
                    totalProducts: 0,
                    specialties: const [],
                    isVerified: true,
                    hasMapFeature: false,
                    joinedDate: DateTime.now(),
                    isOnline: false,
                    profileImage: currentPost.farmer!.profileImage,
                  ),
                );
              }
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: _getValidImageUrl(
                              currentPost.farmer?.profileImage ??
                                  currentPost.user.avatarUrl) !=
                          null
                      ? NetworkImage(_getValidImageUrl(
                          currentPost.farmer?.profileImage ??
                              currentPost.user.avatarUrl)!)
                      : null,
                  child: _getValidImageUrl(currentPost.farmer?.profileImage ??
                              currentPost.user.avatarUrl) ==
                          null
                      ? PhosphorIcon(PhosphorIconsRegular.user,
                          color: Colors.grey.shade500)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentPost.farmer?.name ?? currentPost.user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      Text(
                        _formatDate(currentPost.createdAt),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
                if (isMyPost)
                  PopupMenuButton<String>(
                    icon: PhosphorIcon(PhosphorIconsRegular.dotsThree,
                        color: Colors.grey.shade600),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editPost();
                      } else if (value == 'delete') {
                        _deletePost();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: const [
                            PhosphorIcon(PhosphorIconsRegular.pencilSimple,
                                size: 20),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: const [
                            PhosphorIcon(PhosphorIconsRegular.trash,
                                size: 20, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.dotsThree,
                        color: Colors.transparent),
                    onPressed: null,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            currentPost.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            currentPost.content,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),

          if (currentPost.images.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...currentPost.images.map((url) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(url,
                        width: double.infinity, fit: BoxFit.cover),
                  ),
                )),
          ],

          if (currentPost.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: currentPost.tags
                  .map((t) => Text(
                        '#${t.tag}',
                        style: TextStyle(
                            color: const Color(0xFF166534),
                            fontWeight: FontWeight.w500),
                      ))
                  .toList(),
            ),
          ],

          const SizedBox(height: 16),
          // const Divider(height: 1),
          // const SizedBox(height: 12),

          Wrap(
            spacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  ref
                      .read(communityControllerProvider.notifier)
                      .toggleLike(currentPost.id, currentPost.isLikedByUser);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PhosphorIcon(
                      currentPost.isLikedByUser
                          ? PhosphorIconsFill.heart
                          : PhosphorIconsRegular.heart,
                      size: 20,
                      color: currentPost.isLikedByUser
                          ? Colors.red
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text('${currentPost.likesCount}'),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PhosphorIcon(PhosphorIconsRegular.chatCircle,
                      size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text('${currentPost.commentsCount}'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentThread(CommunityComment comment, String? currentUserId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCommentItem(comment,
            isReply: false, currentUserId: currentUserId),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 48.0), // Indent replies
            child: Column(
              children: comment.replies
                  .map((reply) => _buildCommentItem(reply,
                      isReply: true, currentUserId: currentUserId))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentItem(CommunityComment comment,
      {required bool isReply, String? currentUserId}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(isReply ? 0 : 16, 16, 16, 8),
      child: Opacity(
        opacity: comment.isPending ? 0.5 : 1.0,
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
                  ? PhosphorIcon(PhosphorIconsRegular.user,
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
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      if (isReply && comment.replyToUser != null) ...[
                        Text(' replied to ',
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade600)),
                        Flexible(
                          child: Text(
                            '@${comment.replyToUser!.name}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color: const Color(0xFF166534)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(comment.createdAt),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.content,
                    style: TextStyle(fontSize: 14, height: 1.4),
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
                            PhosphorIcon(
                              comment.isLikedByUser
                                  ? PhosphorIconsFill.heart
                                  : PhosphorIconsRegular.heart,
                              size: 16,
                              color: comment.isLikedByUser
                                  ? Colors.red
                                  : Colors.grey.shade500,
                            ),
                            if (comment.likesCount > 0) ...[
                              const SizedBox(width: 4),
                              Text(
                                '${comment.likesCount}',
                                style: TextStyle(
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
                            PhosphorIcon(PhosphorIconsRegular.arrowUUpLeft,
                                size: 16, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text('Reply',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      if (comment.user.id == currentUserId)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Comment'),
                                content: const Text(
                                    'Are you sure you want to delete this comment?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel',
                                        style:
                                            TextStyle(color: Colors.black87)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ref
                                          .read(postDetailControllerProvider(
                                                  widget.post.id)
                                              .notifier)
                                          .deleteComment(comment.id);
                                    },
                                    child: const Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PhosphorIcon(PhosphorIconsRegular.trash,
                              size: 16, color: Colors.grey.shade500),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  Text('@$_replyToUserName',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _replyToUserName = null;
                        _replyToUserId = null;
                        _replyToCommentId = null;
                      });
                    },
                    child: PhosphorIcon(PhosphorIconsRegular.x,
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
                    hintStyle:
                        TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _submitComment(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const PhosphorIcon(PhosphorIconsFill.paperPlaneRight,
                    color: Color(0xFF166534)),
                onPressed: _submitComment,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
