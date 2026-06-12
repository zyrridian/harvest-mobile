import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/theme/app_colors.dart';

// --- DESIGN CONSTANTS ---
const kDarkGreen = Color(0xFF1A2F25);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class FarmerFilterBottomSheet extends StatefulWidget {
  // ... (Keep existing parameters)
  final List<String> selectedSpecialties;
  final bool? hasMapFeature;
  final double? maxDistance;
  final double? minRating;
  final Function(List<String>, bool?, double?, double?) onApply;

  const FarmerFilterBottomSheet({
    super.key,
    required this.selectedSpecialties,
    required this.hasMapFeature,
    required this.maxDistance,
    required this.minRating,
    required this.onApply,
  });

  @override
  State<FarmerFilterBottomSheet> createState() =>
      _FarmerFilterBottomSheetState();
}

class _FarmerFilterBottomSheetState extends State<FarmerFilterBottomSheet> {
  // ... (Keep existing state variables & initState)
  late List<String> _selectedSpecialties;
  late bool? _hasMapFeature;
  late double _maxDistance;
  late double _minRating;
  final List<String> _availableSpecialties = [
    'Vegetables',
    'Fruits',
    'Livestock',
    'Fish',
    'Dairy',
    'Eggs',
    'Grains'
  ];

  @override
  void initState() {
    super.initState();
    _selectedSpecialties = List.from(widget.selectedSpecialties);
    _hasMapFeature = widget.hasMapFeature;
    _maxDistance = widget.maxDistance ?? 10.0;
    _minRating = widget.minRating ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
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
                    // Reset Logic
                    setState(() {
                      _selectedSpecialties.clear();
                      _hasMapFeature = null;
                      _maxDistance = 10.0;
                      _minRating = 0.0;
                    });
                  },
                  child: Text(
                    'Reset',
                    style: GoogleFonts.inter(
                        color: kTextGrey, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: kPillGrey, height: 1),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Specialties'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableSpecialties.map((s) {
                      final isSelected = _selectedSpecialties.contains(s);
                      return _buildModernChip(
                        label: s,
                        isSelected: isSelected,
                        onTap: () => setState(() {
                          isSelected
                              ? _selectedSpecialties.remove(s)
                              : _selectedSpecialties.add(s);
                        }),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),
                  _buildSectionTitle('Map Feature'),
                  const SizedBox(height: 16),
                  // Custom Radio Row
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kPillGrey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildCustomRadio('All Farmers', null),
                        const Divider(height: 1, color: kPillGrey),
                        _buildCustomRadio('With Map Feature', true),
                        const Divider(height: 1, color: kPillGrey),
                        _buildCustomRadio('Without Map Feature', false),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  _buildSectionTitle('Distance (${_maxDistance.toInt()} km)'),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: kDarkGreen,
                      inactiveTrackColor: kPillGrey,
                      thumbColor: Colors.white,
                      overlayColor: kDarkGreen.withOpacity(0.1),
                    ),
                    child: Slider(
                      value: _maxDistance,
                      min: 1,
                      max: 50,
                      onChanged: (v) => setState(() => _maxDistance = v),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Apply Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_selectedSpecialties, _hasMapFeature,
                        _maxDistance, _minRating);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.bold, color: kDarkGreen),
    );
  }

  Widget _buildModernChip(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kDarkGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? kDarkGreen : kPillGrey),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : kTextGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomRadio(String title, bool? value) {
    final isSelected = _hasMapFeature == value;
    return InkWell(
      onTap: () => setState(() => _hasMapFeature = value),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(title,
                style: GoogleFonts.inter(
                    color: isSelected ? kDarkGreen : kTextGrey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: kDarkGreen, size: 20),
          ],
        ),
      ),
    );
  }
}
