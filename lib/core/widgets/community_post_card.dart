import 'package:flutter/material.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;
  final String? currentUserId;
  final VoidCallback onTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLikeToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String? profileImageUrl;

  const CommunityPostCard({
    super.key,
    required this.post,
    required this.currentUserId,
    required this.onTap,
    required this.onProfileTap,
    required this.onLikeToggle,
    required this.onEdit,
    required this.onDelete,
    this.profileImageUrl,
  });

  String? _getValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    return url;
  }

  String _formatDate(DateTime date) {
    return timeago.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isMyPost = post.userId == currentUserId;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            GestureDetector(
              onTap: onProfileTap,
              child: Row(
                children: [
                  profileImageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(profileImageUrl!),
                          radius: 20,
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey.shade100,
                          backgroundImage: _getValidImageUrl(
                                      post.farmer?.profileImage ??
                                          post.user.avatarUrl) !=
                                  null
                              ? NetworkImage(_getValidImageUrl(
                                  post.farmer?.profileImage ??
                                      post.user.avatarUrl)!)
                              : null,
                          child: _getValidImageUrl(post.farmer?.profileImage ??
                                      post.user.avatarUrl) ==
                                  null
                              ? Icon(Icons.person_outline,
                                  color: Colors.grey.shade500)
                              : null,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.farmer?.name ?? post.user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          _formatDate(post.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
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
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
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
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    const IconButton(
                      icon: PhosphorIcon(PhosphorIconsRegular.dotsThree,
                          color: Colors.transparent),
                      onPressed: null,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Content
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Images
            if (post.images.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: post.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          post.images[index],
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Tags
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                children: post.tags
                    .map((t) => Text(
                          '#${t.tag}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Footer actions
            Row(
              children: [
                InkWell(
                  onTap: onLikeToggle,
                  child: Row(
                    children: [
                      Icon(
                        post.isLikedByUser
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 20,
                        color: post.isLikedByUser
                            ? const Color(0xFFDC2626)
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likesCount}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    PhosphorIcon(PhosphorIconsRegular.chatCircle,
                        size: 20, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      '${post.commentsCount}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.share_outlined,
                    size: 20, color: Colors.grey.shade600),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
