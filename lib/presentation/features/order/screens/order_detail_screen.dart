import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/presentation/providers/order_providers.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class OrderDetailScreen extends ConsumerWidget {
  static const routeName = '/order-detail';

  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Order Details',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: orderAsync.when(
        data: (order) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPillGrey),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Number',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: kTextGrey,
                            ),
                          ),
                          Text(
                            order.orderNumber,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: kTextGrey,
                            ),
                          ),
                          _buildStatusBadge(order.status),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Seller Info
                _buildSectionTitle('Seller Information'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPillGrey),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kPillGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            order.seller.name.isNotEmpty
                                ? order.seller.name[0]
                                : 'S',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.seller.name,
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kDarkGreen,
                              ),
                            ),
                            Text(
                              'Farmer • Verified',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: kTextGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: kDarkGreen),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Items
                _buildSectionTitle('Order Items'),
                const SizedBox(height: 12),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kPillGrey),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPillGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  item.name.isNotEmpty ? item.name[0] : '?',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: kDarkGreen,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: kDarkGreen,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${item.quantity} • Rp ${item.unitPrice}',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: kTextGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${item.subtotal}',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 24),

                // Delivery Info
                _buildSectionTitle('Delivery Details'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPillGrey),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Method', order.delivery.method),
                      const Divider(height: 24),
                      _buildInfoRow(
                          'Address', order.delivery.address ?? 'Not specified'),
                      const Divider(height: 24),
                      _buildInfoRow(
                          'Date', order.delivery.date ?? 'Not specified'),
                      const Divider(height: 24),
                      _buildInfoRow('Delivery Fee', 'Rp ${order.delivery.fee}'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Payment Summary
                _buildSectionTitle('Payment Summary'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPillGrey),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal',
                          'Rp ${order.totalAmount - order.delivery.fee}'),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                          'Delivery Fee', 'Rp ${order.delivery.fee}'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.dmSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                          ),
                          Text(
                            'Rp ${order.totalAmount}',
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Cancel Button (only if order is processing)
                if (order.status.toLowerCase() == 'processing')
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => _cancelOrder(context, ref),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Cancel Order',
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: kTextGrey),
              const SizedBox(height: 16),
              Text('Error: $e', style: GoogleFonts.dmSans(color: kTextGrey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: kDarkGreen,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'processing':
        bgColor = kAccentOrange.withOpacity(0.1);
        textColor = kAccentOrange;
        icon = Icons.refresh;
        break;
      case 'delivered':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        bgColor = kPillGrey;
        textColor = kTextGrey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: kTextGrey,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kDarkGreen,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: kTextGrey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kDarkGreen,
          ),
        ),
      ],
    );
  }

  void _cancelOrder(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Cancel Order?',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
          style: GoogleFonts.dmSans(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('No', style: GoogleFonts.dmSans(color: kTextGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Yes, Cancel', style: GoogleFonts.dmSans()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final uc = ref.read(cancelOrderUsecaseProvider);
      final res = await uc.call(
        orderId: orderId,
        payload: {
          "reason": "changed_mind",
          "details": "User cancelled from app",
          "request_refund": true,
        },
      );

      if (context.mounted) {
        res.fold(
          (l) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.message),
              backgroundColor: Colors.red,
            ),
          ),
          (r) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order cancelled successfully'),
                backgroundColor: kDarkGreen,
              ),
            );
            ref.invalidate(orderDetailProvider(orderId));
          },
        );
      }
    }
  }
}
