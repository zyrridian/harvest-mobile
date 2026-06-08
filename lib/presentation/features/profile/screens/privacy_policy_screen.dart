import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
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
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Last Updated
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kDarkGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDarkGreen.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.update, color: kDarkGreen, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Last updated: December 25, 2025',
                  style: GoogleFonts.dmSans(
                    color: kDarkGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Introduction
          _buildSection(
            title: 'Introduction',
            content:
                'At Harvest, we respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, and safeguard your information when you use our mobile application and services.',
          ),

          _buildSection(
            title: '1. Information We Collect',
            subsections: [
              {
                'subtitle': 'Personal Information',
                'content':
                    'We collect information you provide directly, including:\n\n• Name, email address, and phone number\n• Delivery addresses and location data\n• Payment information (processed securely through our payment partners)\n• Profile photo and preferences',
              },
              {
                'subtitle': 'Usage Data',
                'content':
                    'We automatically collect:\n\n• Device information (type, operating system, unique identifiers)\n• App usage data and interactions\n• Location data (with your permission)\n• Purchase history and browsing behavior',
              },
            ],
          ),

          _buildSection(
            title: '2. How We Use Your Information',
            content:
                'We use the collected information to:\n\n• Process and deliver your orders\n• Provide customer support and respond to inquiries\n• Send order updates and notifications\n• Improve our services and user experience\n• Personalize content and recommendations\n• Detect and prevent fraud\n• Comply with legal obligations',
          ),

          _buildSection(
            title: '3. Information Sharing',
            content:
                'We share your information only with:\n\n• Local farmers and vendors to fulfill your orders\n• Payment processors for secure transactions\n• Delivery partners for order fulfillment\n• Service providers who assist in operating our platform\n• Law enforcement when required by law\n\nWe never sell your personal information to third parties.',
          ),

          _buildSection(
            title: '4. Data Security',
            content:
                'We implement industry-standard security measures to protect your data:\n\n• Encryption of sensitive information in transit and at rest\n• Regular security audits and updates\n• Secure payment processing through PCI-DSS compliant partners\n• Access controls and authentication measures\n• Employee training on data protection',
          ),

          _buildSection(
            title: '5. Your Rights',
            content:
                'You have the right to:\n\n• Access your personal data\n• Correct inaccurate information\n• Request deletion of your account and data\n• Opt-out of marketing communications\n• Withdraw consent for data processing\n• Export your data in a portable format\n• Object to automated decision-making',
          ),

          _buildSection(
            title: '6. Cookies and Tracking',
            content:
                'We use cookies and similar technologies to:\n\n• Remember your preferences and settings\n• Analyze app usage and performance\n• Provide personalized content\n• Enable secure authentication\n\nYou can manage cookie preferences in your device settings.',
          ),

          _buildSection(
            title: '7. Children\'s Privacy',
            content:
                'Our services are not intended for children under 13 years of age. We do not knowingly collect personal information from children. If you believe we have collected information from a child, please contact us immediately.',
          ),

          _buildSection(
            title: '8. Changes to This Policy',
            content:
                'We may update this privacy policy periodically. We will notify you of significant changes through the app or via email. Continued use of our services after changes constitutes acceptance of the updated policy.',
          ),

          _buildSection(
            title: '9. Contact Us',
            content:
                'If you have questions or concerns about this privacy policy or our data practices, please contact us:\n\nEmail: privacy@harvestapp.com\nPhone: +1 (555) 123-4567\nAddress: 123 Farm Lane, Green Valley, CA 94000',
          ),

          const SizedBox(height: 16),

          // Contact Support Card
          Container(
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
                Icon(Icons.privacy_tip_outlined, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Questions about your privacy?',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Our team is here to help you understand how we protect your data',
                  style: GoogleFonts.dmSans(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Contact support
                  },
                  icon: const Icon(Icons.email_outlined, color: kDarkGreen),
                  label: Text(
                    'Contact Privacy Team',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kDarkGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? content,
    List<Map<String, String>>? subsections,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 12),
          if (content != null)
            Text(
              content,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: kTextGrey,
                height: 1.7,
              ),
            ),
          if (subsections != null)
            ...subsections.map((subsection) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subsection['subtitle']!,
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kDarkGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subsection['content']!,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: kTextGrey,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
