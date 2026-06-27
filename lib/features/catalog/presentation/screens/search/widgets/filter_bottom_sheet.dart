import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DESIGN CONSTANTS ---
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class FilterBottomSheet extends StatefulWidget {
  final double? minPrice;
  final double? maxPrice;
  final List<String> selectedCategories;
  final List<String> selectedTypes;
  final Function(double?, double?, List<String>, List<String>) onApply;

  const FilterBottomSheet({
    super.key,
    this.minPrice,
    this.maxPrice,
    required this.selectedCategories,
    required this.selectedTypes,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late RangeValues _priceRange;
  late List<String> _selectedCategories;
  late List<String> _selectedTypes;

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.minPrice ?? 0,
      widget.maxPrice ?? 100,
    );
    _selectedCategories = List.from(widget.selectedCategories);
    _selectedTypes = List.from(widget.selectedTypes);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85, // Give it more room
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: kDarkGreen,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _priceRange = const RangeValues(0, 100);
                          _selectedCategories.clear();
                          _selectedTypes.clear();
                        });
                      },
                      child: Text(
                        'Reset',
                        style: GoogleFonts.inter(
                          color: kTextGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: kPillGrey, height: 1),

              // 2. SCROLLABLE CONTENT
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // --- PRICE RANGE ---
                    _buildSectionTitle('Price Range'),
                    const SizedBox(height: 24), // Space for slider labels
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: kDarkGreen,
                        inactiveTrackColor: kPillGrey,
                        thumbColor: Colors.white,
                        overlayColor: kDarkGreen.withOpacity(0.1),
                        trackHeight: 4,
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 10,
                          elevation: 4,
                        ),
                        valueIndicatorColor: kDarkGreen,
                        valueIndicatorTextStyle:
                            GoogleFonts.inter(color: Colors.white),
                      ),
                      child: RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${_priceRange.start.toStringAsFixed(0)}',
                          '\$${_priceRange.end.toStringAsFixed(0)}',
                        ),
                        onChanged: (values) {
                          setState(() {
                            _priceRange = values;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${_priceRange.start.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, color: kDarkGreen),
                          ),
                          Text(
                            '\$${_priceRange.end.toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold, color: kDarkGreen),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- CATEGORIES ---
                    _buildSectionTitle('Category'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        'Vegetables',
                        'Fruits',
                        'Grains',
                        'Dairy',
                        'Meat',
                        'Fish'
                      ].map((category) {
                        final isSelected =
                            _selectedCategories.contains(category);
                        return _buildModernChip(
                          label: category,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? _selectedCategories.remove(category)
                                  : _selectedCategories.add(category);
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // --- TYPE ---
                    _buildSectionTitle('Type'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        'Organic',
                        'Fresh',
                        'Local',
                        'Imported',
                        'Frozen'
                      ].map((type) {
                        final isSelected = _selectedTypes.contains(type);
                        return _buildModernChip(
                          label: type,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? _selectedTypes.remove(type)
                                  : _selectedTypes.add(type);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // 3. APPLY BUTTON
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(
                          _priceRange.start,
                          _priceRange.end,
                          _selectedCategories,
                          _selectedTypes,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: kDarkGreen,
      ),
    );
  }

  Widget _buildModernChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kDarkGreen : Colors.white,
          borderRadius: BorderRadius.circular(24), // Pill shape
          border: Border.all(
            color: isSelected ? kDarkGreen : kPillGrey,
            width: 1.5, // Slightly thicker border
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : kTextGrey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
