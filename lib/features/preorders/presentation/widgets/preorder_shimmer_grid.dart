import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PreOrderShimmerGrid extends StatelessWidget {
  const PreOrderShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[100]!,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.white),
                    const SizedBox(height: 4),
                    Container(height: 11, width: 100, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(
                        height: 4, width: double.infinity, color: Colors.white),
                    const SizedBox(height: 10),
                    Container(height: 14, width: 80, color: Colors.white),
                  ],
                ),
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
