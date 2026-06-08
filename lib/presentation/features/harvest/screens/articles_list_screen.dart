import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:harvest_app/presentation/features/harvest/screens/article_detail_screen.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class ArticlesListScreen extends ConsumerStatefulWidget {
  const ArticlesListScreen({super.key});

  @override
  ConsumerState<ArticlesListScreen> createState() => _ArticlesListScreenState();
}

class _ArticlesListScreenState extends ConsumerState<ArticlesListScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Guide',
    'Tips',
    'Sustainability',
    'Organic',
    'Technology'
  ];

  final List<ArticleItem> articles = [
    // ... (Keep your existing mock data)
    ArticleItem(
      title: 'Sustainable Farming Practices for Small-Scale Farmers',
      imageUrl:
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800',
      category: 'Guide',
      readTime: 5,
      author: 'Dr. Emily Green',
      publishDate: DateTime.now().subtract(const Duration(days: 2)),
      excerpt:
          'Learn essential sustainable farming techniques that can help small-scale farmers improve yields while protecting the environment.',
    ),
    // ... add rest of articles here ...
  ];

  List<ArticleItem> get filteredArticles {
    if (selectedCategory == 'All') return articles;
    return articles
        .where((article) => article.category == selectedCategory)
        .toList();
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
          'Latest Articles',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kDarkGreen),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter (Modern Pill Style)
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
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? kDarkGreen : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isSelected ? kDarkGreen : kPillGrey),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: GoogleFonts.dmSans(
                        color: isSelected ? Colors.white : kTextGrey,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Articles List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: filteredArticles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildArticleCard(filteredArticles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(ArticleItem article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              title: article.title,
              imageUrl: article.imageUrl,
              category: article.category,
              readTime: article.readTime,
              author: article.author,
              publishDate: article.publishDate,
            ),
          ),
        );
      },
      child: Container(
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
            // Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: kPillGrey),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Tag
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kAccentOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article.category,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: kAccentOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    article.title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Excerpt
                  Text(
                    article.excerpt,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: kTextGrey,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Footer Meta
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: kTextGrey),
                      const SizedBox(width: 4),
                      Text(
                        '${article.readTime} min read',
                        style:
                            GoogleFonts.dmSans(fontSize: 12, color: kTextGrey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.person_outline,
                          size: 14, color: kTextGrey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          article.author,
                          style: GoogleFonts.dmSans(
                              fontSize: 12, color: kTextGrey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
}

class ArticleItem {
  // ... (Keep existing model class)
  final String title;
  final String imageUrl;
  final String category;
  final int readTime;
  final String author;
  final DateTime publishDate;
  final String excerpt;

  ArticleItem({
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.readTime,
    required this.author,
    required this.publishDate,
    required this.excerpt,
  });
}
