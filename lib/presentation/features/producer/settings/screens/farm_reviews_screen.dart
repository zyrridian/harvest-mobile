import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../providers/farm_reviews_controller.dart';
import 'package:harvest_app/domain/entities/farm_review.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class FarmReviewsScreen extends ConsumerWidget {
  const FarmReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsState = ref.watch(farmReviewsControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'My Farm Reviews',
          style: TextStyle(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkGreen),
      ),
      body: reviewsState.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error.toString(), style: TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(farmReviewsControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (response) => RefreshIndicator(
          color: kDarkGreen,
          onRefresh: () => ref.read(farmReviewsControllerProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(response.summary),
                const SizedBox(height: 24),
                Text(
                  'Customer Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 16),
                _buildReviewsList(response.reviews),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(FarmReviewSummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Average Rating
          Column(
            children: [
              Text(
                summary.averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Icon(
                    index < summary.averageRating.round()
                        ? PhosphorIconsFill.star
                        : PhosphorIconsRegular.star,
                    color: kAccentOrange,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                '${summary.totalReviews} reviews',
                style: TextStyle(
                  color: kTextGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          // Distribution
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((rating) {
                final count = summary.ratingDistribution[rating.toString()] ?? 0;
                final percentage = summary.totalReviews > 0 ? count / summary.totalReviews : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$rating',
                        style: TextStyle(
                          color: kDarkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(PhosphorIconsFill.star, color: kAccentOrange, size: 10),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: kBorderColor,
                            color: kAccentOrange,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 24,
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: kTextGrey,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(List<FarmReview> reviews) {
    if (reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              const Icon(PhosphorIconsRegular.chatTeardropText, size: 48, color: kTextGrey),
              const SizedBox(height: 16),
              Text(
                'No reviews yet',
                style: TextStyle(
                  color: kTextGrey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: kBorderColor,
                    backgroundImage: review.user.avatarUrl != null
                        ? NetworkImage(review.user.avatarUrl!)
                        : null,
                    child: review.user.avatarUrl == null
                        ? const Icon(PhosphorIconsRegular.user, color: kTextGrey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                        ),
                        Text(
                          DateFormat.yMMMd().format(review.createdAt),
                          style: TextStyle(
                            color: kTextGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < review.rating ? PhosphorIconsFill.star : PhosphorIconsRegular.star,
                        color: kAccentOrange,
                        size: 14,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (review.isVerifiedPurchase)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kPrimaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(PhosphorIconsFill.checkCircle, color: kPrimaryGreen, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Verified Purchase',
                        style: TextStyle(
                          color: kPrimaryGreen,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                review.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                review.comment,
                style: TextStyle(
                  color: kDarkGreen.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kBorderColor,
                        borderRadius: BorderRadius.circular(4),
                        image: review.product.image != null
                            ? DecorationImage(
                                image: NetworkImage(review.product.image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: review.product.image == null
                          ? const Icon(PhosphorIconsRegular.package, color: kTextGrey)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        review.product.name,
                        style: TextStyle(
                          color: kDarkGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (review.helpfulCount > 0) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(PhosphorIconsRegular.thumbsUp, color: kTextGrey, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${review.helpfulCount} people found this helpful',
                      style: TextStyle(
                        color: kTextGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
