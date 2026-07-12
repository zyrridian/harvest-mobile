import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGrey = Color(0xFF6E7A75);

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
          'Terms of Service',
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
                'Harvest Terms of Service',
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
                title: '1. Acceptance of Terms',
                content: 'By accessing and using Harvest, you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any part of these terms, you may not use our service.',
              ),
              _buildSection(
                title: '2. User Accounts',
                content: 'When you create an account with us, you must provide information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account.',
              ),
              _buildSection(
                title: '3. Purchases and Payments',
                content: 'If you wish to purchase any product or service made available through Harvest, you may be asked to supply certain information relevant to your Purchase including, without limitation, your credit card number, expiration date, billing address, and shipping information.',
              ),
              _buildSection(
                title: '4. Farmer Responsibilities',
                content: 'Farmers must accurately represent their produce, including its origin, farming methods (e.g., organic), and availability. Harvest reserves the right to remove any listings that violate our community standards.',
              ),
              _buildSection(
                title: '5. Limitation of Liability',
                content: 'In no event shall Harvest, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
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
