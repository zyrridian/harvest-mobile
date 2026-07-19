import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/features/storefront/domain/entities/home.dart';
import 'package:harvest_app/features/catalog/presentation/screens/search/search_screen.dart';
import 'package:harvest_app/features/catalog/presentation/screens/category/category_screen.dart';
import 'package:harvest_app/features/storefront/presentation/providers/home_controller.dart';
import 'package:harvest_app/features/storefront/presentation/widgets/greeting_location_bar.dart';
import 'package:harvest_app/features/storefront/presentation/widgets/promo_carousel.dart';
import 'package:harvest_app/features/storefront/presentation/widgets/quick_action_grid.dart';
import 'package:harvest_app/features/community/presentation/screens/conversations_list_screen.dart';
import 'package:harvest_app/features/sales/presentation/screens/orders/orders_list_screen.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// ─── Design Tokens ───────────────────────────────────────────────────────────
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kFreshGreen = Color(0xFF10B981);
const kPreOrderBlue = Color(0xFF3B82F6);
const kSage = Color(0xFF7C9070);
const kSand = Color(0xFFF0EAD6);

// ─── Home Screen ──────────────────────────────────────────────────────────────
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).refresh();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(homeControllerProvider.notifier).refresh();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      body: homeState.maybeWhen(
        data: (homeData) {
          return _buildContent(
            homeData.activeOrder,
            homeData.farmerUpdates,
            homeData.weeklyStaples,
          );
        },
        error: (message) => Center(child: Text(message)),
        orElse: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      ),
    );
  }

  Widget _buildContent(
    HomeActiveOrder? activeOrder,
    List<HomeFarmerUpdate> farmerUpdates,
    List<HomeWeeklyStaple> weeklyStaples,
  ) {
    return RefreshIndicator(
      color: kDarkGreen,
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        slivers: [
          // ── 1. HEADER ─────────────────────────────────────────────────────
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: kBgColor,
            surfaceTintColor: kBgColor,
            elevation: 0,
            toolbarHeight: 72,
            titleSpacing: 24.0,
            title: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomPaint(
                        size: const Size(20, 20),
                        painter: _WheatMarkPainter(color: kDarkGreen),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Harvest',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: kDarkGreen,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                  _iconBtn(
                    icon: PhosphorIconsRegular.bell,
                    hasDot: true,
                    onTap: () => context.push(AppRouter.notifications),
                  ),
                ],
              ),
            ),
          ),

          // // ── 2. SEARCH BAR ─────────────────────────────────────────────────
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          //     child: GestureDetector(
          //       onTap: () => Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const SearchScreen()),
          //       ),
          //       child: Container(
          //         height: 52,
          //         decoration: BoxDecoration(
          //           color: kPillGrey,
          //           borderRadius: BorderRadius.circular(16),
          //         ),
          //         child: Row(
          //           children: [
          //             const SizedBox(width: 16),
          //             PhosphorIcon(PhosphorIconsRegular.search_rounded,
          //                 color: Colors.grey[500], size: 22),
          //             const SizedBox(width: 10),
          //             Expanded(
          //               child: Text(
          //                 'Search fresh products, farmers...',
          //                 style: TextStyle(
          //                   color: Colors.grey[500],
          //                   fontSize: 14,
          //                 ),
          //               ),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.only(right: 6),
          //               padding: const EdgeInsets.all(8),
          //               decoration: BoxDecoration(
          //                 color: kDarkGreen,
          //                 borderRadius: BorderRadius.circular(10),
          //               ),
          //               child: const PhosphorIcon(PhosphorIconsRegular.tune_rounded,
          //                   color: Colors.white, size: 18),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // ── 5. PROMO CAROUSEL ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: HarvestPromoBanner(
              eyebrow: 'Hot deal',
              title: 'Pre-order & save',
              subtitle: 'Reserve harvest early and save up to 20%',
              onTap: () {},
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // // ── 3. GREETING + LOCATION ────────────────────────────────────────
          // SliverToBoxAdapter(
          //   child: GreetingLocationBar(
          //     locationName: 'Bandung',
          //     onLocationTap: () => context.push(AppRouter.addresses),
          //   ),
          // ),

          // ── 4. QUICK ACTIONS GRID ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('Our Services', showSeeAll: false),
                  // const SizedBox(height: 16),
                  QuickActionGrid(
                    actions: [
                      QuickAction(
                        label: 'Marketplace',
                        iconPath: 'assets/icons/ic_marketplace.svg',
                        onTap: () => context.push(AppRouter.products),
                      ),
                      QuickAction(
                        label: 'Pre-Order',
                        iconPath: 'assets/icons/ic_preorder.svg',
                        badge: 'NEW',
                        isNewBadge: true,
                        onTap: () => context.push(AppRouter.preorder),
                      ),
                      QuickAction(
                        label: 'Harvest Schedule',
                        iconPath: 'assets/icons/ic_harvest_schedule.svg',
                        badge: '3',
                        onTap: () => context.push(AppRouter.harvestSchedule),
                      ),
                      QuickAction(
                        label: 'Nearby Farmers',
                        iconPath: 'assets/icons/ic_nearby_farmer.svg',
                        onTap: () => context.push(AppRouter.nearbyFarmers),
                      ),
                      QuickAction(
                        label: 'My Orders',
                        iconPath: 'assets/icons/ic_orders.svg',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const OrdersListScreen()),
                        ),
                      ),
                      QuickAction(
                        label: 'Chat',
                        iconPath: 'assets/icons/ic_chat.svg',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ConversationsListScreen()),
                        ),
                      ),
                      QuickAction(
                        label: 'Promos',
                        iconPath: 'assets/icons/ic_promo.svg',
                        badge: 'HOT',
                        onTap: () {},
                      ),
                      QuickAction(
                        label: 'More',
                        iconData: Icons.more_horiz,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryScreen(
                              categoryName: 'All Categories',
                              categoryId: 'all',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // // ── 6. ACTIVE ORDER ───────────────────────────────────────────────
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          //     child: _buildActiveOrderWidget(activeOrder),
          //   ),
          // ),

          // // ── 7. REQUEST GOODS BANNER ───────────────────────────────────────
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          //     child: _buildRequestGoodsBanner(),
          //   ),
          // ),

          // ── 8. UPDATES FROM MY FARMERS ────────────────────────────────────
          if (farmerUpdates.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: _buildMyFarmersUpdates(farmerUpdates),
              ),
            ),

          // ── 9. WEEKLY STAPLES (REORDER) ───────────────────────────────────
          if (weeklyStaples.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildWeeklyStaples(weeklyStaples),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildMyFarmersUpdates(List<HomeFarmerUpdate> updates) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _sectionHeader('Updates from Your Farmers', showSeeAll: true),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: updates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final update = updates[index];
              return Container(
                width: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPillGrey, width: 1.5),
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
                    Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            update.farmerAvatar,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 32,
                              height: 32,
                              color: kPillGrey,
                              child: PhosphorIcon(
                                PhosphorIconsRegular.user,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            update.farmerName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                          ),
                        ),
                        Text(
                          update.timeAgo,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      update.content,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyStaples(List<HomeWeeklyStaple> staples) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('Your Weekly Staples', showSeeAll: false),
              const SizedBox(height: 4),
              Text(
                'Items you frequently buy, ready for 1-click reorder',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: staples.length,
          separatorBuilder: (_, __) =>
              Divider(height: 28, color: kPillGrey, thickness: 1),
          itemBuilder: (context, index) {
            final item = staples[index];
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(item.image,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(width: 52, height: 52, color: kPillGrey)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: kDarkGreen)),
                      const SizedBox(height: 2),
                      Text(
                          '${item.quantityLabel} · ${item.currency} ${item.price.toInt()}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kDarkGreen, width: 1.2)),
                    child: Icon(Icons.refresh, size: 16, color: kDarkGreen),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }

  // Widget _buildRequestGoodsBanner() {
  //   return GestureDetector(
  //     onTap: () => context.push(AppRouter.createSourcingRequest),
  //     child: Container(
  //       padding: const EdgeInsets.all(20),
  //       decoration: BoxDecoration(
  //         color: kDarkGreen,
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           PhosphorIcon(PhosphorIconsRegular.megaphone,
  //               color: Colors.white, size: 22),
  //           const SizedBox(height: 14),
  //           const Text(
  //             'Broadcast a bulk request',
  //             style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.white),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             "Can't find what you need? Request specific goods in bulk directly from our farmers network.",
  //             style: TextStyle(
  //                 fontSize: 13,
  //                 color: Colors.white.withOpacity(0.65),
  //                 height: 1.45),
  //           ),
  //           const SizedBox(height: 18),
  //           Row(
  //             children: [
  //               Text('Request goods now',
  //                   style: TextStyle(
  //                       fontSize: 13,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.white,
  //                       decoration: TextDecoration.underline,
  //                       decorationColor: Colors.white.withOpacity(0.4))),
  //               const SizedBox(width: 6),
  //               PhosphorIcon(PhosphorIconsRegular.arrowRight,
  //                   color: Colors.white, size: 14),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _iconBtn({
    required IconData icon,
    bool hasDot = false,
    required VoidCallback onTap,
  }) {
    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
            color: kDarkGreen,
            size: 20,
          ),
          if (hasDot)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: kAccentOrange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    String title, {
    bool showSeeAll = false,
    VoidCallback? onSeeAllTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        if (showSeeAll)
          GestureDetector(
            onTap: onSeeAllTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kDarkGreen,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class HarvestPromoBanner extends StatelessWidget {
  final String eyebrow, title, subtitle;
  final VoidCallback onTap;
  const HarvestPromoBanner(
      {super.key,
      required this.eyebrow,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
        color: kSand,
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: CustomPaint(
                size: const Size(90, 90),
                painter:
                    _GrainMotifPainter(color: kDarkGreen.withOpacity(0.08)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eyebrow.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: kAccentOrange)),
                const SizedBox(height: 8),
                Text(title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kDarkGreen,
                        height: 1.2)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 13, color: kDarkGreen.withOpacity(0.7))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WheatMarkPainter extends CustomPainter {
  final Color color;
  const _WheatMarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.15),
        Offset(size.width * 0.5, size.height * 0.95), paint);

    for (var i = 0; i < 3; i++) {
      final y = size.height * (0.28 + i * 0.2);
      canvas.drawLine(Offset(size.width * 0.5, y),
          Offset(size.width * 0.15, y - size.height * 0.1), paint);
      canvas.drawLine(Offset(size.width * 0.5, y),
          Offset(size.width * 0.85, y - size.height * 0.1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WheatMarkPainter old) => old.color != color;
}

class _GrainMotifPainter extends CustomPainter {
  final Color color;
  const _GrainMotifPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // A small fan of 3 wheat stalks, angled, clustered in the corner
    final stalks = [-0.35, 0.0, 0.35]; // radian offsets from vertical

    for (final angle in stalks) {
      final dx = size.width * 0.75;
      final dy = size.height * 0.75;
      final length = size.height * 0.55;

      final end = Offset(
        dx + length * -angle * 0.6,
        dy - length,
      );
      final start = Offset(dx, dy);

      canvas.drawLine(start, end, paint);

      // seed marks along the stalk
      for (var i = 1; i <= 4; i++) {
        final t = i / 5;
        final p = Offset.lerp(start, end, t)!;
        final perpAngle = angle + 1.5708; // perpendicular-ish
        final seedLen = 6.0;
        canvas.drawLine(
          p,
          Offset(p.dx + seedLen * -perpAngle.sign, p.dy - seedLen * 0.4),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GrainMotifPainter old) => old.color != color;
}
