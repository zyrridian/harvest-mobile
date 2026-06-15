import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  child: const Icon(Icons.calendar_month_outlined,
                      color: kTextGreen),
                ),
                Positioned(
                  top: 8,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
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
          final groupedItems = <String, List<HarvestScheduleItem>>{};
          for (var item in data.items) {
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
                              'June 2026',
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: kTextGreen),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.chevron_left,
                                      size: 20, color: Colors.grey),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.chevron_right,
                                      size: 20, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Days Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDayColumn('SUN', '8', hasDot: false),
                          _buildDayColumn('MON', '9', hasDot: true),
                          _buildDayColumn('TUE', '10', hasDot: false),
                          _buildDayColumn('WED', '11', hasDot: true),
                          _buildDayColumn('THU', '12', hasDot: false),
                          _buildDayColumn('FRI', '13', isSelected: true),
                          _buildDayColumn('SAT', '14', hasDot: true),
                        ],
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
                          child: _buildStatCard(
                              '${data.thisWeekCount}', 'This week')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(
                              '${data.readyTodayCount}', 'Ready today',
                              isHighlight: true)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildStatCard(
                              '${data.thisMonthCount}', 'This month')),
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
                      Container(
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
                              child: _buildHarvestCard(item),
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

  Widget _buildDayColumn(String day, String date,
      {bool isSelected = false, bool hasDot = false}) {
    return Column(
      children: [
        Text(
          day,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? kHighlightGreen : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? kHighlightGreen : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              date,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.black87,
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
    );
  }

  Widget _buildStatCard(String value, String label,
      {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: isHighlight ? const Color(0xFFD4833D) : kHighlightGreen,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHarvestCard(HarvestScheduleItem item) {
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
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (item.actionButton1.contains('Chat'))
                                        const Icon(Icons.chat_bubble_outline,
                                            size: 14),
                                      if (item.actionButton1.contains('Chat'))
                                        const SizedBox(width: 4),
                                      Text(
                                        item.actionButton1
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
                          if (item.actionButton1.isNotEmpty &&
                              item.actionButton2.isNotEmpty)
                            const SizedBox(width: 12),
                          if (item.actionButton2.isNotEmpty)
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    item.actionButton2.replaceAll('\n', ' '),
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                    textAlign: TextAlign.center,
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
