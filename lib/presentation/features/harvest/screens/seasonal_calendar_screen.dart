import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/config/theme/app_colors.dart';

class SeasonalCalendarScreen extends ConsumerStatefulWidget {
  const SeasonalCalendarScreen({super.key});

  @override
  ConsumerState<SeasonalCalendarScreen> createState() =>
      _SeasonalCalendarScreenState();
}

class _SeasonalCalendarScreenState
    extends ConsumerState<SeasonalCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<int, MonthlyHarvest> monthlyData = {
    1: MonthlyHarvest(
      month: 'January',
      vegetables: ['Kale', 'Carrots', 'Cabbage', 'Broccoli', 'Cauliflower'],
      fruits: ['Oranges', 'Grapefruit', 'Lemons', 'Kiwi'],
      herbs: ['Rosemary', 'Thyme', 'Parsley'],
      tips:
          'Winter vegetables are at their sweetest. Perfect time for root vegetables.',
    ),
    2: MonthlyHarvest(
      month: 'February',
      vegetables: ['Spinach', 'Lettuce', 'Radishes', 'Peas'],
      fruits: ['Strawberries', 'Avocado'],
      herbs: ['Cilantro', 'Mint', 'Basil'],
      tips: 'Start planning spring garden. Good time for indoor seed starting.',
    ),
    3: MonthlyHarvest(
      month: 'March',
      vegetables: ['Asparagus', 'Artichokes', 'Spring Onions', 'Lettuce'],
      fruits: ['Strawberries', 'Papaya', 'Mango'],
      herbs: ['Basil', 'Parsley', 'Chives'],
      tips: 'Spring harvest begins. Perfect time for leafy greens.',
    ),
    4: MonthlyHarvest(
      month: 'April',
      vegetables: ['Peas', 'New Potatoes', 'Spinach', 'Arugula'],
      fruits: ['Strawberries', 'Cherries', 'Apricots'],
      herbs: ['Dill', 'Basil', 'Cilantro'],
      tips:
          'Peak season for many spring vegetables. Start summer crop planning.',
    ),
    5: MonthlyHarvest(
      month: 'May',
      vegetables: ['Tomatoes', 'Cucumber', 'Zucchini', 'Beans'],
      fruits: ['Mango', 'Papaya', 'Lychee', 'Strawberries'],
      herbs: ['Basil', 'Oregano', 'Mint'],
      tips: 'Tropical fruits peak. Start harvesting early summer vegetables.',
    ),
    6: MonthlyHarvest(
      month: 'June',
      vegetables: ['Bell Peppers', 'Eggplant', 'Corn', 'Squash'],
      fruits: ['Watermelon', 'Peaches', 'Blueberries', 'Cherries'],
      herbs: ['Basil', 'Thyme', 'Sage'],
      tips: 'Summer harvest in full swing. Stay on top of watering.',
    ),
    7: MonthlyHarvest(
      month: 'July',
      vegetables: ['Tomatoes', 'Cucumbers', 'Peppers', 'Green Beans'],
      fruits: ['Watermelon', 'Cantaloupe', 'Plums', 'Blackberries'],
      herbs: ['Basil', 'Dill', 'Cilantro'],
      tips: 'Peak production month. Preserve excess harvest.',
    ),
    8: MonthlyHarvest(
      month: 'August',
      vegetables: ['Eggplant', 'Okra', 'Peppers', 'Tomatoes'],
      fruits: ['Grapes', 'Figs', 'Pears', 'Apples'],
      herbs: ['Basil', 'Parsley', 'Oregano'],
      tips: 'Late summer bounty. Start planning fall crops.',
    ),
    9: MonthlyHarvest(
      month: 'September',
      vegetables: ['Pumpkin', 'Winter Squash', 'Sweet Potato', 'Broccoli'],
      fruits: ['Apples', 'Pears', 'Grapes', 'Pomegranate'],
      herbs: ['Sage', 'Rosemary', 'Thyme'],
      tips: 'Fall harvest begins. Perfect time for root vegetables.',
    ),
    10: MonthlyHarvest(
      month: 'October',
      vegetables: ['Pumpkin', 'Brussels Sprouts', 'Cauliflower', 'Kale'],
      fruits: ['Apples', 'Cranberries', 'Persimmons'],
      herbs: ['Parsley', 'Sage', 'Chives'],
      tips: 'Peak fall harvest. Prepare for winter storage.',
    ),
    11: MonthlyHarvest(
      month: 'November',
      vegetables: ['Cabbage', 'Carrots', 'Turnips', 'Leeks'],
      fruits: ['Cranberries', 'Pomegranate', 'Pears'],
      herbs: ['Rosemary', 'Thyme', 'Sage'],
      tips: 'Late fall harvest. Focus on cold-hardy crops.',
    ),
    12: MonthlyHarvest(
      month: 'December',
      vegetables: ['Kale', 'Brussels Sprouts', 'Cabbage', 'Carrots'],
      fruits: ['Citrus', 'Pomegranate', 'Persimmons'],
      herbs: ['Rosemary', 'Thyme', 'Parsley'],
      tips: 'Winter crops available. Plan next year\'s garden.',
    ),
  };

  MonthlyHarvest get currentMonthData {
    return monthlyData[_selectedDay?.month ?? _focusedDay.month]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seasonal Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showCalendarInfo();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: Colors.red),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Month Info
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Month Header
                Row(
                  children: [
                    Icon(_getSeasonIcon(_focusedDay.month),
                        color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      currentMonthData.month,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          currentMonthData.tips,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Vegetables
                _buildCategorySection(
                  'Vegetables',
                  Icons.grass,
                  Colors.green,
                  currentMonthData.vegetables,
                ),
                const SizedBox(height: 20),

                // Fruits
                _buildCategorySection(
                  'Fruits',
                  Icons.apple,
                  Colors.red,
                  currentMonthData.fruits,
                ),
                const SizedBox(height: 20),

                // Herbs
                _buildCategorySection(
                  'Herbs',
                  Icons.eco,
                  Colors.teal,
                  currentMonthData.herbs,
                ),
                const SizedBox(height: 20),

                // Plan Meals Button
                ElevatedButton.icon(
                  onPressed: () {
                    _showMealPlanner();
                  },
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text('Plan Meals with Seasonal Produce'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    IconData icon,
    Color color,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: color.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getSeasonIcon(int month) {
    if (month >= 3 && month <= 5) return Icons.local_florist; // Spring
    if (month >= 6 && month <= 8) return Icons.wb_sunny; // Summer
    if (month >= 9 && month <= 11) return Icons.park; // Fall
    return Icons.ac_unit; // Winter
  }

  void _showCalendarInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Seasonal Calendar'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This calendar shows what produce is typically in season each month.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '• Tap any month to see what\'s available\n'
              '• Seasonal produce is fresher and tastier\n'
              '• Plan meals around what\'s in season\n'
              '• Support local farmers',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showMealPlanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Meal Planning',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Based on ${currentMonthData.month} seasonal produce',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _buildMealPlanCard(
                'Monday',
                'Fresh Salad with Seasonal Vegetables',
                'Uses: ${currentMonthData.vegetables.take(3).join(", ")}',
              ),
              _buildMealPlanCard(
                'Tuesday',
                'Fruit Smoothie Bowl',
                'Uses: ${currentMonthData.fruits.take(2).join(", ")}',
              ),
              _buildMealPlanCard(
                'Wednesday',
                'Herb-Roasted Vegetables',
                'Uses: ${currentMonthData.herbs.take(2).join(", ")}',
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Full meal planner coming soon!')),
                  );
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Generate Weekly Plan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealPlanCard(String day, String meal, String ingredients) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meal,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ingredients,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class MonthlyHarvest {
  final String month;
  final List<String> vegetables;
  final List<String> fruits;
  final List<String> herbs;
  final String tips;

  MonthlyHarvest({
    required this.month,
    required this.vegetables,
    required this.fruits,
    required this.herbs,
    required this.tips,
  });
}
