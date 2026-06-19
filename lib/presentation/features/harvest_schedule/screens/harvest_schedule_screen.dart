import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/domain/entities/harvest_schedule_dashboard.dart';
import 'package:harvest_app/presentation/features/harvest_schedule/providers/harvest_schedule_controller.dart';
import 'package:harvest_app/presentation/features/harvest_schedule/providers/harvest_schedule_state.dart';
import 'package:intl/intl.dart';

const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF2E4E20);
const kTextGreen = Color(0xFF1E3A20);
const kHighlightGreen = Color(0xFF4A7C38);

class HarvestScheduleScreen extends ConsumerWidget {
  const HarvestScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(harvestScheduleControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Icon(Icons.chevron_left, color: kTextGreen),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Harvest Schedule',
          style: GoogleFonts.inter(
            color: kTextGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                ref.read(harvestScheduleControllerProvider.notifier).toggleViewMode();
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Icon(
                      state.maybeWhen(
                        data: (d) => d.isMonthView ? Icons.calendar_view_week : Icons.calendar_month_outlined,
                        orElse: () => Icons.calendar_month_outlined,
                      ),
                      color: kTextGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: state.when(
        initial: () => const SizedBox(),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kTextGreen)),
        error: (err) => Center(child: Text('Error: $err')),
        data: (data) {
          final groupedItems = <String, List<HarvestScheduleItemEntity>>{};
          for (var item in data.filteredItems) {
            groupedItems.putIfAbsent(item.dateGroup, () => []).add(item);
          }

          return CustomScrollView(
            slivers: [
              // Calendar Strip
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(data.baseDate),
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: kTextGreen),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => ref.read(harvestScheduleControllerProvider.notifier).goToToday(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Today',
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => ref.read(harvestScheduleControllerProvider.notifier).previous(),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.chevron_left, size: 20, color: Colors.black87),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => ref.read(harvestScheduleControllerProvider.notifier).next(),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.chevron_right, size: 20, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Days Header (SUN, MON, ...) only shown once in month view
                      if (data.isMonthView)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                                .map((day) => Expanded(
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      // Days Grid / Row
                      if (data.isMonthView)
                        ..._buildMonthGrid(context, ref, data)
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _getWeekDays(data.baseDate).map((date) {
                            return Expanded(
                              child: _buildDayColumn(context, ref, data, date,
                                  hasDot: _hasHarvestOnDate(data, date), showDayStr: true),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    ],
                  ),
                ),
              ),

              // Stats
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                  child: Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(context, ref, data,
                              '${data.thisWeekCount}', 'This week', QuickFilter.thisWeek)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(context, ref, data,
                              '${data.readyTodayCount}', 'Ready today', QuickFilter.readyToday)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(context, ref, data,
                              '${data.thisMonthCount}', 'This month', QuickFilter.thisMonth)),
                    ],
                  ),
                ),
              ),

              // Upcoming Harvests Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming harvests',
                        style: GoogleFonts.inter(
                          color: kTextGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _showFilterBottomSheet(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Filter',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kTextGreen),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.tune, size: 14, color: kTextGreen),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // List of items grouped by date
              ...groupedItems.entries.map((entry) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              entry.key,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (entry.value.any((e) => e.isToday))
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: kHighlightGreen,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text('NOW',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            const SizedBox(width: 8),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...entry.value.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildHarvestCard(context, ref, item),
                            )),
                      ],
                    ),
                  ),
                );
              }),

              // Bottom placeholder
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: Colors.grey[300]!, style: BorderStyle.none),
                    ),
                    child: Container(
                      // Dashed border effect using Container trick or just solid for now
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Nothing else this week — explore more harvests',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Browse pre-orders',
                              style: GoogleFonts.inter(
                                color: kTextGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDayColumn(BuildContext context, WidgetRef ref,
      HarvestScheduleData data, DateTime date,
      {bool hasDot = false, bool showDayStr = false}) {
    bool isSelected = data.selectedDate?.year == date.year &&
        data.selectedDate?.month == date.month &&
        data.selectedDate?.day == date.day;
    
    final now = DateTime.now();
    bool isToday = now.year == date.year && now.month == date.month && now.day == date.day;
    
    bool isCurrentMonth = date.month == data.baseDate.month;
    Color dayTextColor = isSelected ? kHighlightGreen : (isCurrentMonth ? Colors.grey[600]! : Colors.grey[400]!);
    Color dateTextColor = isSelected ? Colors.white : (isToday ? kHighlightGreen : (isCurrentMonth ? Colors.black87 : Colors.grey[400]!));

    return GestureDetector(
      onTap: () {
        ref.read(harvestScheduleControllerProvider.notifier).toggleDateFilter(date);
      },
      child: Column(
        children: [
          if (showDayStr) ...[
            Text(
              DateFormat('E').format(date).toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                color: dayTextColor,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? kHighlightGreen : (isToday ? const Color(0xFFE8F3E8) : Colors.transparent),
              border: isToday && !isSelected ? Border.all(color: kHighlightGreen.withOpacity(0.5)) : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                date.day.toString(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                  color: dateTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: hasDot ? Colors.orange : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasHarvestOnDate(HarvestScheduleData data, DateTime date) {
    return data.items.any((item) => item.dateDayFilter == date.day.toString());
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            String selectedSort = 'Date';
            List<String> selectedStatus = ['Ready today'];
            double maxDistance = 15.0;

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter & Sort',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kTextGreen,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: kTextGreen),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      children: [
                        Text(
                          'Sort By',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: ['Date', 'Price', 'Distance'].map((sortOption) {
                            final isSelected = selectedSort == sortOption;
                            return ChoiceChip(
                              label: Text(
                                sortOption,
                                style: GoogleFonts.inter(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: kHighlightGreen,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected ? kHighlightGreen : Colors.grey[300]!,
                                ),
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => selectedSort = sortOption);
                                }
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Status',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kTextGreen,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            'Ready today',
                            'Pre-ordered',
                            'Pending confirmation',
                            'Just reserved'
                          ].map((status) {
                            final isSelected = selectedStatus.contains(status);
                            return FilterChip(
                              label: Text(
                                status,
                                style: GoogleFonts.inter(
                                  color: isSelected ? kHighlightGreen : Colors.black87,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              checkmarkColor: kHighlightGreen,
                              selectedColor: const Color(0xFFE8F3E8),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: isSelected ? kHighlightGreen : Colors.grey[300]!,
                                ),
                              ),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedStatus.add(status);
                                  } else {
                                    selectedStatus.remove(status);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Distance',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kTextGreen,
                              ),
                            ),
                            Text(
                              'Up to ${maxDistance.toInt()} km',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kHighlightGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: kHighlightGreen,
                            inactiveTrackColor: Colors.grey[200],
                            thumbColor: kHighlightGreen,
                            overlayColor: kHighlightGreen.withOpacity(0.2),
                          ),
                          child: Slider(
                            value: maxDistance,
                            min: 1,
                            max: 50,
                            divisions: 49,
                            onChanged: (value) {
                              setState(() => maxDistance = value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedSort = 'Date';
                                selectedStatus.clear();
                                maxDistance = 50.0;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kHighlightGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Show Results',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<DateTime> _getWeekDays(DateTime baseDate) {
    int weekday = baseDate.weekday;
    int offset = weekday == 7 ? 0 : weekday;
    DateTime startOfWeek = baseDate.subtract(Duration(days: offset));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  List<DateTime> _getMonthDays(DateTime baseDate) {
    DateTime firstDayOfMonth = DateTime(baseDate.year, baseDate.month, 1);
    int firstWeekday = firstDayOfMonth.weekday;
    int offset = firstWeekday == 7 ? 0 : firstWeekday;
    DateTime startOfCalendar = firstDayOfMonth.subtract(Duration(days: offset));
    
    List<DateTime> days = [];
    DateTime current = startOfCalendar;
    while (true) {
      days.add(current);
      current = current.add(const Duration(days: 1));
      if (days.length >= 28 && current.month != baseDate.month && current.weekday == 7) {
        break;
      }
      if (days.length >= 42) break; // Fallback
    }
    return days;
  }

  List<Widget> _buildMonthGrid(BuildContext context, WidgetRef ref, HarvestScheduleData data) {
    final days = _getMonthDays(data.baseDate);
    List<Widget> rows = [];
    for (int i = 0; i < days.length; i += 7) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final date = days[i + index];
              return Expanded(
                child: _buildDayColumn(context, ref, data, date,
                    hasDot: _hasHarvestOnDate(data, date), showDayStr: false),
              );
            }),
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildStatCard(BuildContext context, WidgetRef ref, HarvestScheduleData data, String value, String label, QuickFilter filterType) {
    bool isActive = data.activeQuickFilter == filterType;
    bool isReadyToday = filterType == QuickFilter.readyToday;

    Color bgColor = isActive 
        ? (isReadyToday ? const Color(0xFFD4833D) : kTextGreen) 
        : Colors.white;
    Color textColor = isActive ? Colors.white : kTextGreen;
    Color labelColor = isActive ? Colors.white70 : Colors.grey[600]!;
    Color borderColor = isActive ? Colors.transparent : Colors.grey[200]!;

    return GestureDetector(
      onTap: () {
        ref.read(harvestScheduleControllerProvider.notifier).toggleQuickFilter(filterType);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 32,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.inter(
                color: labelColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHarvestCard(
      BuildContext context, WidgetRef ref, HarvestScheduleItemEntity item) {
    Color leftBorderColor = kHighlightGreen;
    if (item.badges.contains('Pending confirmation'))
      leftBorderColor = const Color(0xFFD4833D);
    if (item.badges.contains('Just reserved'))
      leftBorderColor = const Color(0xFF3B82F6);

    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F3E8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(item.imageUrl,
                                style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kTextGreen),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.farmerName} · ${item.distance} km',
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: item.badges.map((badge) {
                                  Color badgeBg = const Color(0xFFE8F3E8);
                                  Color badgeText = const Color(0xFF2E7D32);
                                  if (badge == 'Pre-ordered' ||
                                      badge == 'Just reserved') {
                                    badgeBg = const Color(0xFFE3F2FD);
                                    badgeText = const Color(0xFF1565C0);
                                  } else if (badge == 'Pending confirmation') {
                                    badgeBg = const Color(0xFFFFF3E0);
                                    badgeText = const Color(0xFFE65100);
                                  }
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      badge,
                                      style: GoogleFonts.inter(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: badgeText),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.descriptionText,
                                style: GoogleFonts.inter(
                                    fontSize: 11, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.statusText,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: item.statusText == 'Now'
                                    ? kHighlightGreen
                                    : (item.statusText == '15'
                                        ? const Color(0xFF3B82F6)
                                        : const Color(0xFFD4833D)),
                              ),
                            ),
                            Text(
                              item.statusText == 'Now' ? 'ready' : 'days left',
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              formatter
                                  .format(item.price)
                                  .replaceAll(',00', ''),
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: kTextGreen),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (item.actionButton1.isNotEmpty ||
                        item.actionButton2.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (item.actionButton1.isNotEmpty)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (item.actionButton1.contains('Chat')) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Opening chat with ${item.farmerName}...'),
                                      duration: const Duration(seconds: 2),
                                    ));
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (item.actionButton1.contains('Chat'))
                                          const Icon(Icons.chat_bubble_outline,
                                              size: 14),
                                        if (item.actionButton1.contains('Chat'))
                                          const SizedBox(width: 4),
                                        Text(
                                          item.actionButton1
                                              .replaceAll('\\n', ' ')
                                              .replaceAll('\n', ' '),
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (item.actionButton1.isNotEmpty &&
                              item.actionButton2.isNotEmpty)
                            const SizedBox(width: 12),
                          if (item.actionButton2.isNotEmpty)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (item.actionButton2.contains('Pay')) {
                                    ref
                                        .read(harvestScheduleControllerProvider
                                            .notifier)
                                        .payDeposit(item);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Paying deposit...')));
                                  } else if (item.actionButton2
                                      .contains('Arrange')) {
                                    ref
                                        .read(harvestScheduleControllerProvider
                                            .notifier)
                                        .arrangePickup(item);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Arranging pickup...')));
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.actionButton2
                                          .replaceAll('\\n', ' ')
                                          .replaceAll('\n', ' '),
                                      style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
