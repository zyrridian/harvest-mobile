import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _faqCategories = [
    {
      'title': 'Getting Started',
      'icon': PhosphorIconsRegular.rocketLaunch,
      'questions': [
        {
          'q': 'How do I create an account?',
          'a':
              'To create an account, tap on "Sign Up" on the login screen. Fill in your details including name, email, and password. You\'ll receive a verification email to confirm your account.',
        },
        {
          'q': 'How do I place my first order?',
          'a':
              'Browse products from local farmers, add items to your cart, then tap the cart icon. Review your items, add delivery address, and complete payment to place your order.',
        },
        {
          'q': 'What payment methods are accepted?',
          'a':
              'We accept credit/debit cards, digital wallets, bank transfers, and cash on delivery for eligible orders.',
        },
      ],
    },
    {
      'title': 'Orders & Delivery',
      'icon': PhosphorIconsRegular.truck,
      'questions': [
        {
          'q': 'How can I track my order?',
          'a':
              'Go to "My Orders" in your profile to see real-time tracking of your delivery. You\'ll receive notifications at each stage of the delivery process.',
        },
        {
          'q': 'What are the delivery hours?',
          'a':
              'Standard delivery is available between 8 AM - 8 PM. Premium members get access to early morning (6 AM) and late evening (9 PM) slots.',
        },
        {
          'q': 'Can I change my delivery address?',
          'a':
              'Yes, you can change the delivery address before the order is dispatched. Go to order details and tap "Change Address".',
        },
        {
          'q': 'What if I\'m not home during delivery?',
          'a':
              'You can provide special delivery instructions when placing your order. Alternatively, reschedule delivery through the order tracking page.',
        },
      ],
    },
    {
      'title': 'Products & Farmers',
      'icon': PhosphorIconsRegular.plant,
      'questions': [
        {
          'q': 'How do I know products are fresh?',
          'a':
              'All products are sourced directly from local farmers and delivered within 24-48 hours of harvest. Each product listing shows harvest date and farmer information.',
        },
        {
          'q': 'Can I contact farmers directly?',
          'a':
              'Yes! Tap on any farmer\'s profile to view their story and send them a message. Build relationships with your local food providers.',
        },
        {
          'q': 'Are the products organic?',
          'a':
              'Products marked with the "Organic" badge are certified organic. Filter by "Organic" in search to find certified products.',
        },
      ],
    },
    {
      'title': 'Premium Subscription',
      'icon': PhosphorIconsRegular.crown,
      'questions': [
        {
          'q': 'What benefits do Premium members get?',
          'a':
              'Premium members enjoy free delivery, exclusive deals, priority support, early access to seasonal products, and flexible delivery time slots.',
        },
        {
          'q': 'How much does Premium cost?',
          'a':
              'Premium subscription is \$9.99/month or \$99/year (save 17%). Cancel anytime with no commitment.',
        },
        {
          'q': 'Can I try Premium before subscribing?',
          'a':
              'Yes! New users get a 14-day free trial of Premium. Cancel anytime during the trial period at no charge.',
        },
      ],
    },
    {
      'title': 'Account & Security',
      'icon': PhosphorIconsRegular.shieldCheck,
      'questions': [
        {
          'q': 'How do I reset my password?',
          'a':
              'Tap "Forgot Password" on the login screen. Enter your email and we\'ll send you a password reset link.',
        },
        {
          'q': 'Is my payment information secure?',
          'a':
              'Yes, we use bank-level encryption and never store your full card details. All transactions are processed through secure payment gateways.',
        },
        {
          'q': 'How do I delete my account?',
          'a':
              'Go to Settings > Account > Delete Account. Note that this action is permanent and cannot be undone.',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredCategories {
    if (_searchQuery.isEmpty) return _faqCategories;

    return _faqCategories
        .map((category) {
          final filteredQuestions = (category['questions'] as List)
              .where((qa) =>
                  qa['q'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  qa['a'].toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          return {
            ...category,
            'questions': filteredQuestions,
          };
        })
        .where((category) => (category['questions'] as List).isNotEmpty)
        .toList();
  }

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help Center',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search for help...',
                hintStyle: TextStyle(color: kTextGrey),
                prefixIcon: const PhosphorIcon(PhosphorIconsRegular.magnifyingGlass, color: kTextGrey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const PhosphorIcon(PhosphorIconsRegular.x, color: kTextGrey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPillGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPillGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kDarkGreen, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          // FAQ Categories
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return _buildCategorySection(
                  title: category['title'],
                  icon: category['icon'],
                  questions: category['questions'],
                );
              },
            ),
          ),

          // Contact Support Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kDarkGreen, kDarkGreen.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kDarkGreen.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Still need help?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our support team is available 24/7',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Open chat support
                          },
                          icon: const PhosphorIcon(PhosphorIconsRegular.chatCircle, size: 18, color: kDarkGreen,),
                          label: Text(
                            'Chat',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kDarkGreen,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Open email support
                          },
                          icon: const PhosphorIcon(PhosphorIconsRegular.envelope, size: 18, color: Colors.white,),
                          label: Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required IconData icon,
    required List<Map<String, String>> questions,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kDarkGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: PhosphorIcon(icon, color: kDarkGreen, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
              ],
            ),
          ),
          ...questions.asMap().entries.map((entry) {
            final index = entry.key;
            final qa = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: kPillGrey,
                    indent: 20,
                    endIndent: 20,
                  ),
                _buildFAQItem(
                  question: qa['q']!,
                  answer: qa['a']!,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Text(
          question,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: kDarkGreen,
          ),
        ),
        iconColor: kDarkGreen,
        collapsedIconColor: kTextGrey,
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              color: kTextGrey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
