import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';
import 'package:harvest_app/features/community/presentation/providers/community_controller.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/features/community/presentation/providers/community_state.dart';
import 'package:harvest_app/features/community/presentation/screens/conversations_list_screen.dart';
import 'package:harvest_app/features/community/presentation/providers/recipe_controller.dart';
import 'package:harvest_app/core/widgets/community_post_card.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import 'package:intl/intl.dart';
import 'create_post_screen.dart';
import 'create_recipe_screen.dart';
import 'community_post_detail_screen.dart';
import 'recipe_detail_screen.dart';
import 'package:harvest_app/features/auth/domain/entities/user.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/core/widgets/pill_tab_bar.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);

final communityTabProvider = StateProvider<String>((ref) => 'All Posts');

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

      // Infinite scroll trigger
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final filter = ref.read(communityTabProvider);
        if (filter == 'Kitchen Recipes' || filter == 'My Recipes') {
          ref.read(recipeControllerProvider.notifier).loadNextPage();
        } else {
          ref.read(communityControllerProvider.notifier).loadNextPage();
        }
      }
    });
  }

  final List<String> _filters = [
    'All Posts',
    'Kitchen Recipes',
    'My Recipes',
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
    ref.read(communityTabProvider.notifier).state = filter;

    if (filter != 'Kitchen Recipes' && filter != 'My Recipes') {
      ref.read(communityControllerProvider.notifier).setFilter(filter);
    }
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

  String? _getValidImageUrl(String? url) {
    if (url == null || url.trim().isEmpty || !url.startsWith('http'))
      return null;
    return url;
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
    final selectedFilter = ref.watch(communityTabProvider);
    final state = ref.watch(communityControllerProvider);
    final authState = ref.watch(authControllerProvider);
    final currentUserId = authState.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );
    final currentUserName = authState.maybeWhen(
      authenticated: (user) => user.name,
      orElse: () => null,
    );
    final isProducer = authState.maybeWhen(
      authenticated: (user) => user.userType == UserType.farmer,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isProducer
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              scrolledUnderElevation: 0,
              iconTheme: const IconThemeData(color: kDarkGreen),
              title: Text(
                'Community',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: kDarkGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: -0.5,
                    ),
              ),
            )
          : null,
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
            label: const Text(
              'Create',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: WebConstrainedBox(
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              if (selectedFilter == 'Kitchen Recipes') {
                ref
                    .read(recipeControllerProvider.notifier)
                    .refresh(authorId: null);
              } else if (selectedFilter == 'My Recipes') {
                ref
                    .read(recipeControllerProvider.notifier)
                    .refresh(authorId: currentUserId);
              } else {
                ref.invalidate(communityControllerProvider);
              }
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
                      selectedIndex: _filters.indexOf(selectedFilter),
                      onTabSelected: (index) {
                        _onFilterSelected(_filters[index]);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                ),

                // Posts List or Recipes List
                (selectedFilter == 'Kitchen Recipes' ||
                        selectedFilter == 'My Recipes')
                    ? _buildRecipesList(ref, currentUserId, currentUserName)
                    : _buildPostsList(state, currentUserId, currentUserName, selectedFilter),

                // Bottom padding for nav bar
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostsList(CommunityState state, String? currentUserId, String? currentUserName, String selectedFilter) {
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
              return _buildPostCard(post, currentUserId, currentUserName, selectedFilter);
            },
            childCount: response.data.length,
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (msg) => SliverFillRemaining(
        child: Center(child: Text('Error: $msg')),
      ),
      orElse: () => const SliverFillRemaining(child: SizedBox()),
    );
  }

  Widget _buildRecipesList(WidgetRef ref, String? currentUserId, String? currentUserName) {
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
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recipe = response.data[index];
                return _buildRecipeCard(recipe, currentUserId, currentUserName);
              },
              childCount: response.data.length,
            ),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child:
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
      ),
      error: (msg) => SliverFillRemaining(
        child: Center(child: Text('Error: $msg')),
      ),
      orElse: () => const SliverFillRemaining(child: SizedBox()),
    );
  }

  Widget _buildRecipeCard(Recipe recipe, String? currentUserId, String? currentUserName) {
    final isMyRecipe = (currentUserId != null && (recipe.authorId == currentUserId || recipe.author.id == currentUserId)) ||
                       (currentUserName != null && recipe.author.name == currentUserName);
                       
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
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade100,
                    child: Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.restaurant,
                        color: Colors.grey,
                        size: 32,
                      ),
                    ),
                  ),
                  if (isMyRecipe)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white, size: 20),
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editRecipe(recipe);
                            } else if (value == 'delete') {
                              _deleteRecipe(recipe);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: TextStyle(
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
                        style: TextStyle(
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
                          style: TextStyle(
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
            child:
                const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog
              try {
                await ref
                    .read(communityControllerProvider.notifier)
                    .deletePost(post.id);
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
                      .editPost(post.id, newTitle, newContent);
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

  void _deleteRecipe(Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(recipeControllerProvider.notifier)
                    .deleteRecipe(recipe.id);
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

  Future<void> _editRecipe(Recipe recipe) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateRecipeScreen(recipeToEdit: recipe)),
    );
    if (result == true) {
      ref.read(recipeControllerProvider.notifier).refresh();
    }
  }

  Widget _buildPostCard(
      CommunityPost post, String? currentUserId, String? currentUserName, String selectedFilter) {
    return CommunityPostCard(
      post: post,
      currentUserId: currentUserId,
      currentUserName: currentUserName,
      showFarmerBadge:
          selectedFilter == 'All Posts' || selectedFilter == 'My Posts',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommunityPostDetailScreen(post: post)),
        );
      },
      onProfileTap: () {
        if (post.farmer != null) {
          context.push(
            AppRouter.farmerDetail,
            extra: Farmer(
              id: post.farmer!.id,
              userId: post.userId,
              name: post.farmer!.name,
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
              profileImage: post.farmer!.profileImage,
            ),
          );
        }
      },
      onLikeToggle: () {
        ref
            .read(communityControllerProvider.notifier)
            .toggleLike(post.id, post.isLikedByUser);
      },
      onEdit: () {
        _editPost(post);
      },
      onDelete: () {
        _deletePost(post);
      },
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: TextStyle(
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
                        border: Border.all(
                            color: widget.tapeColor!.withOpacity(0.5)),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
