import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';

import '../providers/explore_controller.dart';
import '../../../../domain/entities/explore.dart';
import '../../../../core/config/router/app_router.dart';
import 'package:go_router/go_router.dart';

// --- DESIGN CONSTANTS ---
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2E7D32);
const kPillGrey = Color(0xFFF0F2F0);

class ExploreScreen extends ConsumerStatefulWidget {
  final bool isTab;
  const ExploreScreen({super.key, this.isTab = true});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    // Implement search
  }

  void _showFilterBottomSheet() {
    // Show filter logic
  }

  @override
  Widget build(BuildContext context) {
    final exploreState = ref.watch(exploreControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: exploreState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (msg) => Center(child: Text('Error: $msg')),
        loaded: (exploreData) => RefreshIndicator.adaptive(
          onRefresh: () async {
            ref.invalidate(exploreControllerProvider);
          },
          child: CustomScrollView(
            slivers: [
              // 1. Hero Section (Search & Map entry)
              SliverToBoxAdapter(
                child: _buildHeroSection(),
              ),
          
              // 2. Live from the Farm
              if (exploreData.liveStreams.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildLiveFromTheFarm(exploreData.liveStreams),
                ),
          
              // 3. In Season Right Now
              if (exploreData.inSeason.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildInSeasonSection(exploreData.inSeason),
                ),
          
              // 4. Community Deals (Group Buy)
              if (exploreData.groupBuys.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildCommunityDeals(exploreData.groupBuys),
                ),
          
              // 5. Nearby Farmers
              if (exploreData.nearbyFarmers.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildNearbyFarmersSection(exploreData.nearbyFarmers),
                ),
          
              // 6. Farm Experiences
              if (exploreData.experiences.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildExperiences(exploreData.experiences),
                ),
          
              // 7. Active Pre-orders / Trending Deals
              if (exploreData.activePreorders.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildActivePreordersSection(exploreData.activePreorders),
                ),
          
              const SliverToBoxAdapter(child: SizedBox(height: 120)), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryGreen,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 320,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?auto=format&fit=crop&q=80'), // Map aesthetic
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isTab)
                  IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                const Spacer(),
                Text(
                  'Find fresh, local\nfood near you.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                // Premium Search Bar
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(PhosphorIconsRegular.magnifyingGlass, color: Colors.grey[500]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: kDarkGreen),
                          decoration: InputDecoration(
                            hintText: 'Search for tomatoes, farms...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onSubmitted: (_) => _performSearch(),
                        ),
                      ),
                      Container(
                        height: 32,
                        width: 1,
                        color: Colors.grey[200],
                      ),
                      IconButton(
                        icon: Icon(PhosphorIconsRegular.fadersHorizontal, color: kDarkGreen),
                        onPressed: _showFilterBottomSheet,
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Map Action Button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Interactive Map View coming soon!')),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(PhosphorIconsFill.mapPin, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Explore on Map',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const PhosphorIcon(PhosphorIconsRegular.caretRight, color: Colors.white, size: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInSeasonSection(List<ExploreInSeason> inSeason) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('In Season Right Now', 'Peak flavor and freshness this week'),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: inSeason.length,
            separatorBuilder: (context, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = inSeason[index];
              return Container(
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(item.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.farmsCount} Farms',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyFarmersSection(List<ExploreNearbyFarmer> farmers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Farms Near You', 'Support local growers in your area', onSeeAll: () {}),
        SizedBox(
          height: 310,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            scrollDirection: Axis.horizontal,
            itemCount: farmers.length,
            separatorBuilder: (context, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final farmer = farmers[index];
              final defaultImage = index % 2 == 0 
                  ? 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&q=80'
                  : 'https://images.unsplash.com/photo-1595841696677-6489ff3f8cd1?auto=format&fit=crop&q=80';
              
              return Container(
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large Cover Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Stack(
                        children: [
                          Image.network(
                            farmer.coverImage.isNotEmpty == true ? farmer.coverImage : defaultImage,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(height: 140, color: Colors.grey[200], child: const PhosphorIcon(PhosphorIconsRegular.imageBroken)),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const PhosphorIcon(PhosphorIconsFill.star, color: Colors.orange, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    farmer.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farmer.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(PhosphorIconsRegular.mapPin, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${farmer.distanceKm.toStringAsFixed(1)} km away',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Specialties tags
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: (farmer.specialties.isEmpty ? ['Vegetables', 'Fruits'] : farmer.specialties)
                                  .map((tag) => Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: kPrimaryGreen.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            tag,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: kPrimaryGreen,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildActivePreordersSection(List<ExplorePreOrder> preorders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Active Pre-orders', 'Reserve upcoming harvests at a discount', onSeeAll: () {}),
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: preorders.length,
          separatorBuilder: (context, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final campaign = preorders[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      campaign.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(width: 80, height: 80, color: Colors.grey[200], child: const PhosphorIcon(PhosphorIconsRegular.imageBroken)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${campaign.daysLeft} days left',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          campaign.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          campaign.farmerName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: campaign.progressPercentage,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryGreen),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: kPrimaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(PhosphorIconsRegular.caretRight, color: kPrimaryGreen, size: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLiveFromTheFarm(List<ExploreLiveStream> streams) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Live from the Farm', 'Watch and buy directly from the field'),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: streams.length,
            separatorBuilder: (context, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final stream = streams[index];
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Playing HLS stream: ${stream.streamUrl}')),
                  );
                },
                child: Container(
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(stream.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'LIVE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(PhosphorIconsFill.eye, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              '${stream.viewers}',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          stream.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stream.farmerName,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityDeals(List<ExploreGroupBuy> deals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Community Group Buys', 'Join neighbors to unlock bulk discounts', onSeeAll: () {}),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: deals.length,
            separatorBuilder: (context, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final deal = deals[index];
              return Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        deal.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            deal.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            deal.farmName,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(deal.price),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryGreen,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(deal.originalPrice),
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress Bar
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: deal.joinedCount / deal.targetCount,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${deal.joinedCount}/${deal.targetCount}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildExperiences(List<ExploreExperience> experiences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Agritourism & Experiences', 'Plan your next weekend farm visit', onSeeAll: () {}),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: experiences.length,
            separatorBuilder: (context, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final exp = experiences[index];
              return Container(
                width: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(exp.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(PhosphorIconsFill.mapPin, color: Colors.white70, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            exp.location,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        exp.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            exp.dateString,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(exp.price),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFA5D6A7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
