import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_app/features/community/domain/entities/recipe.dart';
import 'package:intl/intl.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: _buildRecipeContent(context),
          ),
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          recipe.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.restaurant, size: 64, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author & Date
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: recipe.author.avatarUrl != null
                    ? NetworkImage(recipe.author.avatarUrl!)
                    : null,
                child: recipe.author.avatarUrl == null
                    ? const Icon(Icons.person, size: 16, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  recipe.author.name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              Text(
                DateFormat('MMM d, yyyy').format(recipe.createdAt),
                style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Title
          Text(
            recipe.title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          
          // Description
          if (recipe.description.isNotEmpty) ...[
            Text(
              recipe.description,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
          ],
          
          // Metadata Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetaCard(Icons.schedule, 'Prep Time', '${recipe.prepTimeMinutes}m'),
              _buildMetaCard(Icons.outdoor_grill, 'Cook Time', '${recipe.cookTimeMinutes}m'),
              _buildMetaCard(Icons.people_outline, 'Servings', '${recipe.servings}'),
              _buildMetaCard(Icons.bar_chart, 'Difficulty', recipe.difficulty ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          
          // Ingredients
          Text(
            'Ingredients',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (recipe.ingredients.isEmpty)
            Text('No ingredients listed.', style: GoogleFonts.inter(color: Colors.grey.shade600))
          else
            ...recipe.ingredients.map((ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF166534), // kPrimaryGreen
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ingredient.name,
                      style: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                  if (ingredient.quantity != null)
                    Text(
                      '${ingredient.quantity} ${ingredient.unit ?? ''}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                ],
              ),
            )),
          
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          
          // Instructions
          Text(
            'Instructions',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (recipe.instructions.isEmpty)
            Text('No instructions listed.', style: GoogleFonts.inter(color: Colors.grey.shade600))
          else
            ...recipe.instructions.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF166534).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF166534),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildMetaCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
