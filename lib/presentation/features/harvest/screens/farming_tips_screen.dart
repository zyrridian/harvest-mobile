import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared_widgets/app_cached_image.dart';
// import '../../../../core/config/theme/app_colors.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class FarmingTipsScreen extends ConsumerStatefulWidget {
  const FarmingTipsScreen({super.key});

  @override
  ConsumerState<FarmingTipsScreen> createState() => _FarmingTipsScreenState();
}

class _FarmingTipsScreenState extends ConsumerState<FarmingTipsScreen> {
  String selectedCategory = 'All';
  final Set<String> bookmarkedTips = {};

  final List<String> categories = [
    'All',
    'Home Gardening',
    'Composting',
    'Preservation',
    'Pest Control',
    'Irrigation',
    'Soil Health',
  ];

  // Mock Data (Kept from your snippet)
  final List<FarmingTipDetail> tips = [
    FarmingTipDetail(
      title: 'Starting a Home Vegetable Garden',
      category: 'Home Gardening',
      imageUrl:
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
      excerpt:
          'Learn the essential steps to start your own productive vegetable garden at home.',
      content: '''
Starting a home vegetable garden is easier than you think. Follow these steps for success:

**1. Choose the Right Location**
• Find a spot with at least 6-8 hours of sunlight
• Ensure good drainage
• Close to water source
• Protected from strong winds

**2. Prepare the Soil**
• Test soil pH (6.0-7.0 is ideal for most vegetables)
• Add organic matter (compost, aged manure)
• Remove rocks and debris
• Till or dig to 8-12 inches deep

**3. Select Your Crops**
• Start with easy vegetables: tomatoes, lettuce, radishes, beans
• Consider your climate and season
• Choose disease-resistant varieties
• Plan for succession planting

**4. Planting Tips**
• Follow spacing recommendations on seed packets
• Plant in blocks rather than single rows for better pollination
• Water gently after planting
• Mulch to retain moisture and suppress weeds

**5. Maintenance**
• Water deeply but less frequently (1 inch per week)
• Weed regularly while weeds are small
• Fertilize every 3-4 weeks
• Monitor for pests and diseases

**6. Common Mistakes to Avoid**
• Planting too early in the season
• Overcrowding plants
• Inconsistent watering
• Not preparing soil properly
• Ignoring pest problems until it's too late
''',
      author: 'Sarah Green',
      publishDate: DateTime.now().subtract(const Duration(days: 3)),
      likes: 245,
      comments: 42,
    ),
    // ... Add more tips from your original list if needed
    FarmingTipDetail(
      title: 'Natural Pest Control Solutions',
      category: 'Pest Control',
      imageUrl:
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400',
      excerpt:
          'Protect your crops without harmful chemicals using these organic methods.',
      content: 'Content placeholder...',
      author: 'Ahmad Wijaya',
      publishDate: DateTime.now().subtract(const Duration(days: 10)),
      likes: 312,
      comments: 67,
    ),
  ];

  List<FarmingTipDetail> get filteredTips {
    if (selectedCategory == 'All') return tips;
    return tips.where((tip) => tip.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Farming Tips',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kPillGrey),
                ),
                child: const Icon(Icons.bookmark_outline,
                    color: kDarkGreen, size: 20),
              ),
              onPressed: _showBookmarkedTips,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. CATEGORY FILTER
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return _buildModernFilterChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => setState(() => selectedCategory = category),
                );
              },
            ),
          ),

          // 2. TIPS LIST
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: filteredTips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final tip = filteredTips[index];
                final isBookmarked = bookmarkedTips.contains(tip.title);
                return _buildModernTipCard(tip, isBookmarked);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildModernFilterChip(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kDarkGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kDarkGreen : kPillGrey,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : kTextGrey,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildModernTipCard(FarmingTipDetail tip, bool isBookmarked) {
    return GestureDetector(
      onTap: () => _showTipDetail(tip),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kPillGrey),
          boxShadow: [
            BoxShadow(
              color: kDarkGreen.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AppCachedImage(
                    imageUrl: tip.imageUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                // Category Tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tip.category,
                      style: GoogleFonts.inter(
                        color: kDarkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                // Bookmark Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isBookmarked) {
                          bookmarkedTips.remove(tip.title);
                        } else {
                          bookmarkedTips.add(tip.title);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.excerpt,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: kTextGrey,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Footer (Author & Stats)
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: kPillGrey,
                        radius: 12,
                        child: Text(tip.author[0],
                            style: TextStyle(fontSize: 10, color: kDarkGreen)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tip.author,
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: kTextGrey),
                      ),
                      const Spacer(),
                      _buildStatIcon(
                          Icons.thumb_up_alt_outlined, '${tip.likes}'),
                      const SizedBox(width: 12),
                      _buildStatIcon(
                          Icons.chat_bubble_outline, '${tip.comments}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatIcon(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: kTextGrey),
        const SizedBox(width: 4),
        Text(value, style: GoogleFonts.inter(fontSize: 12, color: kTextGrey)),
      ],
    );
  }

  void _showTipDetail(FarmingTipDetail tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: kPillGrey,
                          borderRadius: BorderRadius.circular(2)))),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Header Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AppCachedImage(
                        imageUrl: tip.imageUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title & Meta
                    Text(
                      tip.title,
                      style: GoogleFonts.inter(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kDarkGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tip.category,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: kDarkGreen),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(tip.publishDate),
                          style: GoogleFonts.inter(
                              color: kTextGrey, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: kPillGrey),
                    const SizedBox(height: 24),

                    // Content
                    ..._buildContent(tip.content),

                    const SizedBox(height: 32),

                    // Interaction Bar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildDetailAction(Icons.thumb_up_outlined, 'Like'),
                          _buildDetailAction(
                              Icons.chat_bubble_outline, 'Comment'),
                          _buildDetailAction(Icons.share_outlined, 'Share'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailAction(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: kDarkGreen, size: 20),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600, color: kDarkGreen)),
      ],
    );
  }

  // Helper to parse markdown-like content into widgets
  List<Widget> _buildContent(String content) {
    final sections = content.split('\n\n');
    final List<Widget> widgets = [];

    for (var section in sections) {
      if (section.trim().isEmpty) continue;

      if (section.startsWith('**') && section.contains('**\n')) {
        // Section Title
        final title = section.split('**\n')[0].replaceAll('**', '');
        final rest = section.split('**\n')[1];

        widgets.add(Text(
          title,
          style: GoogleFonts.inter(
              fontSize: 18, fontWeight: FontWeight.bold, color: kDarkGreen),
        ));
        widgets.add(const SizedBox(height: 8));

        // List Items
        if (rest.contains('•')) {
          final lines = rest.split('\n');
          for (var line in lines) {
            if (line.trim().startsWith('•')) {
              widgets.add(Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: kAccentOrange, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        line.replaceFirst('•', '').trim(),
                        style: GoogleFonts.inter(
                            fontSize: 15, height: 1.6, color: kTextGrey),
                      ),
                    ),
                  ],
                ),
              ));
            }
          }
        } else {
          widgets.add(Text(rest,
              style: GoogleFonts.inter(
                  fontSize: 15, height: 1.6, color: kTextGrey)));
        }
        widgets.add(const SizedBox(height: 24));
      } else {
        // Regular Paragraph
        widgets.add(Text(section,
            style: GoogleFonts.inter(
                fontSize: 15, height: 1.6, color: kTextGrey)));
        widgets.add(const SizedBox(height: 24));
      }
    }
    return widgets;
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showBookmarkedTips() {
    // Implement bookmark list view logic here
  }
}

class FarmingTipDetail {
  final String title;
  final String category;
  final String imageUrl;
  final String excerpt;
  final String content;
  final String author;
  final DateTime publishDate;
  final int likes;
  final int comments;

  FarmingTipDetail({
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.excerpt,
    required this.content,
    required this.author,
    required this.publishDate,
    required this.likes,
    required this.comments,
  });
}
