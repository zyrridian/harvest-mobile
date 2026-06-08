import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:harvest_app/presentation/features/harvest/screens/recipe_detail_screen.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class RecipesListScreen extends ConsumerStatefulWidget {
  const RecipesListScreen({super.key});

  @override
  ConsumerState<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends ConsumerState<RecipesListScreen> {
  String selectedCategory = 'All';
  String selectedDifficulty = 'All';

  final List<String> categories = [
    'All',
    'Salad',
    'Main Course',
    'Soup',
    'Dessert',
    'Breakfast'
  ];
  final List<String> difficulties = ['All', 'Easy', 'Medium', 'Hard'];

  final List<RecipeItem> recipes = [
    // ... (Keep your existing mock data)
    RecipeItem(
      name: 'Fresh Strawberry Salad',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      difficulty: 'Easy',
      time: '15 min',
      rating: 4.8,
      servings: 4,
      ingredients: ['2 cups fresh strawberries'], // abbreviated
      instructions: ['Wash strawberries'], // abbreviated
      category: 'Salad',
      cuisine: 'American',
      calories: 280,
    ),
    // ... add rest of recipes ...
  ];

  List<RecipeItem> get filteredRecipes {
    return recipes.where((recipe) {
      final categoryMatch =
          selectedCategory == 'All' || recipe.category == selectedCategory;
      final difficultyMatch = selectedDifficulty == 'All' ||
          recipe.difficulty == selectedDifficulty;
      return categoryMatch && difficultyMatch;
    }).toList();
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
          'Fresh Recipes',
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
          // Category Filter
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
                return _buildPebbleChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => setState(() => selectedCategory = category),
                );
              },
            ),
          ),

          // Difficulty Filter (Secondary Row)
          Container(
            height: 50,
            padding: const EdgeInsets.only(bottom: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Center(
                  child: Text(
                    'Difficulty:',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ...difficulties.map((difficulty) {
                  final isSelected = selectedDifficulty == difficulty;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => selectedDifficulty = difficulty),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? kDarkGreen.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? kDarkGreen : kPillGrey,
                          ),
                        ),
                        child: Text(
                          difficulty,
                          style: GoogleFonts.dmSans(
                            color: isSelected ? kDarkGreen : kTextGrey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Recipes Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70, // Optimized for vertical cards
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                return _buildRecipeCard(filteredRecipes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPebbleChip(
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
          border: Border.all(color: isSelected ? kDarkGreen : kPillGrey),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            color: isSelected ? Colors.white : kTextGrey,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(RecipeItem recipe) {
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
              servings: recipe.servings,
              ingredients: recipe.ingredients,
              instructions: recipe.instructions,
              category: recipe.category,
              rating: recipe.rating,
              cuisine: recipe.cuisine,
              calories: recipe.calories,
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: kPillGrey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toString(),
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
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
                      fontSize: 14,
                      color: kDarkGreen,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Meta Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 12, color: kTextGrey),
                          const SizedBox(width: 4),
                          Text(
                            recipe.time,
                            style: GoogleFonts.dmSans(
                                fontSize: 11, color: kTextGrey),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(recipe.difficulty)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          recipe.difficulty,
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getDifficultyColor(recipe.difficulty),
                          ),
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return kDarkGreen;
    }
  }
}

class RecipeItem {
  // ... (Keep existing model class)
  final String name;
  final String imageUrl;
  final String difficulty;
  final String time;
  final double rating;
  final int servings;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  final String cuisine;
  final int calories;

  RecipeItem({
    required this.name,
    required this.imageUrl,
    required this.difficulty,
    required this.time,
    required this.rating,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.cuisine,
    required this.calories,
  });
}
