import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/router/app_router.dart';
import '../../../shared_widgets/app_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: 'Home',
      showBackButton: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.agriculture,
              size: 100,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Harvest App',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text('You are now logged in!'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.push(
                    '${AppRouter.productDetail}?productId=prd_1234567890abcdef');
              },
              icon: const Icon(Icons.shopping_bag),
              label: const Text('View Product Detail (Demo)'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
