import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../../../../core/config/theme/app_colors.dart'; // Using local constants for demo
import '../providers/search_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/product_list_item.dart';
import '../widgets/filter_bottom_sheet.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(recentSearchesControllerProvider.notifier).loadRecentSearches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    ref.read(searchControllerProvider.notifier).performSearch(query);
  }

  void _applySearch(String query) {
    _searchController.text = query;
    ref.read(searchControllerProvider.notifier).applyRecentSearch(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchControllerProvider.notifier).clearSearch();
  }

  void _showFilterBottomSheet() {
    final minPrice = ref.read(minPriceProvider);
    final maxPrice = ref.read(maxPriceProvider);
    final selectedCategories = ref.read(selectedCategoriesProvider);
    final selectedTypes = ref.read(selectedTypesProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => FilterBottomSheet(
        minPrice: minPrice,
        maxPrice: maxPrice,
        selectedCategories: selectedCategories,
        selectedTypes: selectedTypes,
        onApply: (min, max, categories, types) {
          ref.read(searchControllerProvider.notifier).applyFilters(
                minPrice: min,
                maxPrice: max,
                categories: categories,
                types: types,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final recentSearchesState = ref.watch(recentSearchesControllerProvider);
    final showAllRecent = ref.watch(showAllRecentProvider);
    final sortBy = ref.watch(sortByProvider);
    final viewMode = ref.watch(viewModeProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      body: CustomScrollView(
        slivers: [
          // 1. MODERN APP BAR
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: kBgColor,
            surfaceTintColor: kBgColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            toolbarHeight: 80,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _buildModernSearchBar(),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  Container(
                    decoration: BoxDecoration(
                      color: kDarkGreen,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, color: Colors.white),
                      onPressed: _showFilterBottomSheet,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. RECENT SEARCHES
          SliverToBoxAdapter(
            child: recentSearchesState.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(
                  child: CircularProgressIndicator(color: kDarkGreen)),
              loaded: (searches) {
                if (searches.isEmpty) return const SizedBox.shrink();
                final displayedSearches =
                    showAllRecent ? searches : searches.take(9).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRecentSearchesSection(displayedSearches, searches),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(color: kPillGrey, height: 32),
                    ),
                  ],
                );
              },
              error: (message) => const SizedBox.shrink(),
            ),
          ),

          // 3. SORT & VIEW CONTROLS
          SliverToBoxAdapter(
            child: _buildSortAndViewSection(sortBy, viewMode),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // 4. RESULTS
          searchState.when(
            initial: () => SliverToBoxAdapter(child: _buildEmptyState()),
            loading: () => const SliverToBoxAdapter(
              child: Center(
                  child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: kDarkGreen),
              )),
            ),
            loaded: (products) {
              if (products.isEmpty) {
                return SliverToBoxAdapter(child: _buildNoResultsState());
              }

              return SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Text(
                        'Found ${products.length} products',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  viewMode == ViewMode.grid
                      ? _buildSliverGridView(products)
                      : _buildSliverListView(products),
                  // Bottom padding
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
            error: (message) =>
                SliverToBoxAdapter(child: _buildErrorState(message)),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildModernSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: kPillGrey, // Stone Grey Background
        borderRadius: BorderRadius.circular(100), // Full Pill
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(Icons.search, color: Colors.grey[500], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.inter(color: kDarkGreen),
              decoration: InputDecoration(
                hintText: 'Search fresh products...',
                hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon:
                  Icon(Icons.close_rounded, color: Colors.grey[500], size: 20),
              onPressed: _clearSearch,
            ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchesSection(
      List<String> displayedSearches, List<String> allSearches) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kDarkGreen,
                ),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(recentSearchesControllerProvider.notifier)
                      .clearAll();
                },
                child: Text(
                  'Clear all',
                  style: GoogleFonts.inter(color: kTextGrey, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...displayedSearches.map((search) => _buildModernChip(search)),
              if (allSearches.length > 9)
                GestureDetector(
                  onTap: () {
                    ref.read(showAllRecentProvider.notifier).state =
                        !ref.read(showAllRecentProvider);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: kAccentOrange),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ref.watch(showAllRecentProvider)
                              ? 'Show less'
                              : 'See more',
                          style: GoogleFonts.inter(
                            color: kAccentOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          ref.watch(showAllRecentProvider)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: kAccentOrange,
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernChip(String search) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _applySearch(search),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPillGrey),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history, size: 14, color: kTextGrey),
              const SizedBox(width: 6),
              Text(
                search,
                style: GoogleFonts.inter(
                  color: kDarkGreen,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  ref
                      .read(recentSearchesControllerProvider.notifier)
                      .removeSearch(search);
                },
                child: const Icon(Icons.close, size: 14, color: kTextGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortAndViewSection(String sortBy, ViewMode viewMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Sort Dropdown (Capsule Style)
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kPillGrey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: sortBy,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: kDarkGreen),
                  style: GoogleFonts.inter(
                      color: kDarkGreen, fontWeight: FontWeight.w500),
                  items: [
                    _buildDropdownItem('relevance', 'Relevance'),
                    _buildDropdownItem('price', 'Price: Low to High'),
                    _buildDropdownItem('newest', 'Newest Arrivals'),
                    _buildDropdownItem('rating', 'Top Rated'),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(searchControllerProvider.notifier)
                          .updateSort(value);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // View Toggle (Capsule Style)
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: kPillGrey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildViewButton(
                    Icons.grid_view_rounded, ViewMode.grid, viewMode),
                Container(width: 1, height: 24, color: kPillGrey),
                _buildViewButton(
                    Icons.view_list_rounded, ViewMode.list, viewMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String label) {
    return DropdownMenuItem(value: value, child: Text(label));
  }

  Widget _buildViewButton(IconData icon, ViewMode mode, ViewMode currentMode) {
    final isSelected = mode == currentMode;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? kDarkGreen : kTextGrey,
        size: 20,
      ),
      onPressed: () {
        ref.read(viewModeProvider.notifier).state = mode;
      },
    );
  }

  Widget _buildSliverGridView(List products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70, // Optimized for product cards
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            onTap: () {},
            onFavorite: () {},
          );
        },
      ),
    );
  }

  Widget _buildSliverListView(List products) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProductListItem(
                product: products[index],
                onTap: () {},
                onFavorite: () {},
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kPillGrey,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.search_rounded, size: 64, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              'Discover Freshness',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: kDarkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search for vegetables, fruits, or daily essentials.',
              style: GoogleFonts.inter(color: kTextGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF9E6), // Creamy
                shape: BoxShape.circle,
              ),
              child: const Text('🥕', style: TextStyle(fontSize: 48)),
            ),
            const SizedBox(height: 24),
            Text(
              'No products found',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: kDarkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters to find what you need.',
              style: GoogleFonts.inter(color: kTextGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: GoogleFonts.inter(
                  fontSize: 24, fontWeight: FontWeight.bold, color: kDarkGreen),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.inter(color: kTextGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGreen,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
