import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../domain/entities/farmer.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/review.dart';
import '../../../../domain/entities/community_post.dart';
import '../../farmer_detail/providers/farmer_detail_controller.dart';

// --- DESIGN CONSTANTS (Self-contained for this file) ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(farmerDetailControllerProvider(widget.farmer.id));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. PARALLAX HEADER
          SliverPersistentHeader(
            pinned: true,
            delegate: FarmerProfileHeaderDelegate(
              farmer: widget.farmer,
              onBackPressed: () => context.pop(),
              onSharePressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Share functionality coming soon')),
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
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
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
                unselectedLabelColor: kTextGrey,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: kDarkGreen,
                ),
                labelStyle: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                tabs: const [
                  Tab(text: 'Shop'),
                  Tab(text: 'Feed'),
                  Tab(text: 'Info'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),

          // 4. SCROLLABLE TAB CONTENT
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsTab(state.products),
                _buildCommunityTab(state.posts),
                _buildAboutTab(),
                _buildReviewsTab(state.reviews),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: kPillGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Products', '0'),
          Container(width: 1, height: 30, color: Colors.grey[300]),
          _buildStatItem('Rating', widget.farmer.rating.toStringAsFixed(1)),
          Container(width: 1, height: 30, color: Colors.grey[300]),
          _buildStatItem('Reviews', '0'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: kTextGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              // Handle Message Logic
            },
            icon: const Icon(
              Icons.chat_bubble_outline,
              size: 18,
              color: Colors.white,
            ),
            label: const Text('Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
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
            child: const Icon(Icons.directions_outlined, color: kDarkGreen),
          ),
        ),
      ],
    );
  }

  // --- TABS CONTENT ---

  Widget _buildProductsTab(AsyncValue<List<Product>> productsState) {
    return productsState.when(
      loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (products) {
        if (products.isEmpty) {
          return Center(child: Text('No products available', style: GoogleFonts.dmSans(color: kTextGrey)));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(20)),
                        image: product.imageUrl.isNotEmpty && product.imageUrl.startsWith('http') ? DecorationImage(
                          image: CachedNetworkImageProvider(product.imageUrl),
                          fit: BoxFit.cover,
                        ) : null,
                      ),
                      child: product.imageUrl.isEmpty || !product.imageUrl.startsWith('http') ? Center(
                        child: Icon(Icons.shopping_bag_outlined,
                            size: 40, color: kDarkGreen.withOpacity(0.2)),
                      ) : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold, color: kDarkGreen),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Rp ${product.price}',
                          style: GoogleFonts.dmSans(
                              color: kAccentOrange, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommunityTab(AsyncValue<List<CommunityPost>> postsState) {
    return postsState.when(
      loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (posts) {
        if (posts.isEmpty) {
          return Center(child: Text('No posts yet', style: GoogleFonts.dmSans(color: kTextGrey)));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 24),
          itemBuilder: (context, index) {
            final post = posts[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: widget.farmer.profileImage != null && widget.farmer.profileImage!.startsWith('http')
                            ? CachedNetworkImageProvider(widget.farmer.profileImage!)
                            : null,
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.farmer.name,
                              style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold, color: kDarkGreen)),
                          Text(post.createdAt.toString().split(' ')[0],
                              style: GoogleFonts.dmSans(
                                  fontSize: 12, color: kTextGrey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.content,
                    style: GoogleFonts.dmSans(color: kDarkGreen, height: 1.5),
                  ),
                  if (post.images.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius: BorderRadius.circular(12),
                        image: post.images.first.startsWith('http') ? DecorationImage(
                          image: CachedNetworkImageProvider(post.images.first),
                          fit: BoxFit.cover,
                        ) : null,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About the Farmer',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.farmer.description,
            style: GoogleFonts.dmSans(
              color: kTextGrey,
              height: 1.6,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Specialties',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.farmer.specialties
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s,
                        style: GoogleFonts.dmSans(
                            color: kDarkGreen, fontWeight: FontWeight.w500),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Contact Info',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 16),

          const SizedBox(height: 12),
          _buildContactRow(Icons.location_on_outlined, widget.farmer.address),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: kAccentOrange),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(color: kDarkGreen, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab(AsyncValue<List<Review>> reviewsState) {
    return reviewsState.when(
      loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (reviews) {
        if (reviews.isEmpty) {
          return Center(child: Text('No reviews yet', style: GoogleFonts.dmSans(color: kTextGrey)));
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
                      backgroundImage: review.userAvatar != null && review.userAvatar!.startsWith('http')
                        ? CachedNetworkImageProvider(review.userAvatar!)
                        : null,
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review.userName,
                            style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.bold, color: kDarkGreen)),
                        Row(
                          children: List.generate(
                              5,
                              (i) => Icon(
                                    i < review.rating
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 14,
                                    color: Colors.amber,
                                  )),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(review.createdAt.toString().split(' ')[0],
                        style: GoogleFonts.dmSans(fontSize: 12, color: kTextGrey)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.comment,
                  style: GoogleFonts.dmSans(color: kTextGrey, height: 1.4),
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

  final bottomHeight = 160.0;
  final profileRadius = 55.0;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    final imageTop = -shrinkOffset * 0.5;
    final double opacity = (1 - (shrinkOffset / 150)).clamp(0, 1);

    return Container(
      color: Colors.white,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover Image
          Positioned(
            top: imageTop,
            left: 0,
            right: 0,
            height: maxExtent - bottomHeight + 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: farmer.coverImage ?? '',
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: kPillGrey),
                  errorWidget: (_, __, ___) => Container(color: kPillGrey),
                ),
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
            top: maxExtent - bottomHeight - 20,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Opacity(
                  opacity: opacity,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            farmer.name,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: kDarkGreen,
                            ),
                          ),
                          if (farmer.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified,
                                color: Colors.blue, size: 20),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: kTextGrey),
                          const SizedBox(width: 4),
                          Text(
                            '${farmer.city} • ${farmer.distanceLabel}',
                            style: GoogleFonts.dmSans(
                                color: kTextGrey, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Avatar
          Positioned(
            top: maxExtent - bottomHeight - 20 - profileRadius,
            left: MediaQuery.of(context).size.width / 2 - profileRadius,
            child: Transform.scale(
              scale: (1 - shrinkOffset / 300).clamp(0.5, 1.0),
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
                child: CircleAvatar(
                  radius: profileRadius,
                  backgroundColor: kPillGrey,
                  backgroundImage:
                      CachedNetworkImageProvider(farmer.profileImage ?? ''),
                  onBackgroundImageError: (_, __) {},
                ),
              ),
            ),
          ),

          // Actions
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
            child: Row(
              children: [
                _buildGlassButton(Icons.arrow_back, onBackPressed),
                const Spacer(),
                _buildGlassButton(Icons.share_outlined, onSharePressed),
                const SizedBox(width: 8),
                _buildGlassButton(Icons.more_vert, onMorePressed),
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
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 8),
            ]),
        child: Icon(icon, color: kDarkGreen, size: 20),
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
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) => false;
}
