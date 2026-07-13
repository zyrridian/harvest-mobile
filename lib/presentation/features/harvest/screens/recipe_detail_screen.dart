import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared_widgets/app_cached_image.dart';

// Constants
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeName;
  final String recipeImageUrl;
  final String difficulty;
  final String time;
  final int servings;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  final double rating;
  final String cuisine;
  final int calories;

  const RecipeDetailScreen({
    super.key,
    required this.recipeName,
    required this.recipeImageUrl,
    required this.difficulty,
    required this.time,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.rating,
    required this.cuisine,
    required this.calories,
  });

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSaved = false;
  int selectedServings = 4;

  // Keep your mock reviews list here...
  final List<dynamic> reviews = []; // Placeholder

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    selectedServings = widget.servings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. HERO APP BAR
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: kBgColor,
            leading: _buildGlassButton(
                Icons.arrow_back, () => Navigator.pop(context)),
            actions: [
              _buildGlassButton(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                () => setState(() => isSaved = !isSaved),
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
                      imageUrl: widget.recipeImageUrl,
                      width: double.infinity,
                      height: double.infinity),
                  Container(
                    decoration: const BoxDecoration(
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

          // 2. HEADER INFO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipeName,
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.rating} (${reviews.length} reviews)',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: kDarkGreen),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.calories} kcal',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kAccentOrange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Info Chips Row
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildRecipeChip(
                          Icons.restaurant_menu, widget.cuisine, Colors.purple),
                      _buildRecipeChip(
                          Icons.access_time, widget.time, Colors.blue),
                      _buildRecipeChip(Icons.people_outline,
                          '$selectedServings Servings', Colors.green),
                      _buildRecipeChip(
                          Icons.bar_chart, widget.difficulty, Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 3. TAB BAR
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: kDarkGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: kTextGrey,
                dividerColor: Colors.transparent,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                tabs: const [
                  Tab(text: 'Ingredients'),
                  Tab(text: 'Instructions'),
                  Tab(text: 'Reviews')
                ],
              ),
            ),
          ),

          // 4. TAB CONTENT
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIngredientsTab(),
                _buildInstructionsTab(),
                Center(
                    child: Text("Reviews coming soon",
                        style: TextStyle())),
              ],
            ),
          ),
        ],
      ),

      // 5. BOTTOM ACTION
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_basket_outlined),
              label: Text('Add Ingredients to Cart',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
      child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 20), onPressed: onTap),
    );
  }

  Widget _buildRecipeChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: widget.ingredients.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: kBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kPillGrey),
          ),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8, color: kAccentOrange),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(widget.ingredients[index],
                      style:
                          TextStyle(fontSize: 15, color: kDarkGreen))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInstructionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: widget.instructions.length,
      itemBuilder: (context, index) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration:
                  BoxDecoration(color: kDarkGreen, shape: BoxShape.circle),
              child: Center(
                  child: Text('${index + 1}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(widget.instructions[index],
                    style: TextStyle(
                        fontSize: 15, height: 1.6, color: kDarkGreen)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
