import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/providers/cart_providers.dart';
import 'package:harvest_app/presentation/providers/order_providers.dart';

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
      appBar: AppBar(title: const Text('Checkout')),
      body: cartAsync.when(
        data: (cart) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text('Review your order',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...cart.items.where((i) => i.isSelected).map((item) {
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Qty: ${item.quantity} • Rp ${item.subtotal}'),
                );
              }),
              const Divider(height: 32),
              const Text('Delivery Method:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('Home Delivery'),
                value: 'home_delivery',
                groupValue: _deliveryMethod,
                onChanged: (v) => setState(() => _deliveryMethod = v!),
              ),
              RadioListTile<String>(
                title: const Text('Self Pickup'),
                value: 'self_pickup',
                groupValue: _deliveryMethod,
                onChanged: (v) => setState(() => _deliveryMethod = v!),
              ),
              const Divider(height: 32),
              const Text('Payment Method:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              RadioListTile<String>(
                title: const Text('Bank Transfer'),
                value: 'bank_transfer',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              RadioListTile<String>(
                title: const Text('E-Wallet'),
                value: 'ewallet',
                groupValue: _paymentMethod,
                onChanged: (v) => setState(() => _paymentMethod = v!),
              ),
              const Divider(height: 32),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder()),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Summary',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('Rp ${cart.summary.subtotal}')
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Discount'),
                            Text('- Rp ${cart.summary.totalDiscount}')
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery'),
                            Text('Rp ${cart.summary.totalDeliveryFee}')
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Service fee'),
                            Text('Rp ${cart.summary.serviceFee}')
                          ]),
                      const Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grand Total',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Rp ${cart.summary.grandTotal}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ]),
                    ],
                  ),
                ),
              )
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              final selectedItems = cartAsync.when(
                data: (cart) => cart.items
                    .where((i) => i.isSelected)
                    .map((i) => i.cartItemId)
                    .toList(),
                loading: () => <String>[],
                error: (e, st) => <String>[],
              );
              if (selectedItems.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No items selected')));
                return;
              }

              final payload = {
                "cart_item_ids": selectedItems,
                "delivery_address_id": "addr_123",
                "delivery_method": _deliveryMethod,
                "delivery_date":
                    DateTime.now().add(const Duration(days: 1)).toString(),
                "delivery_time_slot": "morning",
                "payment_method": _paymentMethod,
                "notes": _notesController.text.trim(),
                "use_wallet_balance": false,
              };

              final createOrderUc = ref.read(createOrderUsecaseProvider);
              final res = await createOrderUc.call(payload: payload);

              res.fold(
                (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(l.message))),
                (r) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Order created successfully!')));
                  Navigator.of(context).pushReplacementNamed('/orders');
                },
              );
            },
            child: const Text('Place Order'),
          ),
        ),
      ),
    );
  }
}
