import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/features/users/domain/entities/address.dart';
import '../../providers/cart/cart_controller.dart';
import 'package:harvest_app/features/sales/presentation/providers/orders/order_providers.dart';
import 'package:harvest_app/features/users/presentation/providers/address_controller.dart';
import 'package:harvest_app/features/users/presentation/providers/address_state.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kCream = Color(0xFFF0EAD6);
const kAccentOrange = kDarkGreen;
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
  String _paymentMethod = 'online_payment';
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
            'Checkout',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
          ),
          centerTitle: true,
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
                          icon: PhosphorIconsRegular.truck,
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
                          icon: PhosphorIconsRegular.storefront,
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
                    icon: PhosphorIconsRegular.money,
                    onTap: () => setState(() => _paymentMethod = 'cod'),
                    isWide: true,
                  ),
                  const SizedBox(height: 12),
                  _buildSelectableCard(
                    value: 'online_payment',
                    groupValue: _paymentMethod,
                    title: 'Online Payment (Midtrans)',
                    icon: PhosphorIconsRegular.creditCard,
                    onTap: () =>
                        setState(() => _paymentMethod = 'online_payment'),
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
                      style: TextStyle(color: kDarkGreen),
                      decoration: InputDecoration(
                        hintText:
                            'Any special instructions? (e.g. Leave at door)',
                        hintStyle: TextStyle(color: Colors.grey[400]),
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
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: kDarkGreen.withOpacity(0.05),
                      //     blurRadius: 10,
                      //     offset: const Offset(0, 4),
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                            'Subtotal',
                            NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(cart.summary.subtotal)),
                        _buildSummaryRow('Discount',
                            '- ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(cart.summary.totalDiscount)}',
                            isDiscount: true),
                        _buildSummaryRow(
                            'Delivery',
                            NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(cart.summary.totalDeliveryFee)),
                        _buildSummaryRow(
                            'Service Fee',
                            NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(cart.summary.serviceFee)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: kPillGrey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: 'id_ID',
                                      symbol: 'Rp ',
                                      decimalDigits: 0)
                                  .format(cart.summary.grandTotal),
                              style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
      style: TextStyle(
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
            child: Column(
              children: [
                Row(
                  children: [
                    const PhosphorIcon(PhosphorIconsRegular.mapPinLine,
                        color: kTextGrey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No saved addresses found. Please add an address in your profile.',
                        style: TextStyle(color: kTextGrey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push(AppRouter.addresses),
                    icon:
                        const PhosphorIcon(PhosphorIconsRegular.plus, size: 18),
                    label: const Text('Add Address'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kDarkGreen,
                      side: const BorderSide(color: kDarkGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                      PhosphorIcon(PhosphorIconsRegular.mapPin,
                          color: kAccentOrange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        address.label.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen,
                          fontSize: 12,
                        ),
                      ),
                      if (address.isPrimary) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kDarkGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Primary',
                            style: TextStyle(
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
                      style: TextStyle(
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address.phone,
                style: TextStyle(color: kTextGrey, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Text(
                '${address.fullAddress}\n${address.district}, ${address.city}, ${address.province} ${address.postalCode}',
                style: TextStyle(color: kDarkGreen, fontSize: 13, height: 1.4),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: kDarkGreen)),
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
              style: TextStyle(
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
                  final isSelected =
                      _selectedAddress?.addressId == address.addressId;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAddress = address);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? kDarkGreen.withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? kDarkGreen : kPillGrey,
                          width: 1,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? kDarkGreen : kTextGrey,
                                  fontSize: 12,
                                ),
                              ),
                              if (isSelected)
                                const PhosphorIcon(
                                    PhosphorIconsFill.checkCircle,
                                    color: kDarkGreen,
                                    size: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            address.recipientName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kDarkGreen,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${address.fullAddress}, ${address.district}, ${address.city}',
                            style: TextStyle(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(AppRouter.addresses);
                  },
                  icon: const PhosphorIcon(PhosphorIconsRegular.plus, size: 18),
                  label: const Text('Add New Address'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kDarkGreen,
                    side: const BorderSide(color: kDarkGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 50,
              height: 50,
              color: kPillGrey,
              child: _buildProductImage(item.imageUrl, item.name),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: kDarkGreen),
                ),
                Text(
                  '${item.quantity} x ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.subtotal ~/ item.quantity)}',
                  style: TextStyle(fontSize: 12, color: kTextGrey),
                ),
              ],
            ),
          ),
          Text(
            NumberFormat.currency(
                    locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                .format(item.subtotal),
            style: TextStyle(fontWeight: FontWeight.bold, color: kDarkGreen),
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
            width: 1,
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
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? kDarkGreen : kTextGrey,
              ),
            ),
            if (isWide) ...[
              const Spacer(),
              if (isSelected)
                const PhosphorIcon(PhosphorIconsFill.checkCircle,
                    color: kDarkGreen, size: 20),
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
          Text(label, style: TextStyle(color: kTextGrey)),
          Text(
            value,
            style: TextStyle(
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
      "delivery_date": DateTime.now()
          .add(const Duration(days: 1))
          .toString()
          .substring(0, 10),
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
            context.go(
                '${AppRouter.orderSuccess}?orderId=$orderId&orderNumber=$orderNumber&paymentMethod=$_paymentMethod');
          }
        }
      },
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
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: kDarkGreen.withOpacity(0.4),
        ),
      ),
    );
  }
}
