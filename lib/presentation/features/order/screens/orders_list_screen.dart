import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/providers/order_providers.dart';

class OrdersListScreen extends ConsumerStatefulWidget {
  static const routeName = '/orders';

  const OrdersListScreen({super.key});

  @override
  ConsumerState<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends ConsumerState<OrdersListScreen> {
  String _role = 'buyer';

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider({'role': _role}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Select Role'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        title: const Text('Buyer'),
                        value: 'buyer',
                        groupValue: _role,
                        onChanged: (v) {
                          setState(() => _role = v!);
                          Navigator.pop(ctx);
                        },
                      ),
                      RadioListTile(
                        title: const Text('Seller'),
                        value: 'seller',
                        groupValue: _role,
                        onChanged: (v) {
                          setState(() => _role = v!);
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) {
              final order = orders[idx];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('#${idx + 1}')),
                  title: Text(order.orderNumber),
                  subtitle: Text('${order.status} • Rp ${order.totalAmount}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/order-detail', arguments: order.orderId);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
