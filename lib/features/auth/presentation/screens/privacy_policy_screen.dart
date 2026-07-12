import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGrey = Color(0xFF6E7A75);

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Harvest Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Last Updated: July 12, 2026',
                style: TextStyle(
                  fontSize: 14,
                  color: kTextGrey,
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '1. Information We Collect',
                content: 'We collect information you provide directly to us, such as when you create or modify your account, request on-demand services, contact customer support, or otherwise communicate with us. This information may include: name, email, phone number, postal address, profile picture, payment method, items requested (for delivery services), delivery notes, and other information you choose to provide.',
              ),
              _buildSection(
                title: '2. How We Use Information',
                content: 'We may use the information we collect about you to provide, maintain, and improve our Services, including, for example, to facilitate payments, send receipts, provide products and services you request (and send related information), develop new features, provide customer support to Users and Farmers, develop safety features, authenticate users, and send product updates and administrative messages.',
              ),
              _buildSection(
                title: '3. Sharing of Information',
                content: 'We may share the information we collect about you as described in this Statement or as described at the time of collection or sharing, including with Farmers to enable them to provide the Services you request.',
              ),
              _buildSection(
                title: '4. Security',
                content: 'We take reasonable measures to help protect information about you from loss, theft, misuse and unauthorized access, disclosure, alteration and destruction.',
              ),
              _buildSection(
                title: '5. Contact Us',
                content: 'If you have any questions about this Privacy Statement, please contact us at privacy@harvestapp.com.',
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              color: kTextGrey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
