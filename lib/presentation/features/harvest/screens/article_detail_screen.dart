import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../shared_widgets/app_cached_image.dart';

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

### 3. Water Conservation
Efficient water use is crucial for sustainable farming. Drip irrigation and rainwater harvesting can significantly reduce water waste.

**Water-Saving Techniques:**
- Install drip irrigation systems
- Mulch to retain soil moisture
- Collect rainwater in barrels
- Plant drought-resistant varieties

### 4. Integrated Pest Management (IPM)
Control pests using biological and cultural methods before resorting to chemicals.

**IPM Strategies:**
- Encourage beneficial insects
- Use companion planting
- Practice crop rotation
- Apply organic pesticides only when necessary

## Economic Benefits

Sustainable farming isn't just good for the environment—it's good for business. Reduced input costs, premium pricing for organic produce, and long-term soil health all contribute to better profitability.

### Cost Savings:
• Lower fertilizer expenses
• Reduced pesticide costs
• Decreased water bills
• Long-term soil improvement

### Revenue Opportunities:
• Organic certification premiums
• Direct-to-consumer sales
• Farmer's market presence
• Community Supported Agriculture (CSA)

## Getting Started

Begin with small changes and gradually expand your sustainable practices. Focus on one area at a time, master it, then move to the next.

### First Steps:
1. Assess your current practices
2. Start composting
3. Implement basic crop rotation
4. Reduce chemical inputs gradually
5. Connect with other sustainable farmers

## Conclusion

Sustainable farming practices offer a path forward that balances productivity with environmental stewardship. Small-scale farmers are uniquely positioned to lead this agricultural revolution.

The journey to sustainability is ongoing, but every step counts. Start today, and watch your farm thrive while protecting our planet for future generations.
''';

  final List<ArticleComment> comments = [
    ArticleComment(
      userName: 'David Martinez',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      comment:
          'Great article! I\'ve been implementing crop rotation for 2 years now and the soil quality has improved dramatically.',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 12,
    ),
    ArticleComment(
      userName: 'Lisa Wong',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      comment:
          'Would love to see more specific examples for tropical climates. Any plans for a follow-up article?',
      date: DateTime.now().subtract(const Duration(days: 1)),
      likes: 8,
    ),
    ArticleComment(
      userName: 'James Anderson',
      userAvatar: 'https://i.pravatar.cc/150?img=6',
      comment:
          'The composting section was particularly helpful. Started my first compost pile last week!',
      date: DateTime.now().subtract(const Duration(days: 2)),
      likes: 15,
    ),
  ];

  final List<RelatedArticle> relatedArticles = [
    RelatedArticle(
      title: 'Organic Pest Control Methods',
      imageUrl:
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400',
      readTime: 6,
      category: 'Pest Management',
    ),
    RelatedArticle(
      title: 'Water Conservation Techniques',
      imageUrl:
          'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400',
      readTime: 7,
      category: 'Irrigation',
    ),
    RelatedArticle(
      title: 'Soil Health Fundamentals',
      imageUrl:
          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=400',
      readTime: 9,
      category: 'Soil Health',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image App Bar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedImage(
                    imageUrl: widget.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon:
                    Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isBookmarked
                          ? 'Article bookmarked!'
                          : 'Bookmark removed'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share feature coming soon')),
                  );
                },
              ),
            ],
          ),

          // Article Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.category,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Author Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=${widget.author.hashCode % 70}',
                        ),
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.author,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${_formatDate(widget.publishDate)} · ${widget.readTime} min read',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isFollowingAuthor = !isFollowingAuthor;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFollowingAuthor
                              ? Colors.grey[300]
                              : AppColors.primary,
                          foregroundColor:
                              isFollowingAuthor ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(isFollowingAuthor ? 'Following' : 'Follow'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                ],
              ),
            ),
          ),

          // Article Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildArticleContent(),
              ),
            ),
          ),

          // Article Actions
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(Icons.thumb_up_outlined, '24', 'Likes'),
                  _buildActionButton(
                      Icons.comment_outlined, '${comments.length}', 'Comments'),
                  _buildActionButton(Icons.share_outlined, '12', 'Shares'),
                ],
              ),
            ),
          ),

          // Related Articles
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  const Icon(Icons.auto_stories, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Related Articles',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildRelatedArticleCard(relatedArticles[index]);
                },
                childCount: relatedArticles.length,
              ),
            ),
          ),

          // Comments Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.comment, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Comments (${comments.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _showAddCommentDialog();
                    },
                    child: const Text('Add Comment'),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildCommentCard(comments[index]);
                },
                childCount: comments.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildArticleContent() {
    final sections = articleContent.split('\n\n');
    final List<Widget> widgets = [];

    for (var section in sections) {
      if (section.trim().isEmpty) continue;

      if (section.startsWith('# ')) {
        widgets.add(Text(
          section.substring(2),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ));
        widgets.add(const SizedBox(height: 16));
      } else if (section.startsWith('## ')) {
        widgets.add(const SizedBox(height: 8));
        widgets.add(Text(
          section.substring(3),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ));
        widgets.add(const SizedBox(height: 12));
      } else if (section.startsWith('### ')) {
        widgets.add(const SizedBox(height: 8));
        widgets.add(Text(
          section.substring(4),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            height: 1.4,
          ),
        ));
        widgets.add(const SizedBox(height: 8));
      } else if (section.startsWith('•') || section.startsWith('-')) {
        final lines = section.split('\n');
        for (var line in lines) {
          if (line.trim().isNotEmpty) {
            widgets.add(Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(color: AppColors.primary, fontSize: 18)),
                  Expanded(
                    child: Text(
                      line.replaceFirst(RegExp(r'^[•\-]\s*'), ''),
                      style: const TextStyle(fontSize: 15, height: 1.6),
                    ),
                  ),
                ],
              ),
            ));
          }
        }
        widgets.add(const SizedBox(height: 12));
      } else if (section.startsWith('**') && section.endsWith('**')) {
        widgets.add(Text(
          section.replaceAll('**', ''),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            height: 1.6,
          ),
        ));
        widgets.add(const SizedBox(height: 8));
      } else {
        widgets.add(Text(
          section,
          style:
              const TextStyle(fontSize: 15, height: 1.7, color: Colors.black87),
        ));
        widgets.add(const SizedBox(height: 16));
      }
    }

    return widgets;
  }

  Widget _buildActionButton(IconData icon, String count, String label) {
    return InkWell(
      onTap: () {
        if (label == 'Comments') {
          _showAddCommentDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label feature coming soon')),
          );
        }
      },
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticleCard(RelatedArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Related article coming soon')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
              child: AppCachedImage(
                imageUrl: article.imageUrl,
                width: 80,
                height: 80,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${article.readTime} min',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          article.category,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildCommentCard(ArticleComment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.userAvatar),
                radius: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      _formatDate(comment.date),
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.comment, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${comment.likes}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {},
                child: Text(
                  'Reply',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 24) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${difference.inDays ~/ 7} weeks ago';
    }
  }

  void _showAddCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Share your thoughts...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comment added!')),
              );
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

class ArticleComment {
  final String userName;
  final String userAvatar;
  final String comment;
  final DateTime date;
  final int likes;

  ArticleComment({
    required this.userName,
    required this.userAvatar,
    required this.comment,
    required this.date,
    required this.likes,
  });
}

class RelatedArticle {
  final String title;
  final String imageUrl;
  final int readTime;
  final String category;

  RelatedArticle({
    required this.title,
    required this.imageUrl,
    required this.readTime,
    required this.category,
  });
}
