import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'package:harvest_app/features/sales/presentation/providers/orders/order_providers.dart';
import 'package:harvest_app/features/chat/presentation/providers/messaging_providers.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer.dart';
import '../../../../../core/config/router/app_router.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
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
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.main);
            }
          },
        ),
        title: Text(
          'Order Details',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
        ),
      ),
      body: orderAsync.when(
        data: (order) {
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(orderDetailProvider(orderId)),
            color: kDarkGreen,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                              style: TextStyle(
                                fontSize: 14,
                                color: kTextGrey,
                              ),
                            ),
                            Text(
                              order.orderNumber,
                              style: TextStyle(
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
                              style: TextStyle(
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
                  GestureDetector(
                    onTap: () {
                      final dummyFarmer = Farmer(
                        id: order.seller.userId,
                        userId: order.seller.userId,
                        name: order.seller.name,
                        description: '',
                        profileImage: order.seller.profilePicture,
                        latitude: 0,
                        longitude: 0,
                        address: '',
                        rating: 0,
                        totalReviews: 0,
                        totalProducts: 0,
                        specialties: const [],
                        isVerified: false,
                        hasMapFeature: false,
                        joinedDate: DateTime.now(),
                        isOnline: false,
                      );
                      context.push('/farmer-detail', extra: dummyFarmer);
                    },
                    child: Container(
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
                              style: TextStyle(
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kDarkGreen,
                                ),
                              ),
                              Text(
                                'Farmer • Verified',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kTextGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _startChat(context, ref, order),
                          icon: const Icon(PhosphorIconsRegular.chatCircle,
                              color: kDarkGreen),
                        ),
                      ],
                    ),
                  ),
                  ),

                  const SizedBox(height: 24),

                  // Items
                  _buildSectionTitle('Order Items'),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            context.push('/products/${item.productId}');
                          },
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
                                clipBehavior: Clip.hardEdge,
                                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        item.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Center(
                                          child: Text(
                                            item.name.isNotEmpty ? item.name[0] : '?',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: kDarkGreen,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          item.name.isNotEmpty ? item.name[0] : '?',
                                          style: TextStyle(
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
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: kDarkGreen,
                                      ),
                                    ),
                                    Text(
                                      'Qty: ${item.quantity} • Rp ${item.unitPrice}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: kTextGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp ${item.subtotal}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkGreen,
                                ),
                              ),
                            ],
                          ),
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
                        _buildInfoRow('Address',
                            order.delivery.address ?? 'Not specified'),
                        const Divider(height: 24),
                        _buildInfoRow(
                            'Date', order.delivery.date ?? 'Not specified'),
                        const Divider(height: 24),
                        _buildInfoRow(
                            'Delivery Fee', 'Rp ${order.delivery.fee}'),
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen,
                              ),
                            ),
                            Text(
                              'Rp ${order.totalAmount}',
                              style: TextStyle(
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Pay Now Button
                  if (order.status.toLowerCase() == 'pending_payment' &&
                      order.paymentUrl != null)
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          final uri = Uri.parse(order.paymentUrl!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => _buildShimmerDetail(),
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(PhosphorIconsRegular.warningCircle,
                  size: 48, color: kTextGrey),
              const SizedBox(height: 16),
              Text('Error: $e', style: TextStyle(color: kTextGrey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
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
        icon = PhosphorIconsRegular.arrowsClockwise;
        break;
      case 'delivered':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = PhosphorIconsFill.checkCircle;
        break;
      case 'cancelled':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        icon = PhosphorIconsFill.xCircle;
        break;
      default:
        bgColor = kPillGrey;
        textColor = kTextGrey;
        icon = PhosphorIconsFill.info;
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
            style: TextStyle(
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
          style: TextStyle(
            fontSize: 14,
            color: kTextGrey,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
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
          style: TextStyle(
            fontSize: 14,
            color: kTextGrey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
          style: TextStyle(color: kTextGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('No', style: TextStyle(color: kTextGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Yes, Cancel', style: TextStyle()),
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

  void _startChat(BuildContext context, WidgetRef ref, dynamic order) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
    );

    final uc = ref.read(startConversationUsecaseProvider);
    final res = await uc.call(
      recipientId: order.seller.userId,
      type: 'order',
      orderId: order.orderId,
    );

    if (context.mounted) {
      Navigator.pop(context); // Close loading dialog
      res.fold(
        (l) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (data) {
          final conversationId = data['data']?['conversation_id'] ?? data['conversation_id'] ?? data['id'];
          if (conversationId != null) {
            final farmerName = Uri.encodeComponent(order.seller.name);
            final farmerAvatar = Uri.encodeComponent(order.seller.profilePicture ?? '');
            context.push('${AppRouter.chat}?conversationId=$conversationId&farmerName=$farmerName&farmerAvatar=$farmerAvatar');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to start conversation.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildShimmerDetail() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 24),
            Container(width: 150, height: 24, color: Colors.white),
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 24),
            Container(width: 150, height: 24, color: Colors.white),
            const SizedBox(height: 12),
            Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20))),
            const SizedBox(height: 24),
            Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20))),
          ],
        ),
      ),
    );
  }
}
