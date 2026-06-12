import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
          'About Us',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // App Logo/Hero Section
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kDarkGreen, kDarkGreen.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: kDarkGreen.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 64,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Harvest',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Farm to Table, Simplified',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Version 1.0.0',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Mission Section
          _buildInfoCard(
            icon: Icons.favorite_border,
            iconColor: kAccentOrange,
            title: 'Our Mission',
            content:
                'Harvest bridges the gap between local farmers and conscious consumers. We believe in supporting sustainable agriculture, reducing food miles, and ensuring fresh, quality produce reaches your table directly from the farm.',
          ),

          // Story Section
          _buildInfoCard(
            icon: Icons.auto_stories_outlined,
            iconColor: kDarkGreen,
            title: 'Our Story',
            content:
                'Founded in 2024, Harvest was born from a simple idea: what if everyone could have access to farm-fresh produce with just a few taps? We started with 5 local farmers and have grown to partner with over 500 farmers across the region, delivering fresh produce to thousands of happy customers every day.',
          ),

          // Values Section
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kDarkGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.stars, color: kDarkGreen, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Our Values',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildValueItem(
                  icon: Icons.verified_outlined,
                  title: 'Quality First',
                  description:
                      'Every product is carefully selected and verified',
                ),
                _buildValueItem(
                  icon: Icons.handshake_outlined,
                  title: 'Fair Trade',
                  description: 'Supporting farmers with fair pricing',
                ),
                _buildValueItem(
                  icon: Icons.eco_outlined,
                  title: 'Sustainability',
                  description: 'Promoting eco-friendly farming practices',
                ),
                _buildValueItem(
                  icon: Icons.people_outline,
                  title: 'Community',
                  description:
                      'Building connections between farmers and consumers',
                ),
              ],
            ),
          ),

          // Statistics
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPillGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By the Numbers',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('500+', 'Partner Farmers'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('50K+', 'Happy Customers'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('1M+', 'Orders Delivered'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('25+', 'Cities Served'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Contact/Social Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPillGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get in Touch',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: 'hello@harvestapp.com',
                  onTap: () => _launchURL('mailto:hello@harvestapp.com'),
                ),
                _buildContactItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: '+1 (555) 123-4567',
                  onTap: () => _launchURL('tel:+15551234567'),
                ),
                _buildContactItem(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: '123 Farm Lane, Green Valley, CA 94000',
                ),
                const SizedBox(height: 20),
                Divider(color: kPillGrey),
                const SizedBox(height: 20),
                Text(
                  'Follow Us',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSocialButton(
                      icon: Icons.facebook,
                      onTap: () =>
                          _launchURL('https://facebook.com/harvestapp'),
                    ),
                    _buildSocialButton(
                      icon: Icons.camera_alt,
                      onTap: () =>
                          _launchURL('https://instagram.com/harvestapp'),
                    ),
                    _buildSocialButton(
                      icon: Icons.alternate_email,
                      onTap: () => _launchURL('https://twitter.com/harvestapp'),
                    ),
                    _buildSocialButton(
                      icon: Icons.play_arrow,
                      onTap: () => _launchURL('https://youtube.com/harvestapp'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Legal Links
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              TextButton(
                onPressed: () {
                  // Navigate to terms
                },
                child: Text(
                  'Terms of Service',
                  style: GoogleFonts.inter(
                    color: kTextGrey,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text('•', style: TextStyle(color: kTextGrey)),
              TextButton(
                onPressed: () {
                  // Navigate to privacy
                },
                child: Text(
                  'Privacy Policy',
                  style: GoogleFonts.inter(
                    color: kTextGrey,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            '© 2024 Harvest. All rights reserved.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: kTextGrey,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: kTextGrey,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kDarkGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: kTextGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kDarkGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kDarkGreen.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kDarkGreen,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: kTextGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(icon, color: kDarkGreen, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: kTextGrey,
                      ),
                    ),
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kDarkGreen,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.arrow_forward_ios, color: kTextGrey, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kDarkGreen.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kDarkGreen.withOpacity(0.1)),
          ),
          child: Icon(icon, color: kDarkGreen, size: 20),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
