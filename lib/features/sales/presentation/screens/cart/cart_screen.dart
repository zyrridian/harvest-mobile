import 'package:flutter/material.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import '../../providers/cart/cart_controller.dart';
// Assuming you have these from previous files, if not, they are defined below
// import 'package:harvest_app/core/config/theme/app_colors.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kCream = Color(0xFFF0EAD6);
const kAccentOrange = kDarkGreen;
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class CartScreen extends ConsumerWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);

    return WebConstrainedBox(
      maxWidth: 600,
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          backgroundColor: kBgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
                color: kDarkGreen),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          ),
          titleSpacing: 0,
          title: Text(
            'My Cart',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                onPressed: () => _clearCart(context, ref),
                icon: const PhosphorIcon(
                  PhosphorIconsRegular.trash,
                  color: kDarkGreen,
                ),
              ),
            ),
          ],
        ),
        body: cartState.when(
          initial: () => const SizedBox.shrink(),
          data: (cart) {
            if (cart.items.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: _buildEmptyState(context),
              );
            }

            // Calculate Total (assuming item.subtotal is the line total)
            final double total =
                cart.items.fold(0, (sum, item) => sum + (item.subtotal));

            return Column(
              children: [
                // Scrollable Cart Items
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, idx) {
                      final item = cart.items[idx];
                      return _buildModernCartItem(context, ref, item);
                    },
                  ),
                ),

                // Bottom Summary Section
                _buildBottomSummary(context, ref, total),
              ],
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator(color: kDarkGreen)),
          error: (e) => Center(child: Text('Error: ${e.toString()}')),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kPillGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(PhosphorIconsRegular.shoppingCart,
                size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fresh products are waiting for you!',
            style: TextStyle(color: kTextGrey),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCartItem(
      BuildContext context, WidgetRef ref, dynamic item) {
    // Note: 'item' should be your CartItem model.
    // Assuming fields: name, quantity, subtotal, cartItemId.
    // Ideally, item has an imageUrl. If not, we use a fallback.

    return Dismissible(
      key: Key(item.cartItemId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444), // Red
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(PhosphorIconsRegular.trash,
            color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _removeItem(context, ref, item.cartItemId),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Clickable area for product details
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.push('${AppRouter.products}/${item.productId}');
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: kPillGrey,
                        child: _buildProductImage(item.imageUrl, item.name),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 2. Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kDarkGreen,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(item
                                    .subtotal), // Or unit price if available
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kAccentOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 3. Quantity Stepper (Pill Shape)
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepperBtn(
                    icon: PhosphorIconsRegular.minus,
                    onTap: () => _updateQty(context, ref, item, -1),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen,
                      ),
                    ),
                  ),
                  _buildStepperBtn(
                    icon: PhosphorIconsRegular.plus,
                    onTap: () => _updateQty(context, ref, item, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperBtn(
      {required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Icon(icon, size: 16, color: kDarkGreen),
        ),
      ),
    );
  }

  Widget _buildBottomSummary(
      BuildContext context, WidgetRef ref, double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: kDarkGreen.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: TextStyle(color: kTextGrey)),
                Text(
                  NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                      .format(total),
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: kDarkGreen),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Mock Delivery Fee (Optional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee', style: TextStyle(color: kTextGrey)),
                Text(
                  'Rp 15.000',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: kDarkGreen),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(),
            ),
            // Total Row
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
                  NumberFormat.currency(
                          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                      .format(total + 15000), // Adding dummy delivery fee
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kAccentOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _checkout(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Checkout Now',
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
  }

  // --- LOGIC METHODS (Preserved from your original code) ---

  Future<void> _updateQty(
      BuildContext context, WidgetRef ref, dynamic item, int change) async {
    final newQty = item.quantity + change;

    if (newQty < 1) {
      // Remove item if quantity goes to 0
      await _removeItem(context, ref, item.cartItemId);
      return;
    }

    final clampedQty = newQty.clamp(1, 999);
    if (clampedQty == item.quantity) return;

    ref
        .read(cartControllerProvider.notifier)
        .updateQuantity(item.cartItemId, clampedQty.toInt());
  }

  Future<void> _removeItem(
      BuildContext context, WidgetRef ref, dynamic id) async {
    ref.read(cartControllerProvider.notifier).removeItem(id);
    _showSnack(context, 'Item removed');
  }

  Future<void> _clearCart(BuildContext context, WidgetRef ref) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
            'Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: kTextGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFEF4444), // Red for destructive action
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    ref.read(cartControllerProvider.notifier).clearCart();
    _showSnack(context, 'Cart cleared');
  }

  Future<void> _checkout(BuildContext context, WidgetRef ref) async {
    final validateUc = ref.read(validateCartUsecaseProvider);
    final res = await validateUc.call();
    res.fold(
      (l) => _showSnack(context, l.message),
      (r) => context.push(AppRouter.checkout),
    );
  }

  Widget _buildProductImage(String? imageUrl, String name) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackImage(name);
    }
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',').last;
        return Image.memory(
          base64Decode(base64String),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackImage(name),
        );
      } catch (e) {
        return _buildFallbackImage(name);
      }
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildFallbackImage(name),
    );
  }

  Widget _buildFallbackImage(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: kDarkGreen.withOpacity(0.4),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: kDarkGreen,
      ),
    );
  }
}
