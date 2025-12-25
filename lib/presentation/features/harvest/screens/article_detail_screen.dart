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

class ArticleDetailScreen extends ConsumerStatefulWidget {
  final String title;
  final String imageUrl;
  final String category;
  final int readTime;
  final String author;
  final DateTime publishDate;

  const ArticleDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.readTime,
    required this.author,
    required this.publishDate,
  });

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  bool isBookmarked = false;
  bool isFollowingAuthor = false;

  // Mock Content (Kept from your snippet)
  final String articleContent = '''
# Introduction

Sustainable farming practices are becoming increasingly important in our modern agricultural landscape. Small-scale farmers play a crucial role in food production while maintaining environmental balance.

## Why Sustainable Farming Matters

Climate change and environmental degradation pose significant challenges to traditional farming methods. Sustainable practices offer solutions that benefit both farmers and the planet.

### Key Benefits:
• Improved soil health and fertility
• Reduced water consumption
• Lower carbon footprint
• Better crop yields over time
• Enhanced biodiversity

## Essential Practices

### 1. Crop Rotation
Rotating crops prevents soil depletion and reduces pest problems naturally. Different plants have different nutrient requirements and pest vulnerabilities.

**Implementation Tips:**
- Plan a 3-4 year rotation schedule
- Include legumes to fix nitrogen
- Alternate deep and shallow-rooted crops
- Keep detailed records of what was planted where

### 2. Composting
Transform organic waste into nutrient-rich soil amendments. This reduces waste and eliminates the need for chemical fertilizers.

**Getting Started:**
- Set up a composting area
- Balance green and brown materials
- Maintain proper moisture levels
- Turn compost regularly for faster breakdown

## Conclusion

Sustainable farming practices offer a path forward that balances productivity with environmental stewardship. Small-scale farmers are uniquely positioned to lead this agricultural revolution.
''';

  final List<ArticleComment> comments = [
    ArticleComment(
      userName: 'David Martinez',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      comment:
          'Great article! I\'ve been implementing crop rotation for 2 years now.',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 12,
    ),
    // ... add more comments
  ];

  final List<RelatedArticle> relatedArticles = [
    RelatedArticle(
      title: 'Organic Pest Control Methods',
      imageUrl:
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400',
      readTime: 6,
      category: 'Pest Management',
    ),
    // ... add more related articles
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. HERO IMAGE HEADER
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: kBgColor,
            leading: _buildGlassButton(
                Icons.arrow_back, () => Navigator.pop(context)),
            actions: [
              _buildGlassButton(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                () {
                  setState(() => isBookmarked = !isBookmarked);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isBookmarked ? 'Saved' : 'Removed')),
                  );
                },
              ),
              const SizedBox(width: 8),
              _buildGlassButton(Icons.share_outlined, () {}),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedImage(
                      imageUrl: widget.imageUrl,
                      width: double.infinity,
                      height: double.infinity),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black26,
                          Colors.transparent,
                          Colors.black54
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. ARTICLE BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kAccentOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.category.toUpperCase(),
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: kAccentOrange,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_formatDate(widget.publishDate)} • ${widget.readTime} min read',
                        style:
                            GoogleFonts.dmSans(color: kTextGrey, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Author Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=${widget.author.hashCode % 70}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.author,
                                style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold,
                                    color: kDarkGreen)),
                            Text('Author',
                                style: GoogleFonts.dmSans(
                                    fontSize: 12, color: kTextGrey)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () => setState(
                              () => isFollowingAuthor = !isFollowingAuthor),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                isFollowingAuthor ? kTextGrey : kDarkGreen,
                            side: BorderSide(
                                color:
                                    isFollowingAuthor ? kPillGrey : kDarkGreen),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child:
                              Text(isFollowingAuthor ? 'Following' : 'Follow'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: kPillGrey),
                  const SizedBox(height: 24),

                  // Content
                  ..._buildArticleContent(),

                  const SizedBox(height: 32),

                  // Action Bar
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: kPillGrey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionItem(
                            Icons.thumb_up_alt_outlined, '24 Likes'),
                        _buildActionItem(Icons.chat_bubble_outline,
                            '${comments.length} Comments'),
                        _buildActionItem(Icons.share_outlined, '12 Shares'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Related Articles Header
                  Text('Related Articles',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 3. RELATED ARTICLES LIST
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildRelatedArticleCard(relatedArticles[index]),
                childCount: relatedArticles.length,
              ),
            ),
          ),

          // 4. COMMENTS SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Comments (${comments.length})',
                      style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen)),
                  TextButton(
                    onPressed: _showAddCommentDialog,
                    child: Text('Add Comment',
                        style: GoogleFonts.dmSans(
                            color: kAccentOrange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildCommentCard(comments[index]),
                childCount: comments.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildGlassButton(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Frosted glass look
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kDarkGreen),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: kDarkGreen, fontSize: 13)),
      ],
    );
  }

  Widget _buildRelatedArticleCard(RelatedArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kPillGrey),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppCachedImage(
                imageUrl: article.imageUrl, width: 80, height: 80),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(article.title,
                    style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.bold, color: kDarkGreen),
                    maxLines: 2),
                const SizedBox(height: 4),
                Text('${article.readTime} min read',
                    style: GoogleFonts.dmSans(color: kTextGrey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(ArticleComment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              backgroundImage: NetworkImage(comment.userAvatar), radius: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.userName,
                        style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.bold, color: kDarkGreen)),
                    const SizedBox(width: 8),
                    Text(_formatDate(comment.date),
                        style:
                            GoogleFonts.dmSans(fontSize: 11, color: kTextGrey)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.comment,
                    style: GoogleFonts.dmSans(color: kDarkGreen, height: 1.4)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: 14, color: kTextGrey),
                    const SizedBox(width: 4),
                    Text('${comment.likes}',
                        style:
                            GoogleFonts.dmSans(fontSize: 12, color: kTextGrey)),
                    const SizedBox(width: 16),
                    Text('Reply',
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kTextGrey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildArticleContent() {
    // Basic Markdown Parser (Same logic as before, just updated fonts)
    final sections = articleContent.split('\n\n');
    return sections.map((section) {
      if (section.startsWith('# ')) {
        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(section.substring(2),
                style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen)));
      } else if (section.startsWith('## ')) {
        return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Text(section.substring(3),
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen)));
      } else {
        return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(section,
                style: GoogleFonts.dmSans(
                    fontSize: 16, height: 1.6, color: Colors.black87)));
      }
    }).toList();
  }

  String _formatDate(DateTime date) => "${date.day}/${date.month}/${date.year}";
  void _showAddCommentDialog() {} // Keep logic
}

// ... Keep ArticleComment and RelatedArticle classes ...
class ArticleComment {
  final String userName;
  final String userAvatar;
  final String comment;
  final DateTime date;
  final int likes;
  ArticleComment(
      {required this.userName,
      required this.userAvatar,
      required this.comment,
      required this.date,
      required this.likes});
}

class RelatedArticle {
  final String title;
  final String imageUrl;
  final int readTime;
  final String category;
  RelatedArticle(
      {required this.title,
      required this.imageUrl,
      required this.readTime,
      required this.category});
}
