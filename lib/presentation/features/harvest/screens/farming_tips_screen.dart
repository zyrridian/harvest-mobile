import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../shared_widgets/app_cached_image.dart';

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
    FarmingTipDetail(
      title: 'Complete Guide to Composting',
      category: 'Composting',
      imageUrl:
          'https://images.unsplash.com/photo-1597308680537-3541ac6b7a8e?w=400',
      excerpt:
          'Turn kitchen and garden waste into nutrient-rich compost for your garden.',
      content: '''
Composting is nature's way of recycling. Create your own black gold:

**What to Compost (Greens - Nitrogen)**
• Fruit and vegetable scraps
• Coffee grounds and filters
• Tea bags
• Fresh grass clippings
• Plant trimmings

**What to Compost (Browns - Carbon)**
• Dry leaves
• Straw and hay
• Wood chips
• Shredded newspaper
• Cardboard (torn into pieces)

**What NOT to Compost**
• Meat, fish, bones
• Dairy products
• Diseased plants
• Pet waste
• Weeds with seeds

**The Perfect Recipe**
• 3 parts brown materials to 1 part green materials
• Chop materials into smaller pieces for faster decomposition
• Keep pile as moist as a wrung-out sponge
• Turn pile every 1-2 weeks

**Troubleshooting**
• Smells bad? Too wet or too many greens - add browns
• Not heating up? Too dry or needs more greens
• Attracting pests? Bury food scraps deeper
''',
      author: 'Michael Chen',
      publishDate: DateTime.now().subtract(const Duration(days: 5)),
      likes: 189,
      comments: 31,
    ),
    FarmingTipDetail(
      title: 'Food Preservation Methods',
      category: 'Preservation',
      imageUrl:
          'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=400',
      excerpt: 'Preserve your harvest using these time-tested methods.',
      content: '''
Extend your harvest season with proper preservation:

**Canning**
• Best for: tomatoes, pickles, jams, fruits
• Equipment needed: pressure canner or water bath canner
• Always follow tested recipes for safety
• Store in cool, dark place

**Freezing**
• Best for: berries, vegetables, herbs
• Blanch vegetables before freezing
• Use airtight containers or freezer bags
• Label with contents and date

**Drying/Dehydrating**
• Best for: herbs, tomatoes, peppers, fruits
• Use food dehydrator or oven
• Store in airtight containers
• Keep in cool, dry place

**Fermentation**
• Best for: cabbage (sauerkraut), cucumbers (pickles), peppers
• Probiotic benefits
• Adds unique flavors
• Requires salt brine or starter culture

**Root Cellaring**
• Best for: potatoes, carrots, beets, apples
• Store at 32-40°F with high humidity
• Keep in dark location
• Check regularly for spoilage
''',
      author: 'Emma Rodriguez',
      publishDate: DateTime.now().subtract(const Duration(days: 7)),
      likes: 156,
      comments: 28,
    ),
    FarmingTipDetail(
      title: 'Natural Pest Control Solutions',
      category: 'Pest Control',
      imageUrl:
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400',
      excerpt:
          'Protect your crops without harmful chemicals using these organic methods.',
      content: '''
Control pests naturally for a healthier garden:

**Preventive Measures**
• Rotate crops annually
• Keep garden clean and weed-free
• Use row covers for young plants
• Plant disease-resistant varieties
• Practice proper spacing for air circulation

**Beneficial Insects**
• Ladybugs: eat aphids, mites
• Lacewings: consume many soft-bodied pests
• Parasitic wasps: control caterpillars
• Ground beetles: eat slugs and cutworms
• How to attract: plant flowers, provide water, avoid pesticides

**Organic Sprays**
• Neem oil: broad-spectrum control
• Insecticidal soap: soft-bodied insects
• Diatomaceous earth: crawling insects
• Garlic spray: repels many pests
• Bt (Bacillus thuringiensis): caterpillars

**Companion Planting**
• Marigolds: deter nematodes and aphids
• Basil: repels flies and mosquitoes
• Nasturtiums: trap crop for aphids
• Garlic: deters many insects
• Mint: repels ants and aphids (plant in containers)

**Physical Barriers**
• Hand-pick large pests
• Use copper tape for slugs
• Install bird netting
• Apply sticky traps
• Create beer traps for slugs
''',
      author: 'Ahmad Wijaya',
      publishDate: DateTime.now().subtract(const Duration(days: 10)),
      likes: 312,
      comments: 67,
    ),
    FarmingTipDetail(
      title: 'Efficient Irrigation Systems',
      category: 'Irrigation',
      imageUrl:
          'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400',
      excerpt: 'Save water and time with smart irrigation techniques.',
      content: '''
Water efficiently for healthier plants and lower bills:

**Drip Irrigation**
• Delivers water directly to roots
• 90% water efficiency
• Reduces weed growth
• Perfect for vegetable gardens
• Installation: lay tubing, add emitters at each plant

**Soaker Hoses**
• Affordable option
• Easy to install
• Great for raised beds
• Can be covered with mulch
• Water slowly and deeply

**Sprinkler Systems**
• Good for lawns and large areas
• Time with programmable controller
• Water early morning (4-6 AM)
• Adjust heads to avoid runoff
• Use rain sensors to prevent waste

**Smart Controllers**
• Weather-based watering
• Remote control via smartphone
• Automatically adjust schedules
• Track water usage
• Save 20-50% on water bills

**Water Conservation Tips**
• Mulch to retain moisture
• Group plants by water needs
• Collect rainwater
• Use gray water when possible
• Water deeply but less frequently
''',
      author: 'David Martinez',
      publishDate: DateTime.now().subtract(const Duration(days: 12)),
      likes: 203,
      comments: 45,
    ),
    FarmingTipDetail(
      title: 'Building Healthy Soil',
      category: 'Soil Health',
      imageUrl:
          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=400',
      excerpt:
          'The foundation of a productive garden starts with healthy soil.',
      content: '''
Improve your soil for better harvests:

**Test Your Soil**
• Get a soil test every 2-3 years
• Check pH, nutrients, organic matter
• Send samples to local extension office
• Test in fall for spring amendments

**Add Organic Matter**
• Compost: best all-around amendment
• Aged manure: high in nutrients
• Leaf mold: improves structure
• Green manures: cover crops
• Target 5-10% organic matter content

**Correct pH Issues**
• Too acidic (low pH): add lime
• Too alkaline (high pH): add sulfur
• Most vegetables prefer 6.0-7.0
• Adjust gradually over time

**Cover Crops**
• Plant in off-season
• Prevent erosion
• Add nitrogen (legumes)
• Improve soil structure
• Suppress weeds

**No-Till Gardening**
• Preserves soil structure
• Protects beneficial organisms
• Reduces water loss
• Less work for you
• Add compost on top annually

**Mulching Benefits**
• Retains moisture
• Moderates soil temperature
• Prevents erosion
• Suppresses weeds
• Adds organic matter as it decomposes
''',
      author: 'Lisa Wong',
      publishDate: DateTime.now().subtract(const Duration(days: 15)),
      likes: 278,
      comments: 54,
    ),
  ];

  List<FarmingTipDetail> get filteredTips {
    if (selectedCategory == 'All') return tips;
    return tips.where((tip) => tip.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farming Tips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              _showBookmarkedTips();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                  ),
                );
              },
            ),
          ),

          // Tips List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredTips.length,
              itemBuilder: (context, index) {
                final tip = filteredTips[index];
                final isBookmarked = bookmarkedTips.contains(tip.title);
                return _buildTipCard(tip, isBookmarked);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(FarmingTipDetail tip, bool isBookmarked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showTipDetail(tip);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  AppCachedImage(
                    imageUrl: tip.imageUrl,
                    width: double.infinity,
                    height: 180,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          if (isBookmarked) {
                            bookmarkedTips.remove(tip.title);
                          } else {
                            bookmarkedTips.add(tip.title);
                          }
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tip.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tip.excerpt,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        tip.author,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(tip.publishDate),
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.thumb_up_outlined,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${tip.likes}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.comment_outlined,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${tip.comments}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCachedImage(
                  imageUrl: tip.imageUrl,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tip.category,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tip.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    tip.author,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${_formatDate(tip.publishDate)}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._buildContent(tip.content),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                      Icons.thumb_up_outlined, '${tip.likes}', 'Like'),
                  _buildActionButton(
                      Icons.comment_outlined, '${tip.comments}', 'Comment'),
                  _buildActionButton(Icons.share_outlined, 'Share', ''),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Ask a question or share your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comment posted!')),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContent(String content) {
    final sections = content.split('\n\n');
    final List<Widget> widgets = [];

    for (var section in sections) {
      if (section.trim().isEmpty) continue;

      if (section.startsWith('**') && section.contains('**\n')) {
        final title = section.split('**\n')[0].replaceAll('**', '');
        final rest = section.split('**\n')[1];
        widgets.add(Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ));
        widgets.add(const SizedBox(height: 8));

        if (rest.contains('•')) {
          final lines = rest.split('\n');
          for (var line in lines) {
            if (line.trim().startsWith('•')) {
              widgets.add(Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(color: AppColors.primary)),
                    Expanded(
                      child: Text(
                        line.replaceFirst('•', '').trim(),
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ));
            }
          }
        } else {
          widgets.add(
              Text(rest, style: const TextStyle(fontSize: 14, height: 1.6)));
        }
        widgets.add(const SizedBox(height: 12));
      } else {
        widgets.add(
            Text(section, style: const TextStyle(fontSize: 14, height: 1.6)));
        widgets.add(const SizedBox(height: 12));
      }
    }

    return widgets;
  }

  Widget _buildActionButton(IconData icon, String label, String sublabel) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label feature coming soon')),
        );
      },
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          if (sublabel.isNotEmpty)
            Text(
              sublabel,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${difference.inDays ~/ 7} weeks ago';
    }
  }

  void _showBookmarkedTips() {
    if (bookmarkedTips.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No bookmarked tips yet')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bookmarked Tips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: bookmarkedTips.map((title) {
                  return ListTile(
                    leading:
                        const Icon(Icons.bookmark, color: AppColors.primary),
                    title: Text(title),
                    onTap: () {
                      final tip = tips.firstWhere((t) => t.title == title);
                      Navigator.pop(context);
                      _showTipDetail(tip);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
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
