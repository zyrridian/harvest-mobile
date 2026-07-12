import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';
import 'package:harvest_app/features/community/presentation/providers/community_controller.dart';
import 'package:harvest_app/features/community/presentation/providers/community_state.dart';
import 'package:harvest_app/features/community/presentation/providers/recipe_controller.dart';
import 'package:intl/intl.dart';
import 'create_post_screen.dart';
import 'create_recipe_screen.dart';
import 'community_post_detail_screen.dart';
import 'recipe_detail_screen.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/presentation/shared_widgets/pill_tab_bar.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollUp = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showScrollUp) {
        setState(() => _showScrollUp = true);
      } else if (_scrollController.offset <= 200 && _showScrollUp) {
        setState(() => _showScrollUp = false);
      }
    });
  }

  final List<String> _filters = [
    'All Posts',
    'Kitchen Recipes',
    'Farmer Updates',
    'Following',
    'My Posts',
  ];

  final List<String> _tags = [
    '#organic',
    '#farming',
    '#tips',
    '#recipes',
    '#harvest',
    '#sustainable',
  ];

  String _selectedFilter = 'All Posts';
  String? _selectedTag;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

  void _onFilterSelected(String filter) {
    setState(() => _selectedFilter = filter);
    final apiFilterMap = {
      'All Posts': 'all',
      'Kitchen Recipes': 'recipes',
      'Farmer Updates': 'farmers',
      'Following': 'following',
      'My Posts': 'my_posts',
    };
    ref
        .read(communityControllerProvider.notifier)
        .setFilter(apiFilterMap[filter]!);
  }

  void _onTagSelected(String tag) {
    final cleanTag = tag.replaceAll('#', '');
    if (_selectedTag == cleanTag) {
      setState(() => _selectedTag = null);
      ref.read(communityControllerProvider.notifier).setTag('');
    } else {
      setState(() => _selectedTag = cleanTag);
      ref.read(communityControllerProvider.notifier).setTag(cleanTag);
    }
  }

  Future<void> _openCreatePost() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Transform.rotate(
                    angle: -0.017, // -1 degree
                    child: Text(
                      'What are we making?',
                      style: GoogleFonts.caveat(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'PICK A POST TYPE',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _CreateOptionCard(
                    title: 'Community Post',
                    subtitle: 'Share an update or ask a question',
                    icon: PhosphorIconsRegular.pencilSimple,
                    iconColor: AppColors.primary,
                    rotation: -0.012, // -0.7 deg
                    tapeColor: AppColors.primary.withOpacity(0.15),
                    onTap: () => Navigator.pop(context, 'post'),
                  ),
                  const SizedBox(height: 24),
                  _CreateOptionCard(
                    title: 'Kitchen Recipe',
                    subtitle: 'Share your favorite cooking recipe',
                    icon: PhosphorIconsRegular.cookingPot,
                    iconColor: kAccentOrange,
                    rotation: 0.014, // 0.8 deg
                    tagText: 'RECIPE',
                    tagColor: kAccentOrange,
                    onTap: () => Navigator.pop(context, 'recipe'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (action == 'post') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
      );
      if (result == true) {
        ref.read(communityControllerProvider.notifier).setFilter('All Posts');
      }
    } else if (action == 'recipe') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateRecipeScreen()),
      );
      if (result == true) {
        // Change filter to Kitchen Recipes and refresh
        setState(() => _selectedFilter = 'Kitchen Recipes');
        ref.read(recipeControllerProvider.notifier).refresh();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_showScrollUp)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton(
                heroTag: 'scroll_up_fab',
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  _scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                },
                child: const Icon(Icons.arrow_upward, color: kDarkGreen),
              ),
            ),
          FloatingActionButton.extended(
            heroTag: 'create_post_fab',
            backgroundColor: AppColors.primary,
            onPressed: _openCreatePost,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              'Create Post',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(communityControllerProvider);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Filters
              SliverPersistentHeader(
                pinned: true,
                delegate: PillTabBarDelegate(
                  child: PillTabBar(
                    tabs: _filters.map((f) => PillTabItem(name: f)).toList(),
                    selectedIndex: _filters.indexOf(_selectedFilter),
                    onTabSelected: (index) {
                      _onFilterSelected(_filters[index]);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
              ),

              // Posts List or Recipes List
              _selectedFilter == 'Kitchen Recipes'
                  ? _buildRecipesList(ref)
                  : _buildPostsList(state, currentUserId),

              // Bottom padding for nav bar
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsList(CommunityState state, String? currentUserId) {
    return state.maybeWhen(
      data: (response) {
        if (response.data.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('No posts found')),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final post = response.data[index];
              return _buildPostCard(post, currentUserId);
            },
            childCount: response.data.length,
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (msg) => SliverFillRemaining(
        child: Center(child: Text('Error: $msg')),
      ),
      orElse: () => const SliverFillRemaining(child: SizedBox()),
    );
  }

  Widget _buildRecipesList(WidgetRef ref) {
    final recipeState = ref.watch(recipeControllerProvider);

    return recipeState.maybeWhen(
      data: (response) {
        if (response.data.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('No recipes found')),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recipe = response.data[index];
                return _buildRecipeCard(recipe);
              },
              childCount: response.data.length,
            ),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (msg) => SliverFillRemaining(
        child: Center(child: Text('Error: $msg')),
      ),
      orElse: () => const SliverFillRemaining(child: SizedBox()),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Image.network(
                  recipe.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.restaurant,
                      color: Colors.grey,
                      size: 32),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 12, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.prepTimeMinutes + recipe.cookTimeMinutes}m',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: recipe.author.avatarUrl != null
                            ? NetworkImage(recipe.author.avatarUrl!)
                            : null,
                        child: recipe.author.avatarUrl == null
                            ? const Icon(Icons.person,
                                size: 12, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          recipe.author.name,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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

  void _deletePost(CommunityPost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog
              try {
                await ref.read(communityControllerProvider.notifier).deletePost(post.id);
              } catch (e) {
                // handle error silently
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editPost(CommunityPost post) {
    final titleController = TextEditingController(text: post.title);
    final contentController = TextEditingController(text: post.content);

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
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              final newTitle = titleController.text.trim();
              final newContent = contentController.text.trim();
              if (newTitle.isNotEmpty && newContent.isNotEmpty) {
                Navigator.pop(context);
                try {
                  await ref.read(communityControllerProvider.notifier).editPost(post.id, newTitle, newContent);
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



  Widget _buildPostCard(CommunityPost post, String? currentUserId) {
    final isMyPost = post.userId == currentUserId;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommunityPostDetailScreen(post: post)),
        );
      },
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
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: post.user.avatarUrl != null
                      ? NetworkImage(post.user.avatarUrl!)
                      : null,
                  child: post.user.avatarUrl == null
                      ? Icon(Icons.person_outline, color: Colors.grey.shade500)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user.name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _formatDate(post.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isMyPost)
                  PopupMenuButton<String>(
                    icon: PhosphorIcon(PhosphorIconsRegular.dotsThree, color: Colors.grey.shade600),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editPost(post);
                      } else if (value == 'delete') {
                        _deletePost(post);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: const [
                            PhosphorIcon(PhosphorIconsRegular.pencilSimple, size: 20),
                            SizedBox(width: 12),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: const [
                            PhosphorIcon(PhosphorIconsRegular.trash, size: 20, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.dotsThree, color: Colors.transparent),
                    onPressed: null,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              post.title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Content
            Text(
              post.content,
              style: GoogleFonts.inter(
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
                          style: GoogleFonts.inter(
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
                  onTap: () {
                    ref
                        .read(communityControllerProvider.notifier)
                        .toggleLike(post.id, post.isLikedByUser);
                  },
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
                        style: GoogleFonts.inter(
                          color: post.isLikedByUser
                              ? const Color(0xFFDC2626)
                              : Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 20, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      '${post.commentsCount}',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateOptionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final double rotation;
  final Color? tapeColor;
  final String? tagText;
  final Color? tagColor;
  final VoidCallback onTap;

  const _CreateOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.rotation,
    this.tapeColor,
    this.tagText,
    this.tagColor,
    required this.onTap,
  });

  @override
  State<_CreateOptionCard> createState() => _CreateOptionCardState();
}

class _CreateOptionCardState extends State<_CreateOptionCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _isActive => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          transformAlignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(0.0, _isActive ? -5.0 : 0.0)
            ..rotateZ(_isActive ? 0.0 : widget.rotation),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.iconColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            widget.title,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: Colors.grey.shade600,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.tapeColor != null)
                Positioned(
                  top: -8,
                  left: 48,
                  child: Transform.rotate(
                    angle: -0.12, // -7 deg
                    child: Container(
                      width: 46,
                      height: 16,
                      decoration: BoxDecoration(
                        color: widget.tapeColor,
                        border: Border.all(color: widget.tapeColor!.withOpacity(0.5)),
                      ),
                    ),
                  ),
                ),
              if (widget.tagText != null && widget.tagColor != null)
                Positioned(
                  top: -10,
                  right: 14,
                  child: Transform.rotate(
                    angle: 0.1, // 6 deg
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.tagColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.tagText!,
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
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
}
