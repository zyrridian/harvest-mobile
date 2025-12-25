import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/notification_providers.dart';
import '../../../../domain/entities/notification.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedType = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider(
      NotificationParams(type: _selectedType),
    ));

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded, color: kDarkGreen),
            onPressed: () => _markAllAsRead(),
            tooltip: 'Mark all as read',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: kDarkGreen),
            onPressed: () => _showSettings(),
            tooltip: 'Notification settings',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 10),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              physics: const BouncingScrollPhysics(),

              // 1. FIX: FORCE LEFT ALIGNMENT
              tabAlignment: TabAlignment.start,

              // 2. FIX: STARTING PADDING (Matches page margin)
              padding: const EdgeInsets.symmetric(horizontal: 24),

              // 3. FIX: SPACE BETWEEN CHIPS
              labelPadding: const EdgeInsets.only(right: 8),

              // Visual Styling
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kDarkGreen,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: kTextGrey,
              labelStyle:
                  GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13),
              unselectedLabelStyle:
                  GoogleFonts.dmSans(fontWeight: FontWeight.w500, fontSize: 13),
              dividerColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),

              onTap: (index) {
                setState(() {
                  _selectedType = [
                    'all',
                    'order',
                    'message',
                    'promotion',
                    'price_alert',
                    'stock_alert'
                  ][index];
                });
              },

              // 4. FIX: CHIP WIDTH (Padding inside the tab)
              // We wrap text in Padding to make the pill wider than the text
              tabs: [
                _buildTab('All'),
                _buildTab('Orders'),
                _buildTab('Messages'),
                _buildTab('Promos'),
                _buildTab('Prices'),
                _buildTab('Stock'),
              ],
            ),
          ),
        ),
      ),
      body: notificationsAsync.when(
        data: (notificationList) => _buildNotificationsList(notificationList),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  // Helper to build a Tab with internal padding (controls Chip Width)
  Tab _buildTab(String text) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16), // Internal width of the chip
        child: Text(text),
      ),
    );
  }

  Widget _buildNotificationsList(NotificationList notificationList) {
    if (notificationList.notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kPillGrey,
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('🔕', style: TextStyle(fontSize: 32))),
            ),
            const SizedBox(height: 16),
            Text(
              'All caught up!',
              style: GoogleFonts.dmSans(
                  fontSize: 18, fontWeight: FontWeight.bold, color: kDarkGreen),
            ),
            Text(
              'No new notifications to show.',
              style: GoogleFonts.dmSans(color: kTextGrey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: kDarkGreen,
      onRefresh: () async {
        ref.invalidate(
          notificationsProvider(NotificationParams(type: _selectedType)),
        );
      },
      child: CustomScrollView(
        slivers: [
          // Stats header (Modern Capsule)
          if (notificationList.stats.totalUnread > 0)
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6), // Creamy Alert BG
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFFFDE047).withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Color(0xFFD97706), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'You have ${notificationList.stats.totalUnread} unread notifications',
                        style: GoogleFonts.dmSans(
                          color: const Color(0xFF92400E),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Notifications list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final notification = notificationList.notifications[index];
                return _buildNotificationItem(notification);
              },
              childCount: notificationList.notifications.length,
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    // Determine visuals based on priority/type
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.notificationId),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: const Color(0xFFEF4444), // Red
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => _deleteNotification(notification),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. VISUAL IDENTIFIER (Pebble Icon)
                _buildNotificationIcon(notification),

                const SizedBox(width: 16),

                // 2. CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: GoogleFonts.dmSans(
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 15,
                                color: kDarkGreen,
                              ),
                            ),
                          ),
                          // Timestamp
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              _formatTime(notification.createdAt),
                              style: GoogleFonts.dmSans(
                                color: kTextGrey,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: GoogleFonts.dmSans(
                          color: isUnread
                              ? kDarkGreen.withOpacity(0.8)
                              : kTextGrey,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Priority Tag (Only if urgent/high)
                      if (notification.priority == NotificationPriority.high ||
                          notification.priority == NotificationPriority.urgent)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(notification.priority)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notification.priority.name.toUpperCase(),
                              style: GoogleFonts.dmSans(
                                color: _getPriorityColor(notification.priority),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // 3. UNREAD DOT (The "Modern" replacement for colored backgrounds)
                if (isUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: kAccentOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to create the "Pebble" icons matching the Home Screen
  Widget _buildNotificationIcon(AppNotification notification) {
    // If it's a direct image URL
    if (notification.image != null) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // Pebble shape
            image: DecorationImage(
              image: NetworkImage(notification.image!),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ]),
      );
    }

    // Default Fallback Icons (Styled like Categories)
    IconData iconData = Icons.notifications_none;
    List<Color> gradient = [
      const Color(0xFFF3F4F6),
      const Color(0xFFD1D5DB)
    ]; // Grey default
    Color iconColor = kDarkGreen;

    // You might want to map this based on 'type' or parse the 'icon' string
    // Here is a simple heuristic based on the Title or Type for demo purposes
    final titleLower = notification.title.toLowerCase();

    if (titleLower.contains('order') || titleLower.contains('shipped')) {
      iconData = Icons.local_shipping_outlined;
      gradient = [const Color(0xFFFFE5D9), const Color(0xFFFFD1BC)]; // Peach
      iconColor = const Color(0xFFA6442E);
    } else if (titleLower.contains('price') || titleLower.contains('sale')) {
      iconData = Icons.local_offer_outlined;
      gradient = [const Color(0xFFFEF9C3), const Color(0xFFFDE047)]; // Yellow
      iconColor = const Color(0xFFB45309);
    } else if (titleLower.contains('message')) {
      iconData = Icons.chat_bubble_outline;
      gradient = [const Color(0xFFD4E2D4), const Color(0xFFB8C6B8)]; // Sage
      iconColor = const Color(0xFF2D4A3E);
    } else if (titleLower.contains('stock')) {
      iconData = Icons.inventory_2_outlined;
      gradient = [const Color(0xFFDBEAFE), const Color(0xFF93C5FD)]; // Blue
      iconColor = const Color(0xFF1E40AF);
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient),
        borderRadius: BorderRadius.circular(18), // Soft organic shape
      ),
      child: Center(
        child: Icon(iconData, color: iconColor, size: 24),
      ),
    );
  }

  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.urgent:
        return const Color(0xFFEF4444); // Red
      case NotificationPriority.high:
        return const Color(0xFFE86A33); // Burnt Orange
      case NotificationPriority.medium:
        return const Color(0xFF3B82F6); // Blue
      case NotificationPriority.low:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${dateTime.day}/${dateTime.month}';
  }

  void _handleNotificationTap(AppNotification notification) async {
    if (!notification.isRead) {
      final useCase = ref.read(markNotificationAsReadUseCaseProvider);
      await useCase(notification.notificationId);
      ref.invalidate(
          notificationsProvider(NotificationParams(type: _selectedType)));
    }
    // Navigation logic...
  }

  void _deleteNotification(AppNotification notification) async {
    final useCase = ref.read(deleteNotificationUseCaseProvider);
    await useCase(notification.notificationId);
    ref.invalidate(
        notificationsProvider(NotificationParams(type: _selectedType)));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification deleted', style: GoogleFonts.dmSans()),
          backgroundColor: kDarkGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _markAllAsRead() async {
    final useCase = ref.read(markAllNotificationsAsReadUseCaseProvider);
    await useCase(type: _selectedType != 'all' ? _selectedType : null);
    ref.invalidate(
        notificationsProvider(NotificationParams(type: _selectedType)));
  }

  void _showSettings() {
    // ... settings logic
  }
}
