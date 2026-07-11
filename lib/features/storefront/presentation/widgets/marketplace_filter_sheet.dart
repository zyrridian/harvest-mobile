import 'package:flutter/material.dart';
import 'package:harvest_app/features/storefront/presentation/providers/marketplace_state.dart';

const kDarkGreen = Color(0xFF28482A);

class MarketplaceFilterSheet extends StatefulWidget {
  final ProductFilterParams initialParams;
  final ValueChanged<ProductFilterParams> onApply;

  const MarketplaceFilterSheet({
    Key? key,
    required this.initialParams,
    required this.onApply,
  }) : super(key: key);

  @override
  State<MarketplaceFilterSheet> createState() => _MarketplaceFilterSheetState();
}

class _MarketplaceFilterSheetState extends State<MarketplaceFilterSheet> {
  late ProductFilterParams _params;

  @override
  void initState() {
    super.initState();
    _params = widget.initialParams;
  }

  void _updateParam(ProductFilterParams newParams) {
    setState(() {
      _params = newParams;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sort By
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildSortChip('Newest', 'newest', 'desc'),
              _buildSortChip('Best Rated', 'rating', 'desc'),
              _buildSortChip('Price: Low to High', 'price', 'asc'),
              _buildSortChip('Price: High to Low', 'price', 'desc'),
            ],
          ),
          const SizedBox(height: 24),

          // Price Range
          const Text(
            'Price Range',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Min',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (val) {
                    final price = double.tryParse(val);
                    _updateParam(_params.copyWith(minPrice: price));
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Max',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (val) {
                    final price = double.tryParse(val);
                    _updateParam(_params.copyWith(maxPrice: price));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Organic Only Toggle
          SwitchListTile(
            title: const Text(
              'Organic Only',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            value: _params.isOrganic ?? false,
            activeColor: kDarkGreen,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) {
              _updateParam(_params.copyWith(isOrganic: val));
            },
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _params = const ProductFilterParams(); // Reset all
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: kDarkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_params);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String sortBy, String order) {
    final isSelected = _params.sortBy == sortBy && _params.order == order;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _updateParam(_params.copyWith(sortBy: sortBy, order: order));
        } else {
          _updateParam(ProductFilterParams(
            categoryId: _params.categoryId,
            minPrice: _params.minPrice,
            maxPrice: _params.maxPrice,
            isOrganic: _params.isOrganic,
            sortBy: null,
            order: null,
          ));
        }
      },
      selectedColor: kDarkGreen.withOpacity(0.1),
      labelStyle: TextStyle(
        color: isSelected ? kDarkGreen : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
