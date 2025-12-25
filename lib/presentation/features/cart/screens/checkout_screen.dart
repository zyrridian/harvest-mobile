import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/presentation/providers/cart_providers.dart';
import 'package:harvest_app/presentation/providers/order_providers.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class CheckoutScreen extends ConsumerStatefulWidget {
  static const routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _notesController = TextEditingController();
  String _deliveryMethod = 'home_delivery';
  String _paymentMethod = 'bank_transfer';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);

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
          'Checkout',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: cartAsync.when(
        data: (cart) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                24, 8, 24, 100), // Bottom padding for FAB
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. ITEMS REVIEW
                _buildSectionTitle('Your Items'),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.items.where((i) => i.isSelected).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item =
                        cart.items.where((i) => i.isSelected).toList()[index];
                    return _buildCheckoutItemCard(item);
                  },
                ),

                const SizedBox(height: 32),

                // 2. DELIVERY METHOD
                _buildSectionTitle('Delivery Method'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSelectableCard(
                        value: 'home_delivery',
                        groupValue: _deliveryMethod,
                        title: 'Home Delivery',
                        icon: Icons.local_shipping_outlined,
                        onTap: () =>
                            setState(() => _deliveryMethod = 'home_delivery'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSelectableCard(
                        value: 'self_pickup',
                        groupValue: _deliveryMethod,
                        title: 'Self Pickup',
                        icon: Icons.storefront_outlined,
                        onTap: () =>
                            setState(() => _deliveryMethod = 'self_pickup'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 3. PAYMENT METHOD
                _buildSectionTitle('Payment Method'),
                const SizedBox(height: 12),
                _buildSelectableCard(
                  value: 'bank_transfer',
                  groupValue: _paymentMethod,
                  title: 'Bank Transfer',
                  icon: Icons.account_balance_outlined,
                  onTap: () => setState(() => _paymentMethod = 'bank_transfer'),
                  isWide: true,
                ),
                const SizedBox(height: 12),
                _buildSelectableCard(
                  value: 'ewallet',
                  groupValue: _paymentMethod,
                  title: 'E-Wallet',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () => setState(() => _paymentMethod = 'ewallet'),
                  isWide: true,
                ),

                const SizedBox(height: 32),

                // 4. NOTES
                _buildSectionTitle('Delivery Notes'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPillGrey),
                  ),
                  child: TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: GoogleFonts.dmSans(color: kDarkGreen),
                    decoration: InputDecoration(
                      hintText:
                          'Any special instructions? (e.g. Leave at door)',
                      hintStyle: GoogleFonts.dmSans(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 5. ORDER SUMMARY CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: kPillGrey),
                    boxShadow: [
                      BoxShadow(
                        color: kDarkGreen.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                          'Subtotal', 'Rp ${cart.summary.subtotal}'),
                      _buildSummaryRow(
                          'Discount', '- Rp ${cart.summary.totalDiscount}',
                          isDiscount: true),
                      _buildSummaryRow(
                          'Delivery', 'Rp ${cart.summary.totalDeliveryFee}'),
                      _buildSummaryRow(
                          'Service Fee', 'Rp ${cart.summary.serviceFee}'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: kPillGrey),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: GoogleFonts.dmSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                          ),
                          Text(
                            'Rp ${cart.summary.grandTotal}',
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kAccentOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _handlePlaceOrder(cartAsync),
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Place Order',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

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

  Widget _buildCheckoutItemCard(dynamic item) {
    // Assuming 'item' has name, quantity, subtotal.
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                item.name.isNotEmpty ? item.name[0] : '?',
                style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.bold, color: kDarkGreen),
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
                      fontWeight: FontWeight.w600, color: kDarkGreen),
                ),
                Text(
                  '${item.quantity} x Rp ${item.subtotal ~/ item.quantity}',
                  style: GoogleFonts.dmSans(fontSize: 12, color: kTextGrey),
                ),
              ],
            ),
          ),
          Text(
            'Rp ${item.subtotal}',
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold, color: kDarkGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableCard({
    required String value,
    required String groupValue,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isWide = false,
  }) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? kDarkGreen.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kDarkGreen : kPillGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment:
              isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? kDarkGreen : kTextGrey,
              size: 24,
            ),
            SizedBox(width: isWide ? 16 : 8),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? kDarkGreen : kTextGrey,
              ),
            ),
            if (isWide) ...[
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, color: kDarkGreen, size: 20),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.dmSans(color: kTextGrey)),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              color: isDiscount ? kAccentOrange : kDarkGreen,
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC ---

  void _handlePlaceOrder(AsyncValue<dynamic> cartAsync) async {
    final selectedItems = cartAsync.when(
      data: (cart) => cart.items
          .where((i) => (i as dynamic).isSelected) // Cast if needed
          .map((i) => (i as dynamic).cartItemId)
          .toList(),
      loading: () => <String>[],
      error: (e, st) => <String>[],
    );

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items selected')),
      );
      return;
    }

    final payload = {
      "cart_item_ids": selectedItems,
      "delivery_address_id":
          "addr_123", // You might want to make this dynamic later
      "delivery_method": _deliveryMethod,
      "delivery_date": DateTime.now().add(const Duration(days: 1)).toString(),
      "delivery_time_slot": "morning",
      "payment_method": _paymentMethod,
      "notes": _notesController.text.trim(),
      "use_wallet_balance": false,
    };

    final createOrderUc = ref.read(createOrderUsecaseProvider);
    final res = await createOrderUc.call(payload: payload);

    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.message)),
      ),
      (r) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order created successfully!')),
        );
        context.push(AppRouter.orderDetail);
      },
    );
  }
}
