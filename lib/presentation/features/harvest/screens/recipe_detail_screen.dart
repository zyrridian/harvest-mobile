import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../shared_widgets/app_cached_image.dart';

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

  final List<RecipeReview> reviews = [
    RecipeReview(
      userName: 'Sarah Johnson',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      rating: 5.0,
      comment:
          'Absolutely delicious! My family loved it. Easy to follow instructions.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      helpfulCount: 24,
      images: [
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'
      ],
    ),
    RecipeReview(
      userName: 'Michael Chen',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      rating: 4.5,
      comment:
          'Great recipe! I substituted honey with maple syrup and it worked perfectly.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      helpfulCount: 18,
      images: [],
    ),
    RecipeReview(
      userName: 'Emma Rodriguez',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      rating: 5.0,
      comment:
          'Made this for a dinner party and everyone asked for the recipe!',
      date: DateTime.now().subtract(const Duration(days: 7)),
      helpfulCount: 31,
      images: [
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        'https://images.unsplash.com/photo-1564936281288-2e0e15f93fd7?w=400',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    selectedServings = widget.servings;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image App Bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedImage(
                    imageUrl: widget.recipeImageUrl,
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
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  setState(() {
                    isSaved = !isSaved;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(isSaved ? 'Recipe saved!' : 'Recipe removed'),
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

          // Recipe Title & Info
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipeName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        widget.rating.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${reviews.length} reviews)',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                          Icons.restaurant_menu, widget.cuisine, Colors.purple),
                      _buildInfoChip(
                          Icons.access_time, widget.time, Colors.blue),
                      _buildInfoChip(Icons.local_fire_department,
                          '${widget.calories} cal', Colors.orange),
                      _buildInfoChip(
                        Icons.bar_chart,
                        widget.difficulty,
                        widget.difficulty == 'Easy'
                            ? Colors.green
                            : widget.difficulty == 'Medium'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Ingredients'),
                  Tab(text: 'Instructions'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIngredientsTab(),
                _buildInstructionsTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Adding ingredients to cart...')),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Start cooking mode coming soon')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Servings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (selectedServings > 1) {
                        setState(() {
                          selectedServings--;
                        });
                      }
                    },
                  ),
                  Text(
                    selectedServings.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        selectedServings++;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...widget.ingredients.map((ingredient) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline,
                  color: AppColors.primary),
              title: Text(ingredient),
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added $ingredient to cart')),
                  );
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        const Text(
          'Substitutions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildSubstitutionCard('Honey', 'Maple syrup, Agave nectar'),
        _buildSubstitutionCard('Olive oil', 'Avocado oil, Vegetable oil'),
        _buildSubstitutionCard('Spinach', 'Kale, Arugula'),
      ],
    );
  }

  Widget _buildInstructionsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ...widget.instructions.asMap().entries.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.value,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                      if (entry.key == 0) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppCachedImage(
                            imageUrl:
                                'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400',
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.photo_camera, size: 16),
                            label: const Text('Add Photo',
                                style: TextStyle(fontSize: 12)),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.timer, size: 16),
                            label: const Text('Set Timer',
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 32),
                    const SizedBox(width: 8),
                    Text(
                      widget.rating.toString(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${reviews.length} reviews',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showAddReviewDialog();
              },
              icon: const Icon(Icons.rate_review, size: 16),
              label: const Text('Write Review'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...reviews.map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildReviewCard(RecipeReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
                backgroundImage: NetworkImage(review.userAvatar),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(review.date),
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.comment),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AppCachedImage(
                        imageUrl: review.images[index],
                        width: 80,
                        height: 80,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_outlined, size: 16),
                label: Text('Helpful (${review.helpfulCount})'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.reply, size: 16),
                label: const Text('Reply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubstitutionCard(String ingredient, String substitutes) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.swap_horiz, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  substitutes,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
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

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Rate this recipe'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: const Icon(Icons.star_border),
                  color: Colors.amber,
                  onPressed: () {},
                );
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
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
                const SnackBar(content: Text('Review submitted!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class RecipeReview {
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime date;
  final int helpfulCount;
  final List<String> images;

  RecipeReview({
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.date,
    required this.helpfulCount,
    required this.images,
  });
}
