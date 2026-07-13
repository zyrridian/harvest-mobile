import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/domain/entities/drop_point.dart';
import '../providers/drop_points_controller.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kBorderColor = Color(0xFFE5E7EB);

class DropPointsScreen extends ConsumerWidget {
  const DropPointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropPointsState = ref.watch(dropPointsControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'Manage Drop Points',
          style: TextStyle(color: kDarkGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkGreen),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRouter.editDropPoint);
        },
        backgroundColor: kAccentOrange,
        child: const Icon(PhosphorIconsRegular.plus, color: Colors.white),
      ),
      body: dropPointsState.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryGreen)),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error.toString(), style: TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(dropPointsControllerProvider.notifier).fetchDropPoints(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (points) {
          if (points.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIconsRegular.mapTrifold, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No Drop Points yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkGreen),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a location where customers can pick up their orders.',
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(dropPointsControllerProvider.notifier).fetchDropPoints();
            },
            color: kPrimaryGreen,
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: points.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final point = points[index];
                return _buildDropPointCard(context, ref, point);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropPointCard(BuildContext context, WidgetRef ref, DropPoint point) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (point.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                point.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        point.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: point.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        point.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: point.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(PhosphorIconsRegular.mapPin, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        point.address,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(PhosphorIconsRegular.clock, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        point.operatingHours,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (point.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: point.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: kBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kBorderColor),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(fontSize: 12, color: kDarkGreen, fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Confirm deletion
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Drop Point'),
                            content: const Text('Are you sure you want to delete this drop point?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  ref.read(dropPointsControllerProvider.notifier).deleteDropPoint(point.id);
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(PhosphorIconsRegular.trash, size: 18, color: Colors.red),
                      label: Text('Delete', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(100, 44),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push(AppRouter.editDropPoint, extra: point);
                      },
                      icon: const Icon(PhosphorIconsRegular.pencilSimple, size: 18),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 44),
                        backgroundColor: kPrimaryGreen,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
