import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:harvest_app/presentation/features/harvest/screens/courses_screen.dart';
import 'package:harvest_app/presentation/features/harvest/screens/farming_tips_screen.dart';
import 'package:harvest_app/presentation/features/harvest/screens/seasonal_calendar_screen.dart';
import 'package:harvest_app/presentation/features/harvest/screens/recipes_list_screen.dart';
import 'package:harvest_app/presentation/features/harvest/screens/articles_list_screen.dart';
import 'package:harvest_app/presentation/features/harvest/screens/recipe_detail_screen.dart';
import 'package:harvest_app/presentation/features/harvest/screens/article_detail_screen.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);
const kCream = Color(0xFFFFF9E6);

// --- MOCK DATA MODELS (Kept for functionality) ---
class Season {
  final String name;
  final String icon;
  final List<String> months;
  Season({required this.name, required this.icon, required this.months});
}

class SeasonalProduce {
  final String name;
  final String category;
  final String imageUrl;
  final String harvestTime;
  SeasonalProduce(
      {required this.name,
      required this.category,
      required this.imageUrl,
      required this.harvestTime});
}

class Recipe {
  final String name;
  final String imageUrl;
  final String difficulty;
  final String time;
  final double rating;
  Recipe(
      {required this.name,
      required this.imageUrl,
      required this.difficulty,
      required this.time,
      required this.rating});
}

class Article {
  final String title;
  final String category;
  final String imageUrl;
  final String readTime;
  Article(
      {required this.title,
      required this.category,
      required this.imageUrl,
      required this.readTime});
}

class HarvestScreen extends ConsumerStatefulWidget {
  const HarvestScreen({super.key});

  @override
  ConsumerState<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends ConsumerState<HarvestScreen> {
  String selectedSeason = 'Year-Round';

  // --- MOCK DATA ---
  final List<Season> seasons = [
    Season(name: 'Year-Round', icon: '🌏', months: ['All']),
    Season(name: 'Spring', icon: '🌸', months: ['Mar', 'Apr', 'May']),
    Season(name: 'Summer', icon: '☀️', months: ['Jun', 'Jul', 'Aug']),
    Season(name: 'Fall', icon: '🍂', months: ['Sep', 'Oct', 'Nov']),
    Season(name: 'Winter', icon: '❄️', months: ['Dec', 'Jan', 'Feb']),
  ];

  final List<SeasonalProduce> produceList = [
    SeasonalProduce(
        name: 'Papaya',
        category: 'Fruit',
        imageUrl:
            'https://images.unsplash.com/photo-1617112848923-cc2234396a8d?w=400',
        harvestTime: 'All Year'),
    SeasonalProduce(
        name: 'Water Spinach',
        category: 'Veg',
        imageUrl:
            'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
        harvestTime: '30 Days'),
    SeasonalProduce(
        name: 'Red Chilies',
        category: 'Veg',
        imageUrl:
            'https://images.unsplash.com/photo-1583058492096-393bd78a6e46?w=400',
        harvestTime: '60 Days'),
    // SeasonalProduce(
    //     name: 'Mango',
    //     category: 'Fruit',
    //     imageUrl:
    //         'https://images.unsplash.com/photo-1605616385733-64db1b0b1dea?w=400',
    //     harvestTime: 'Seasonal'),
  ];

  final List<Recipe> recipes = [
    Recipe(
        name: 'Fresh Strawberry Salad',
        imageUrl:
            'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        difficulty: 'Easy',
        time: '15 min',
        rating: 4.8),
    Recipe(
        name: 'Roasted Tomato Pasta',
        imageUrl:
            'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400',
        difficulty: 'Medium',
        time: '35 min',
        rating: 4.9),
    Recipe(
        name: 'Pumpkin Soup',
        imageUrl:
            'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400',
        difficulty: 'Easy',
        time: '40 min',
        rating: 4.7),
  ];

  final List<Article> articles = [
    Article(
        title: 'Sustainable Farming 101',
        category: 'Guide',
        imageUrl:
            'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400',
        readTime: '5 min'),
    Article(
        title: 'Urban Gardening Tips',
        category: 'Tips',
        imageUrl:
            'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=400',
        readTime: '3 min'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: CustomScrollView(
        slivers: [
          // 1. APP BAR (Clean White)
          SliverAppBar(
            backgroundColor: kBgColor,
            elevation: 0,
            pinned: true,
            centerTitle: false,
            expandedHeight: 100,
            collapsedHeight: 70,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              title: Text(
                'Learn & Grow',
                style: GoogleFonts.playfairDisplay(
                  color: kDarkGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
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
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // 2. SEASON SELECTOR (Pill Style)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: seasons.length,
                itemBuilder: (context, index) {
                  final season = seasons[index];
                  final isSelected = selectedSeason == season.name;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedSeason = season.name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? kDarkGreen : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? kDarkGreen : kPillGrey,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(season.icon,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              season.name,
                              style: GoogleFonts.dmSans(
                                color: isSelected ? Colors.white : kTextGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 3. EXPLORE GRID (FIXED STYLE)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Explore',
                      style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          'Seasonal\nCalendar',
                          Icons.calendar_month_outlined,
                          const Color(0xFF1E40AF), // Blue Accent
                          () => _navTo(context, const SeasonalCalendarScreen()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFeatureCard(
                          'Farming\nTips',
                          Icons.lightbulb_outline,
                          const Color(0xFFB45309), // Orange Accent
                          () => _navTo(context, const FarmingTipsScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          'Workshops\n& Courses',
                          Icons.school_outlined,
                          const Color(0xFF7E22CE), // Purple Accent
                          () => _navTo(context, const CoursesScreen()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildFeatureCard(
                          'Community\nRecipes',
                          Icons.restaurant_menu_outlined,
                          const Color(0xFF15803D), // Green Accent
                          () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 4. IN SEASON NOW (Horizontal List)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSectionHeader('In Season Now', 'View all'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: produceList.length,
                    itemBuilder: (context, index) {
                      return _buildProduceCard(produceList[index]);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 5. FRESH RECIPES (Horizontal List)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSectionHeader(
                    'Fresh Recipes',
                    'View all',
                    onTap: () => _navTo(context, const RecipesListScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      return _buildRecipeCard(recipes[index]);
                    },
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // 6. LATEST ARTICLES (Vertical List)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSectionHeader(
                        'Latest Articles',
                        'View all',
                        onTap: () =>
                            _navTo(context, const ArticlesListScreen()),
                      ),
                    );
                  }
                  return _buildArticleCard(articles[index - 1]);
                },
                childCount: articles.length + 1,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionHeader(String title, String? action,
      {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              action,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kTextGrey,
              ),
            ),
          ),
      ],
    );
  }

  // --- FIXED WIDGET: CLEAN PEBBLE STYLE ---
  Widget _buildFeatureCard(
      String title, IconData icon, Color accentColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Pure white background
          borderRadius: BorderRadius.circular(20), // "Pebble" roundness
          border: Border.all(color: kPillGrey), // Subtle grey border
          boxShadow: [
            BoxShadow(
              color: kDarkGreen.withOpacity(0.05), // Very soft shadow
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon Pill
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor
                    .withOpacity(0.1), // Light pastel version of accent
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            // Text
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: kDarkGreen,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduceCard(SeasonalProduce produce) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPillGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: produce.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: kPillGrey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produce.name,
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kDarkGreen),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: kAccentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    produce.harvestTime,
                    style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: kAccentOrange),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                recipeName: recipe.name,
                recipeImageUrl: recipe.imageUrl,
                difficulty: recipe.difficulty,
                time: recipe.time,
                servings: 4,
                ingredients: [
                  '2 cups fresh ingredients',
                  '1 tbsp olive oil',
                  'Salt and pepper to taste',
                ],
                instructions: [
                  'Prepare all ingredients',
                  'Follow cooking steps',
                  'Serve and enjoy',
                ],
                category: 'Main Course',
                rating: recipe.rating,
                cuisine: 'International',
                calories: 350,
              ),
            ),
          );
        },
        child: Container(
          width: 200,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPillGrey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: recipe.imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: kPillGrey),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        recipe.difficulty,
                        style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: kDarkGreen),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: kTextGrey),
                        const SizedBox(width: 4),
                        Text(recipe.time,
                            style: GoogleFonts.dmSans(
                                fontSize: 12, color: kTextGrey)),
                        const Spacer(),
                        const Icon(Icons.star_rounded,
                            size: 16, color: Colors.amber),
                        Text(recipe.rating.toString(),
                            style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildArticleCard(Article article) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(
                title: article.title,
                imageUrl: article.imageUrl,
                category: article.category,
                readTime:
                    int.tryParse(article.readTime.replaceAll(' min', '')) ?? 5,
                author: 'Expert Farmer',
                publishDate: DateTime.now().subtract(const Duration(days: 3)),
              ),
            ),
          );
        },
        child: Container(
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
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: kPillGrey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        article.category.toUpperCase(),
                        style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: kTextGrey),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.title,
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kDarkGreen),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${article.readTime} read',
                      style: GoogleFonts.dmSans(fontSize: 12, color: kTextGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _navTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
