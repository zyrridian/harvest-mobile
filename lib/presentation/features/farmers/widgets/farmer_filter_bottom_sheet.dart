import 'package:flutter/material.dart';
import '../../../../core/config/theme/app_colors.dart';

class FarmerFilterBottomSheet extends StatefulWidget {
  final List<String> selectedSpecialties;
  final bool? hasMapFeature;
  final double? maxDistance;
  final double? minRating;
  final Function(
    List<String> specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  ) onApply;

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
    'Grains',
    'Herbs',
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSpecialties.clear();
                      _hasMapFeature = null;
                      _maxDistance = 10.0;
                      _minRating = 0.0;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialties
                  Text(
                    'Specialties',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSpecialties.map((specialty) {
                      final isSelected =
                          _selectedSpecialties.contains(specialty);
                      return FilterChip(
                        label: Text(specialty),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSpecialties.add(specialty);
                            } else {
                              _selectedSpecialties.remove(specialty);
                            }
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.primary.withOpacity(0.1),
                        checkmarkColor: AppColors.primary,
                        side: BorderSide(
                          color:
                              isSelected ? AppColors.primary : AppColors.border,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Map Feature
                  Text(
                    'Map Feature',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<bool?>(
                          title: const Text('All Farmers'),
                          value: null,
                          groupValue: _hasMapFeature,
                          onChanged: (value) {
                            setState(() {
                              _hasMapFeature = value;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        RadioListTile<bool?>(
                          title: const Text('With Map Feature'),
                          value: true,
                          groupValue: _hasMapFeature,
                          onChanged: (value) {
                            setState(() {
                              _hasMapFeature = value;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        RadioListTile<bool?>(
                          title: const Text('Without Map Feature'),
                          value: false,
                          groupValue: _hasMapFeature,
                          onChanged: (value) {
                            setState(() {
                              _hasMapFeature = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Max Distance
                  Text(
                    'Maximum Distance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Distance'),
                            Text(
                              '${_maxDistance.toStringAsFixed(0)} km',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _maxDistance,
                          min: 1,
                          max: 50,
                          divisions: 49,
                          label: '${_maxDistance.toStringAsFixed(0)} km',
                          onChanged: (value) {
                            setState(() {
                              _maxDistance = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Min Rating
                  Text(
                    'Minimum Rating',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Rating'),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  _minRating.toStringAsFixed(1),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Slider(
                          value: _minRating,
                          min: 0,
                          max: 5,
                          divisions: 10,
                          label: _minRating.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _minRating = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Apply Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    _selectedSpecialties,
                    _hasMapFeature,
                    _maxDistance > 0 ? _maxDistance : null,
                    _minRating > 0 ? _minRating : null,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
