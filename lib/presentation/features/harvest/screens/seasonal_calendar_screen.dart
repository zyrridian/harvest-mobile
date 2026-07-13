import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
// import '../../../../core/config/theme/app_colors.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

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

  // Mock Data (Keep your existing map content here)
  final Map<int, MonthlyHarvest> monthlyData = {
    1: MonthlyHarvest(
      month: 'January',
      vegetables: ['Kale', 'Carrots', 'Cabbage', 'Broccoli', 'Cauliflower'],
      fruits: ['Oranges', 'Grapefruit', 'Lemons', 'Kiwi'],
      herbs: ['Rosemary', 'Thyme', 'Parsley'],
      tips:
          'Winter vegetables are at their sweetest. Perfect time for root vegetables.',
    ),
    // ... Add other months ...
    12: MonthlyHarvest(
      month: 'December',
      vegetables: ['Kale', 'Brussels Sprouts', 'Cabbage'],
      fruits: ['Citrus', 'Pomegranate'],
      herbs: ['Rosemary', 'Thyme'],
      tips: 'Winter crops available. Plan next year\'s garden.',
    ),
  };

  MonthlyHarvest get currentMonthData {
    // Fallback if month is missing in mock data
    return monthlyData[_selectedDay?.month ?? _focusedDay.month] ??
        MonthlyHarvest(
            month: 'Unknown', vegetables: [], fruits: [], herbs: [], tips: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Seasonal Calendar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: kDarkGreen),
            onPressed: _showCalendarInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. MODERN CALENDAR
            Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kPillGrey),
                boxShadow: [
                  BoxShadow(
                    color: kDarkGreen.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                  leftChevronIcon:
                      const Icon(Icons.chevron_left, color: kDarkGreen),
                  rightChevronIcon:
                      const Icon(Icons.chevron_right, color: kDarkGreen),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: kDarkGreen),
                  weekendTextStyle: TextStyle(color: kAccentOrange),
                  selectedDecoration: const BoxDecoration(
                    color: kDarkGreen,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: kDarkGreen.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: kDarkGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
              ),
            ),

            // 2. MONTH INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentMonthData.month,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tip Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9E6), // Creamy Yellow
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFDE047)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded,
                            color: Color(0xFFD97706), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            currentMonthData.tips,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF92400E),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Produce Sections
                  _buildCategorySection('Vegetables', Icons.grass_rounded,
                      Colors.green, currentMonthData.vegetables),
                  const SizedBox(height: 24),
                  _buildCategorySection('Fruits', Icons.apple_outlined,
                      Colors.red, currentMonthData.fruits),
                  const SizedBox(height: 24),
                  _buildCategorySection('Herbs', Icons.eco_outlined,
                      Colors.teal, currentMonthData.herbs),

                  const SizedBox(height: 40),

                  // Meal Planner CTA
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _showMealPlanner,
                      icon: const Icon(Icons.restaurant_menu_rounded),
                      label: Text(
                        'Plan Meals with Seasonal Produce',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
      String title, IconData icon, Color color, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPillGrey),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: kDarkGreen,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showCalendarInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Seasonal Calendar',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          'This calendar helps you identify which produce is at its peak flavor and lowest price during specific months.',
          style: TextStyle(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it',
                style: TextStyle(
                    color: kDarkGreen, fontWeight: FontWeight.bold)),
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
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kPillGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Weekly Meal Plan',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen),
              ),
              const SizedBox(height: 8),
              Text(
                'Based on ${currentMonthData.month} ingredients',
                style: TextStyle(color: kTextGrey),
              ),
              const SizedBox(height: 24),
              _buildMealCard('Mon', 'Roasted Root Veggie Salad',
                  'Carrots, Beets, Parsnips'),
              _buildMealCard(
                  'Tue', 'Kale & Apple Smoothie', 'Kale, Apples, Bananas'),
              _buildMealCard(
                  'Wed', 'Cauliflower Steaks', 'Cauliflower, Lemon, Herbs'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(String day, String title, String ingredients) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPillGrey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kDarkGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              day,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: kDarkGreen),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: kDarkGreen),
                ),
                const SizedBox(height: 4),
                Text(
                  ingredients,
                  style: TextStyle(fontSize: 12, color: kTextGrey),
                ),
              ],
            ),
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
