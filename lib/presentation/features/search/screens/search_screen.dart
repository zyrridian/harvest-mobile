import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../providers/search_controller.dart';
import '../providers/search_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_list_item.dart';
import '../widgets/filter_bottom_sheet.dart';

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
    // Load recent searches on init
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

    ref.read(searchQueryProvider.notifier).state = query;
    ref.read(searchControllerProvider.notifier).searchProducts();
  }

  void _applySearch(String query) {
    _searchController.text = query;
    ref.read(searchQueryProvider.notifier).state = query;
    ref.read(searchControllerProvider.notifier).searchProducts();
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        minPrice: minPrice,
        maxPrice: maxPrice,
        selectedCategories: selectedCategories,
        selectedTypes: selectedTypes,
        onApply: (min, max, categories, types) {
          ref.read(minPriceProvider.notifier).state = min;
          ref.read(maxPriceProvider.notifier).state = max;
          ref.read(selectedCategoriesProvider.notifier).state = categories;
          ref.read(selectedTypesProvider.notifier).state = types;
          // Re-search with new filters
          if (_searchController.text.isNotEmpty) {
            _performSearch();
          }
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
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildSearchBar(),
          ),
        ),
      ),
      body: ListView(
        children: [
          // Recent Searches Section
          recentSearchesState.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            loaded: (searches) {
              if (searches.isEmpty) return const SizedBox.shrink();

              final displayedSearches =
                  showAllRecent ? searches : searches.take(9).toList();

              return Column(
                children: [
                  _buildRecentSearchesSection(displayedSearches, searches),
                  const Divider(height: 32),
                ],
              );
            },
            error: (message) => const SizedBox.shrink(),
          ),

          // Sort and View Options
          _buildSortAndViewSection(sortBy, viewMode),
          const SizedBox(height: 16),

          // Search Results
          searchState.when(
            initial: () => _buildEmptyState(),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            ),
            loaded: (products) {
              if (products.isEmpty) {
                return _buildNoResultsState();
              }

              return Column(
                children: [
                  // Results Count
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${products.length} products found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Product Grid/List
                  viewMode == ViewMode.grid
                      ? _buildGridView(products)
                      : _buildListView(products),
                ],
              );
            },
            error: (message) => _buildErrorState(message),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  isDense: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 4)),
              onSubmitted: (_) => _performSearch(),
              onChanged: (value) {
                if (value.isEmpty) {
                  _clearSearch();
                }
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppColors.textSecondary),
              onPressed: _clearSearch,
            ),
          IconButton(
            icon: const Icon(Icons.mic, color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice search coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textSecondary),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchesSection(
      List<String> displayedSearches, List<String> allSearches) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(recentSearchesControllerProvider.notifier)
                      .clearAll();
                },
                child: const Text('Clear all'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...displayedSearches.map((search) => _buildSearchChip(search)),
              if (allSearches.length > 9)
                ActionChip(
                  label: Text(
                    ref.watch(showAllRecentProvider) ? 'Show less' : 'See more',
                  ),
                  avatar: Icon(
                    ref.watch(showAllRecentProvider)
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 18,
                  ),
                  onPressed: () {
                    ref.read(showAllRecentProvider.notifier).state =
                        !ref.read(showAllRecentProvider);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchChip(String search) {
    return InputChip(
      label: Text(search),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: () {
        ref
            .read(recentSearchesControllerProvider.notifier)
            .removeSearch(search);
      },
      onPressed: () => _applySearch(search),
    );
  }

  Widget _buildSortAndViewSection(String sortBy, ViewMode viewMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: sortBy,
                isExpanded: true,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down),
                selectedItemBuilder: (BuildContext context) {
                  return [
                    _buildDropdownLabel('Relevance'),
                    _buildDropdownLabel('Price'),
                    _buildDropdownLabel('Distance'),
                    _buildDropdownLabel('Newest'),
                    _buildDropdownLabel('Rating'),
                  ];
                },
                items: const [
                  DropdownMenuItem(
                    value: 'relevance',
                    child: Text('Relevance'),
                  ),
                  DropdownMenuItem(
                    value: 'price',
                    child: Text('Price'),
                  ),
                  DropdownMenuItem(
                    value: 'distance',
                    child: Text('Distance'),
                  ),
                  DropdownMenuItem(
                    value: 'newest',
                    child: Text('Newest'),
                  ),
                  DropdownMenuItem(
                    value: 'rating',
                    child: Text('Rating'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(sortByProvider.notifier).state = value;
                    // Re-search with new sort
                    if (_searchController.text.isNotEmpty) {
                      _performSearch();
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          // View Mode Buttons
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.grid_view,
                    color: viewMode == ViewMode.grid
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  onPressed: () {
                    ref.read(viewModeProvider.notifier).state = ViewMode.grid;
                  },
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(8),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.border,
                ),
                IconButton(
                  icon: Icon(
                    Icons.list,
                    color: viewMode == ViewMode.list
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  onPressed: () {
                    ref.read(viewModeProvider.notifier).state = ViewMode.list;
                  },
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(8),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: AppColors.border,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.map,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Map view coming soon')),
                    );
                  },
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Row(
      children: [
        Text(
          'Sort by: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildGridView(List products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          onTap: () {
            // TODO: Navigate to product details
          },
          onFavorite: () {
            // TODO: Add to favorites
          },
        );
      },
    );
  }

  Widget _buildListView(List products) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductListItem(
          product: products[index],
          onTap: () {
            // TODO: Navigate to product details
          },
          onFavorite: () {
            // TODO: Add to favorites
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Search for products',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching for vegetables, fruits, or other products',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search query',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
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
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
