import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/providers/cart_providers.dart';

class CartScreen extends ConsumerWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cartAsync.when(
        data: (cart) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: cart.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, idx) {
              final item = cart.items[idx];
              return ListTile(
                leading: CircleAvatar(
                    child: Text(item.name.isNotEmpty ? item.name[0] : '?')),
                title: Text(item.name),
                subtitle: Text('Qty: ${item.quantity} • Rp ${item.subtotal}'),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () async {
                        // simulate decrease quantity
                        final newQty = (item.quantity - 1).clamp(1, 999);
                        final uc = ref.read(updateCartItemUsecaseProvider);
                        final res = await uc.call(
                            cartItemId: item.cartItemId, quantity: newQty);
                        res.fold(
                            (l) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.message ?? 'Error'))),
                            (r) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Quantity updated')));
                          ref.refresh(cartProvider);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () async {
                        final newQty = (item.quantity + 1).clamp(1, 999);
                        final uc = ref.read(updateCartItemUsecaseProvider);
                        final res = await uc.call(
                            cartItemId: item.cartItemId, quantity: newQty);
                        res.fold(
                            (l) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.message ?? 'Error'))),
                            (r) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Quantity updated')));
                          ref.refresh(cartProvider);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final uc = ref.read(removeCartItemUsecaseProvider);
                        final res = await uc.call(cartItemId: item.cartItemId);
                        res.fold(
                            (l) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.message ?? 'Error'))),
                            (r) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item removed')));
                          ref.refresh(cartProvider);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // validate & checkout -> navigate to checkout screen
                    final validateUc = ref.read(validateCartUsecaseProvider);
                    final res = await validateUc.call();
                    res.fold(
                        (l) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l.message ?? 'Error'))),
                        (r) {
                      Navigator.of(context).pushNamed('/checkout');
                    });
                  },
                  child: const Text('Checkout'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () async {
                  final uc = ref.read(clearCartUsecaseProvider);
                  final res = await uc.call();
                  res.fold(
                      (l) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.message ?? 'Error'))), (r) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cart cleared')));
                    ref.refresh(cartProvider);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
