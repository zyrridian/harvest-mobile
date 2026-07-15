import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../domain/entities/farmer.dart';
import '../../../catalog/domain/entities/product.dart';
import '../../../../presentation/shared_widgets/product_card.dart';
import '../../../../presentation/shared_widgets/community_post_card.dart';
import '../../../community/domain/entities/review.dart';
import '../../../community/domain/entities/community_post.dart';
import '../../../community/presentation/screens/image_viewer_screen.dart';
import '../../../../core/config/router/app_router.dart';
import '../providers/farmer_detail_controller.dart';
import '../../../../presentation/providers/messaging_providers.dart';

// --- DESIGN CONSTANTS (Self-contained for this file) ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);

class FarmerDetailScreen extends ConsumerStatefulWidget {
  final Farmer farmer;

  const FarmerDetailScreen({
    super.key,
    required this.farmer,
  });

  @override
  ConsumerState<FarmerDetailScreen> createState() => _FarmerDetailScreenState();
}

class _FarmerDetailScreenState extends ConsumerState<FarmerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(farmerDetailControllerProvider(widget.farmer.id));
    final displayFarmer = state.farmerDetail.value ?? widget.farmer;

    return Scaffold(
      backgroundColor: kBgColor,
      body: RefreshIndicator(
        color: kDarkGreen,
        onRefresh: () async {
          await ref
              .read(farmerDetailControllerProvider(widget.farmer.id).notifier)
              .loadFarmerProfile();
        },
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 1. PARALLAX HEADER
              SliverPersistentHeader(
                pinned: true,
                delegate: FarmerProfileHeaderDelegate(
                  farmer: displayFarmer,
                  onBackPressed: () => context.pop(),
                  onSharePressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Share functionality coming soon',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white)),
                      ),
                    );
                  },
                  onMorePressed: () {
                    // Show bottom sheet or menu
                  },
                ),
              ),

              // 2. STATS & ACTIONS (Non-sticky content)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _buildStatsRow(displayFarmer),
                      const SizedBox(height: 24),
                      _buildActionButtons(displayFarmer),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // 3. STICKY TAB BAR
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kDarkGreen,
                    ),
                    labelStyle:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    onTap: (index) {
                      _tabController.index =
                          index; // Instant switch without scrolling
                    },
                    tabs: const [
                      Tab(text: 'Shop'),
                      Tab(text: 'Feed'),
                      Tab(text: 'Gallery'),
                      Tab(text: 'Info'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
              ),
            ];
          },
          // 4. SCROLLABLE TAB CONTENT
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildProductsTab(state.products),
              _buildCommunityTab(state.posts),
              _buildGalleryTab(displayFarmer),
              _buildAboutTab(displayFarmer),
              _buildReviewsTab(state.reviews),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildStatsRow(Farmer displayFarmer) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: kPillGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Products', displayFarmer.totalProducts.toString()),
          Container(width: 1, height: 30, color: Colors.grey[300]),
          _buildStatItem('Rating', displayFarmer.rating.toStringAsFixed(1)),
          Container(width: 1, height: 30, color: Colors.grey[300]),
          _buildStatItem(
              'Followers', displayFarmer.followersCount?.toString() ?? '0'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kTextGreen,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Farmer displayFarmer) {
    final isFollowed = displayFarmer.isFollowed;
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              ref
                  .read(
                      farmerDetailControllerProvider(widget.farmer.id).notifier)
                  .toggleFollow();
            },
            icon: PhosphorIcon(
              isFollowed
                  ? PhosphorIconsFill.checkCircle
                  : PhosphorIconsRegular.userPlus,
              size: 18,
              color: isFollowed ? kDarkGreen : Colors.white,
            ),
            label: Text(isFollowed ? 'Following' : 'Follow',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isFollowed ? kDarkGreen : Colors.white,
                    fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowed ? kPillGrey : kDarkGreen,
              foregroundColor: isFollowed ? kDarkGreen : Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: OutlinedButton.icon(
            onPressed: () async {
              final startConversation =
                  ref.read(startConversationUsecaseProvider);
              final result = await startConversation(
                recipientId: displayFarmer.userId,
                type: 'general',
              );
              result.fold(
                (failure) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not open chat: ${failure.message}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white)),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                (data) {
                  final convId = data['data']?['conversation_id'] as String? ??
                      'conv_1234567890abcdef';
                  if (context.mounted) {
                    context.push(
                      AppRouter.chat,
                      extra: {
                        'conversationId': convId,
                        'farmerName': displayFarmer.name,
                        'farmerAvatar': displayFarmer.profileImage,
                      },
                    );
                  }
                },
              );
            },
            icon: const PhosphorIcon(
              PhosphorIconsRegular.chatCircle,
              size: 18,
              color: kDarkGreen,
            ),
            label: Text('Message',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: kDarkGreen, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: kPillGrey, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {
              // Handle Directions Logic
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: kPillGrey, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const PhosphorIcon(PhosphorIconsRegular.mapTrifold,
                color: kDarkGreen),
          ),
        ),
      ],
    );
  }

  // --- TABS CONTENT ---

  Widget _buildProductsTab(AsyncValue<List<Product>> productsState) {
    return productsState.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (error, _) => Center(
          child: Text('Error: $error',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red))),
      data: (products) {
        if (products.isEmpty) {
          return Center(
              child: Text('No products available',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600])));
        }
        return GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              id: product.id,
              name: product.name,
              price: product.price,
              imageUrl: product.imageUrl,
              unit: product.unit,
              rating: product.rating,
              soldCount:
                  product.reviewCount, // Or sold count if available on product
              isFresh: product.isOrganic,
              isFavorite: product.isFavorite,
              farmerName: null,
              onTap: () {
                context.push('/products/${product.id}');
              },
              onAddToCart: () {
                ref
                    .read(farmerDetailControllerProvider(widget.farmer.id)
                        .notifier)
                    .addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product.name} added to cart')),
                );
              },
              onFavoriteToggle: () {
                ref
                    .read(farmerDetailControllerProvider(widget.farmer.id)
                        .notifier)
                    .toggleFavorite(product);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCommunityTab(AsyncValue<List<CommunityPost>> postsState) {
    return postsState.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (error, _) => Center(
          child: Text('Error: $error',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red))),
      data: (posts) {
        if (posts.isEmpty) {
          return Center(
              child: Text('No posts yet',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600])));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(0),
          itemCount: posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final post = posts[index];
            final displayPost = post.farmer != null
                ? post
                : CommunityPost(
                    id: post.id,
                    userId: post.userId,
                    farmerId: post.farmerId,
                    title: post.title,
                    content: post.content,
                    likesCount: post.likesCount,
                    commentsCount: post.commentsCount,
                    createdAt: post.createdAt,
                    updatedAt: post.updatedAt,
                    user: post.user,
                    farmer: CommunityFarmer(
                      id: widget.farmer.id,
                      name: widget.farmer.name,
                      profileImage: widget.farmer.profileImage,
                    ),
                    images: post.images,
                    tags: post.tags,
                    isLikedByUser: post.isLikedByUser,
                  );

            return CommunityPostCard(
              post: displayPost,
              profileImageUrl: displayPost.farmer?.profileImage,
              currentUserId:
                  null, // Since we don't have current user readily available here, or we could pass it if we have it
              onTap: () {
                context.push('/community/post/${displayPost.id}',
                    extra: displayPost);
              },
              onProfileTap: () {},
              onLikeToggle: () {
                ref
                    .read(farmerDetailControllerProvider(widget.farmer.id)
                        .notifier)
                    .toggleLike(post.id, post.isLikedByUser);
              },
              onEdit: () {},
              onDelete: () {},
            );
          },
        );
      },
    );
  }

  Widget _buildAboutTab(Farmer displayFarmer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the Farmer',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kTextGreen,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            displayFarmer.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  height: 1.6,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: 32),
          Text(
            'Specialties',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kTextGreen,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: displayFarmer.specialties
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: kTextGreen, fontWeight: FontWeight.w500),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Contact Info',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kTextGreen,
                ),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 12),
          _buildContactRow(PhosphorIconsRegular.mapPin, displayFarmer.address),
        ],
      ),
    );
  }

  Widget _buildGalleryTab(Farmer displayFarmer) {
    if (displayFarmer.gallery.isEmpty) {
      return Center(
        child: Text('No gallery images available',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[600])),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: displayFarmer.gallery.length,
      itemBuilder: (context, index) {
        final image = displayFarmer.gallery[index];
        return GestureDetector(
          onTap: () {
            context.push(
              '/image-viewer',
              extra: {
                'imageUrl': image.imageUrl,
                'tag': 'gallery_${image.id}',
              },
            );
          },
          child: Hero(
            tag: 'gallery_${image.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: image.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: kPillGrey,
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: kDarkGreen, strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: kPillGrey,
                  child: const Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        PhosphorIcon(icon, size: 20, color: kAccentOrange),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: kTextGreen, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab(AsyncValue<List<Review>> reviewsState) {
    return reviewsState.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (error, _) => Center(
          child: Text('Error: $error',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red))),
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(
              child: Text('No reviews yet',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600])));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: kPillGrey),
          ),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: kPillGrey,
                      backgroundImage: review.userAvatar != null &&
                              review.userAvatar!.startsWith('http')
                          ? CachedNetworkImageProvider(review.userAvatar!)
                          : null,
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.userName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kTextGreen)),
                        Row(
                          children: List.generate(
                              5,
                              (i) => PhosphorIcon(
                                    i < review.rating
                                        ? PhosphorIconsFill.star
                                        : PhosphorIconsRegular.star,
                                    size: 14,
                                    color: Colors.amber,
                                  )),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(review.createdAt.toString().split(' ')[0],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.comment,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600], height: 1.4),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// --- DELEGATES ---

class FarmerProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Farmer farmer;
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onMorePressed;

  FarmerProfileHeaderDelegate({
    required this.farmer,
    required this.onBackPressed,
    required this.onSharePressed,
    required this.onMorePressed,
  });

  final double bottomHeight = 160.0;
  final double profileRadius = 55.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Progress goes from 0.0 (fully expanded) to 1.0 (fully collapsed)
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final expandedOpacity =
        (1.0 - progress * 1.5).clamp(0.0, 1.0); // Fades out slightly faster
    final collapsedOpacity =
        (progress * 2.0 - 1.0).clamp(0.0, 1.0); // Fades in during second half

    return Container(
      color: kBgColor, // Solid background for collapsed app bar
      child: Stack(
        clipBehavior: Clip.hardEdge,
        fit: StackFit.expand,
        children: [
          // --- EXPANDED STATE ---
          if (expandedOpacity > 0)
            Opacity(
              opacity: expandedOpacity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover Image
                  Positioned(
                    top: -shrinkOffset * 0.5,
                    left: 0,
                    right: 0,
                    height: maxExtent - bottomHeight + 60,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (farmer.coverImage != null &&
                            farmer.coverImage!.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              context.push(
                                AppRouter.imageViewer,
                                extra: {
                                  'heroTag': 'farmer_cover_${farmer.id}',
                                  'imageUrl': farmer.coverImage!,
                                },
                              );
                            },
                            child: Hero(
                              tag: 'farmer_cover_${farmer.id}',
                              child: CachedNetworkImage(
                                imageUrl: farmer.coverImage!,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: kPillGrey),
                                errorWidget: (_, __, ___) =>
                                    Container(color: kPillGrey),
                              ),
                            ),
                          )
                        else
                          Container(color: kPillGrey),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black26, Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Curved Body
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: bottomHeight + 20,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kBgColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  farmer.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: kTextGreen,
                                      ),
                                ),
                                if (farmer.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const PhosphorIcon(
                                      PhosphorIconsFill.sealCheck,
                                      color: Colors.blue,
                                      size: 20),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PhosphorIcon(PhosphorIconsRegular.mapPin,
                                    size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  '${farmer.city} • ${farmer.distanceLabel}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Colors.grey[600],
                                          fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Avatar
                  Positioned(
                    bottom: bottomHeight + 20 - profileRadius,
                    left: MediaQuery.of(context).size.width / 2 - profileRadius,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 5)),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (farmer.profileImage != null &&
                              farmer.profileImage!.isNotEmpty) {
                            context.push(
                              AppRouter.imageViewer,
                              extra: {
                                'heroTag': 'farmer_profile_${farmer.id}',
                                'imageUrl': farmer.profileImage!,
                              },
                            );
                          }
                        },
                        child: Hero(
                          tag: 'farmer_profile_${farmer.id}',
                          child: CircleAvatar(
                            radius: profileRadius,
                            backgroundColor: kPillGrey,
                            backgroundImage: CachedNetworkImageProvider(
                                farmer.profileImage ?? ''),
                            onBackgroundImageError: (_, __) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // --- COLLAPSED STATE (App Bar Title) ---
          if (collapsedOpacity > 0)
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 60, // Leave room for back button
              right: 60, // Leave room for actions
              bottom: 0,
              child: Center(
                child: Opacity(
                  opacity: collapsedOpacity,
                  child: Text(
                    farmer.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kTextGreen,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

          // --- ACTIONS (Always visible) ---
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            child: Row(
              children: [
                _buildGlassButton(
                    PhosphorIconsRegular.caretLeft, onBackPressed),
                const Spacer(),
                _buildGlassButton(
                    PhosphorIconsRegular.shareNetwork, onSharePressed),
                const SizedBox(width: 8),
                _buildGlassButton(
                    PhosphorIconsRegular.dotsThreeVertical, onMorePressed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8),
            ]),
        child: PhosphorIcon(icon, color: kDarkGreen, size: 20),
      ),
    );
  }

  @override
  double get maxExtent => 340.0;
  @override
  double get minExtent => 100.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _StickyTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height + 16;
  @override
  double get maxExtent => _tabBar.preferredSize.height + 16;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: kBgColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
