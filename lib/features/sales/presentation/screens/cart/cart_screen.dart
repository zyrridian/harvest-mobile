import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import '../../providers/cart/cart_controller.dart';
// Assuming you have these from previous files, if not, they are defined below
// import 'package:harvest_app/core/config/theme/app_colors.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class CartScreen extends ConsumerWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
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
            child: const Icon(Icons.chevron_left, color: kDarkGreen),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: Text(
          'My Cart',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => _clearCart(context, ref),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Icon(Icons.delete_outline, color: kDarkGreen),
              ),
            ),
          ),
        ],
      ),
      body: cartState.when(
        initial: () => const SizedBox.shrink(),
        data: (cart) {
          if (cart.items.isEmpty) {
            return _buildEmptyState(context);
          }

          // Calculate Total (assuming item.subtotal is the line total)
          final double total =
              cart.items.fold(0, (sum, item) => sum + (item.subtotal));

          return Column(
            children: [
              // Scrollable Cart Items
              Expanded(
                child: ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
            child: const Icon(Icons.shopping_basket_outlined,
                size: 48, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fresh products are waiting for you!',
            style: GoogleFonts.inter(color: kTextGrey),
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _removeItem(context, ref, item.cartItemId),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPillGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
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
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kDarkGreen,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${item.subtotal}', // Or unit price if available
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kAccentOrange,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Quantity Stepper (Pill Shape)
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStepperBtn(
                    icon: Icons.remove,
                    onTap: () => _updateQty(context, ref, item, -1),
                  ),
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen,
                      ),
                    ),
                  ),
                  _buildStepperBtn(
                    icon: Icons.add,
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
        borderRadius: BorderRadius.circular(20),
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
                Text('Subtotal', style: GoogleFonts.inter(color: kTextGrey)),
                Text(
                  'Rp $total',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, color: kDarkGreen),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Mock Delivery Fee (Optional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee',
                    style: GoogleFonts.inter(color: kTextGrey)),
                Text(
                  'Rp 15.000',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, color: kDarkGreen),
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
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                Text(
                  'Rp ${total + 15000}', // Adding dummy delivery fee
                  style: GoogleFonts.inter(
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Checkout Now',
                  style: GoogleFonts.inter(
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
    final newQty = (item.quantity + change).clamp(1, 999);
    if (newQty == item.quantity) return;

    ref.read(cartControllerProvider.notifier).updateQuantity(item.cartItemId, newQty.toInt());
  }

  Future<void> _removeItem(
      BuildContext context, WidgetRef ref, dynamic id) async {
    ref.read(cartControllerProvider.notifier).removeItem(id);
    _showSnack(context, 'Item removed');
  }

  Future<void> _clearCart(BuildContext context, WidgetRef ref) async {
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
        style: GoogleFonts.inter(
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
