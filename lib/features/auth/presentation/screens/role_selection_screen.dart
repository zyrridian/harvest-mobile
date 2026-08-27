import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: WebConstrainedBox(
          maxWidth: 600,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5F2), // Light green tint
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.agriculture,
                      size: 50,
                      color: kDarkGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'How do you want to use Harvest?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  'Select your role to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: kTextGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Consumer Card
                _RoleCard(
                  title: 'Consumer',
                  description: 'Buy fresh produce directly from local farmers',
                  icon: PhosphorIconsRegular.basket,
                  onTap: () {
                    context.go('${AppRouter.login}?role=CONSUMER');
                  },
                ),

                const SizedBox(height: 20),

                // Farmer Card
                _RoleCard(
                  title: 'Farmer',
                  description:
                      'Sell your harvest and manage your farm operations',
                  icon: PhosphorIconsRegular.plant,
                  onTap: () {
                    context.go('${AppRouter.login}?role=PRODUCER');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPillGrey, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5F2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: kDarkGreen,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: kTextGrey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const PhosphorIcon(
              PhosphorIconsRegular.caretRight,
              color: kTextGrey,
            ),
          ],
        ),
      ),
    );
  }
}
