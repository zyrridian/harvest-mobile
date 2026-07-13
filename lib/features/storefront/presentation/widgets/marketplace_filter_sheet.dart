import 'package:flutter/material.dart';
import 'package:harvest_app/features/storefront/presentation/providers/marketplace_state.dart';
import 'package:intl/intl.dart';

const kDarkGreen = Color(0xFF1A2F25);

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

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(value)
        .replaceAll(',00', '');
  }

  @override
  Widget build(BuildContext context) {
    final minPrice = _params.minPrice ?? 0.0;
    final maxPrice = _params.maxPrice ?? 200000.0;

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
                  fontWeight: FontWeight.w700,
                  color: kDarkGreen,
                  letterSpacing: -0.5,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: kDarkGreen),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Sort By
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kDarkGreen),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: [
              _buildSortPill('Newest', 'newest', 'desc'),
              _buildSortPill('Best Rated', 'rating', 'desc'),
              _buildSortPill('Price: Low to High', 'price', 'asc'),
              _buildSortPill('Price: High to Low', 'price', 'desc'),
            ],
          ),
          const SizedBox(height: 32),

          // Price Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Price Range',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kDarkGreen),
              ),
              Text(
                '${_formatCurrency(minPrice)} - ${_formatCurrency(maxPrice)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kDarkGreen),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            min: 0,
            max: 200000,
            divisions: 20,
            activeColor: kDarkGreen,
            inactiveColor: Colors.grey[200],
            labels: RangeLabels(_formatCurrency(minPrice), _formatCurrency(maxPrice)),
            onChanged: (values) {
              _updateParam(_params.copyWith(minPrice: values.start, maxPrice: values.end));
            },
          ),
          const SizedBox(height: 24),

          // Organic Only Toggle
          SwitchListTile(
            title: const Text(
              'Organic Only',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kDarkGreen),
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
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: kDarkGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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

  Widget _buildSortPill(String label, String sortBy, String order) {
    final isSelected = _params.sortBy == sortBy && _params.order == order;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kDarkGreen : Colors.white,
          border: Border.all(
            color: isSelected ? kDarkGreen : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : kDarkGreen,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
