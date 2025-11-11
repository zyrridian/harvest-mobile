import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/providers/order_providers.dart';

class OrderDetailScreen extends ConsumerWidget {
  static const routeName = '/order-detail';

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Order Detail')),
      body: orderAsync.when(
        data: (order) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Order Number:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(order.orderNumber),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Chip(label: Text(order.status)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Rp ${order.totalAmount}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Seller:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListTile(
                leading: CircleAvatar(
                    child: Text(order.seller.name.isNotEmpty
                        ? order.seller.name[0]
                        : 'S')),
                title: Text(order.seller.name),
                subtitle: Text('ID: ${order.seller.userId}'),
              ),
              const SizedBox(height: 16),
              const Text('Items:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...order.items.map((item) {
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      'Qty: ${item.quantity} • Unit Price: Rp ${item.unitPrice}'),
                  trailing: Text('Rp ${item.subtotal}'),
                );
              }).toList(),
              const SizedBox(height: 16),
              const Text('Delivery:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListTile(
                title: Text('Method: ${order.delivery.method}'),
                subtitle: Text('Address: ${order.delivery.address ?? 'N/A'}'),
                trailing: Text('Fee: Rp ${order.delivery.fee}'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final uc = ref.read(cancelOrderUsecaseProvider);
                  final res = await uc.call(
                    orderId: orderId,
                    payload: {
                      "reason": "changed_mind",
                      "details": "User cancelled from app",
                      "request_refund": true,
                    },
                  );
                  res.fold(
                    (l) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l.message ?? 'Error'))),
                    (r) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order cancelled')));
                      ref.refresh(orderDetailProvider(orderId));
                    },
                  );
                },
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel Order'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
