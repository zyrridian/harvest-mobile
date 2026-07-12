import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/domain/entities/address.dart';
import '../../providers/cart/cart_controller.dart';
import 'package:harvest_app/features/sales/presentation/providers/orders/order_providers.dart';
import 'package:harvest_app/features/users/presentation/providers/address_controller.dart';
import 'package:harvest_app/features/users/presentation/providers/address_state.dart';

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
  Address? _selectedAddress;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartControllerProvider);
    final addressState = ref.watch(addressControllerProvider);

    addressState.maybeWhen(
      data: (addresses) {
        if (_selectedAddress == null && addresses.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _selectedAddress == null) {
              try {
                final primary = addresses.firstWhere((a) => a.isPrimary);
                setState(() => _selectedAddress = primary);
              } catch (_) {
                setState(() => _selectedAddress = addresses.first);
              }
            }
          });
        }
      },
      orElse: () {},
    );

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
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: cartState.when(
        initial: () => const SizedBox.shrink(),
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

                // 2.5. DELIVERY ADDRESS (Only for home_delivery)
                if (_deliveryMethod == 'home_delivery') ...[
                  _buildSectionTitle('Delivery Address'),
                  const SizedBox(height: 12),
                  _buildAddressSection(addressState),
                  const SizedBox(height: 32),
                ],

                // 3. PAYMENT METHOD
                _buildSectionTitle('Payment Method'),
                const SizedBox(height: 12),
                _buildSelectableCard(
                  value: 'cod',
                  groupValue: _paymentMethod,
                  title: 'Cash on Delivery (COD)',
                  icon: Icons.money_outlined,
                  onTap: () => setState(() => _paymentMethod = 'cod'),
                  isWide: true,
                ),
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
                  value: 'e_wallet',
                  groupValue: _paymentMethod,
                  title: 'E-Wallet',
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () => setState(() => _paymentMethod = 'e_wallet'),
                  isWide: true,
                ),
                const SizedBox(height: 12),
                _buildSelectableCard(
                  value: 'credit_card',
                  groupValue: _paymentMethod,
                  title: 'Credit Card',
                  icon: Icons.credit_card_outlined,
                  onTap: () => setState(() => _paymentMethod = 'credit_card'),
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
                    style: GoogleFonts.inter(color: kDarkGreen),
                    decoration: InputDecoration(
                      hintText:
                          'Any special instructions? (e.g. Leave at door)',
                      hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
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
                        style: GoogleFonts.inter(
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
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                            ),
                          ),
                          Text(
                            'Rp ${cart.summary.grandTotal}',
                            style: GoogleFonts.inter(
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
        error: (e) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _handlePlaceOrder(cartState),
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
                style: GoogleFonts.inter(
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
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: kDarkGreen,
      ),
    );
  }

  Widget _buildAddressSection(AddressState addressState) {
    return addressState.maybeWhen(
      data: (addresses) {
        if (addresses.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kPillGrey),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_off_outlined, color: kTextGrey),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No saved addresses found. Please add an address in your profile.',
                    style: GoogleFonts.inter(color: kTextGrey),
                  ),
                ),
              ],
            ),
          );
        }

        final address = _selectedAddress ?? addresses.first;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kPillGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: kAccentOrange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        address.label.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen,
                          fontSize: 12,
                        ),
                      ),
                      if (address.isPrimary) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kDarkGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Primary',
                            style: GoogleFonts.inter(
                              color: kDarkGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showAddressSelectionSheet(addresses),
                    child: Text(
                      'Change',
                      style: GoogleFonts.inter(
                        color: kAccentOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                address.recipientName,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address.phone,
                style: GoogleFonts.inter(color: kTextGrey, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                '${address.fullAddress}\n${address.district}, ${address.city}, ${address.province} ${address.postalCode}',
                style: GoogleFonts.inter(color: kDarkGreen, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
      error: (e) => Center(child: Text('Error: $e')),
      orElse: () => const SizedBox.shrink(),
    );
  }

  void _showAddressSelectionSheet(List<Address> addresses) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Select Delivery Address',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final isSelected = _selectedAddress?.addressId == address.addressId;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAddress = address);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? kDarkGreen.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? kDarkGreen : kPillGrey,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                address.label.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? kDarkGreen : kTextGrey,
                                  fontSize: 12,
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: kDarkGreen, size: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            address.recipientName,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${address.fullAddress}, ${address.district}, ${address.city}',
                            style: GoogleFonts.inter(
                              color: kTextGrey,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
                style: GoogleFonts.inter(
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
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, color: kDarkGreen),
                ),
                Text(
                  '${item.quantity} x Rp ${item.subtotal ~/ item.quantity}',
                  style: GoogleFonts.inter(fontSize: 12, color: kTextGrey),
                ),
              ],
            ),
          ),
          Text(
            'Rp ${item.subtotal}',
            style: GoogleFonts.inter(
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
              style: GoogleFonts.inter(
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
          Text(label, style: GoogleFonts.inter(color: kTextGrey)),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: isDiscount ? kAccentOrange : kDarkGreen,
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC ---

  void _handlePlaceOrder(dynamic cartState) async {
    final selectedItems = cartState.maybeWhen(
      data: (cart) => cart.items
          .where((i) => ((i as dynamic).isSelected == true))
          .map((i) => ((i as dynamic).cartItemId as String))
          .toList(),
      orElse: () => <String>[],
    );

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items selected')),
      );
      return;
    }

    if (_deliveryMethod == 'home_delivery' && _selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    final Map<String, dynamic> payload = {
      "cart_item_ids": selectedItems,
      "delivery_method": _deliveryMethod,
      "payment_method": _paymentMethod,
      "delivery_date": DateTime.now().add(const Duration(days: 1)).toString().substring(0, 10),
    };

    if (_deliveryMethod == 'home_delivery') {
      payload["delivery_address_id"] = _selectedAddress!.addressId;
      payload["delivery_time_slot"] = "Morning (08:00 - 12:00)";
    }

    if (_notesController.text.trim().isNotEmpty) {
      payload["notes"] = _notesController.text.trim();
    }

    final createOrderUc = ref.read(createOrderUsecaseProvider);
    final res = await createOrderUc.call(payload: payload);

    res.fold(
      (l) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.message)),
      ),
      (r) async {
        final data = r['data'];
        if (data != null) {
          final paymentUrl = data['payment_url'] as String?;
          if (paymentUrl != null && paymentUrl.isNotEmpty) {
            final uri = Uri.parse(paymentUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          }

          final orders = data['orders'] as List<dynamic>?;
          final orderId = (orders != null && orders.isNotEmpty) 
              ? orders.first['order_id'] ?? 'ord_unknown' 
              : 'ord_unknown';
          final orderNumber = (orders != null && orders.isNotEmpty) 
              ? orders.first['order_number'] ?? 'ORD-000000' 
              : 'ORD-000000';

          if (context.mounted) {
            context.go('${AppRouter.orderSuccess}?orderId=$orderId&orderNumber=$orderNumber');
          }
        }
      },
    );
  }
}
