import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/features/community/domain/entities/community_post.dart';
import 'package:harvest_app/features/community/presentation/providers/community_controller.dart';
import 'package:intl/intl.dart';
import 'create_post_screen.dart';
import 'community_post_detail_screen.dart';

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyHeaderDelegate({required this.child, this.height = 40.0});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8),
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF166534);
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostScreen()),
    );
    if (result == true) {
      ref.read(communityControllerProvider.notifier).setFilter('All Posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _showScrollUp
          ? FloatingActionButton(
              mini: true,
              backgroundColor: const Color(0xFF166534),
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search in community...',
                          hintStyle: GoogleFonts.inter(
                              color: Colors.grey.shade500, fontSize: 15),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xFF166534)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _openCreatePost,
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF166534),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filters
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        showCheckmark: false,
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => _onFilterSelected(filter),
                        selectedColor: kPrimaryGreen,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? kPrimaryGreen
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(
                child: Divider(height: 1, color: Color(0xFFE5E7EB))),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Tags
            SliverToBoxAdapter(
              child: SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _tags.length,
                  itemBuilder: (context, index) {
                    final tag = _tags[index];
                    final isSelected = _selectedTag == tag.replaceAll('#', '');
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        label: Text(tag),
                        onPressed: () => _onTagSelected(tag),
                        backgroundColor: isSelected ? const Color(0xFF166534) : Colors.white,
                        labelStyle: GoogleFonts.inter(
                          color: isSelected ? Colors.white : const Color(0xFF166534),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: isSelected ? const Color(0xFF166534) : Colors.grey.shade300),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Posts List
            state.maybeWhen(
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
                      return _buildPostCard(post);
                    },
                    childCount: response.data.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(
                    child: CircularProgressIndicator(color: kPrimaryGreen)),
              ),
              error: (msg) => SliverFillRemaining(
                child: Center(child: Text('Error: \$msg')),
              ),
              orElse: () => const SliverFillRemaining(child: SizedBox()),
            ),

            // Bottom padding for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
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
                        DateFormat('M/d/yyyy').format(post.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  color: Colors.grey.shade600,
                  onPressed: () {},
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
                            color: kPrimaryGreen,
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
                const SizedBox(width: 16),
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
