import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/sourcing_controller.dart';
import 'submit_offer_bottom_sheet.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kFreshGreen = Color(0xFF10B981);

class FarmerSourcingRequestsScreen extends ConsumerStatefulWidget {
  const FarmerSourcingRequestsScreen({super.key});

  @override
  ConsumerState<FarmerSourcingRequestsScreen> createState() =>
      _FarmerSourcingRequestsScreenState();
}

class _FarmerSourcingRequestsScreenState
    extends ConsumerState<FarmerSourcingRequestsScreen> {
  
  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(openSourcingRequestsFutureProvider(1));

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
              color: kDarkGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Open Bulk Requests',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
        ),
      ),
      body: requestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PhosphorIcon(PhosphorIconsRegular.warning, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              TextButton(
                onPressed: () => ref.invalidate(openSourcingRequestsFutureProvider(1)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (paginatedData) {
          final requests = paginatedData.data;
          
          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(PhosphorIconsRegular.empty, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No open requests right now',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(openSourcingRequestsFutureProvider(1));
            },
            color: kDarkGreen,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final req = requests[index];
                
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              req.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: kDarkGreen,
                                  ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: kPillGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              timeago.format(req.createdAt),
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        req.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      if (req.budget != null || req.requiredBy != null) ...[
                        Row(
                          children: [
                            if (req.budget != null) ...[
                              const PhosphorIcon(PhosphorIconsRegular.money, size: 16, color: kFreshGreen),
                              const SizedBox(width: 4),
                              Text(
                                'Rp ${req.budget!.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: kFreshGreen),
                              ),
                              const SizedBox(width: 16),
                            ],
                            if (req.requiredBy != null) ...[
                              PhosphorIcon(PhosphorIconsRegular.calendar, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                '${req.requiredBy!.day}/${req.requiredBy!.month}/${req.requiredBy!.year}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: kPillGrey,
                            backgroundImage: req.buyer?.avatarUrl != null 
                              ? NetworkImage(req.buyer!.avatarUrl!) 
                              : null,
                            child: req.buyer?.avatarUrl == null 
                              ? const Icon(Icons.person, size: 16, color: Colors.grey) 
                              : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            req.buyer?.name ?? 'Unknown Buyer',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                          ),
                          const Spacer(),
                          Text(
                            '${req.offersCount} offers',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SubmitOfferBottomSheet(request: req),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Submit Offer'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
