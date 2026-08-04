import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/sourcing_controller.dart';
import '../../../../core/config/router/app_router.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kFreshGreen = Color(0xFF10B981);

class BuyerSourcingRequestsScreen extends ConsumerStatefulWidget {
  const BuyerSourcingRequestsScreen({super.key});

  @override
  ConsumerState<BuyerSourcingRequestsScreen> createState() =>
      _BuyerSourcingRequestsScreenState();
}

class _BuyerSourcingRequestsScreenState
    extends ConsumerState<BuyerSourcingRequestsScreen> {
  
  @override
  Widget build(BuildContext context) {
    final myRequestsAsync = ref.watch(mySourcingRequestsFutureProvider(1));

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
          'My Bulk Requests',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
        ),
        actions: [
          IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.plus, color: kDarkGreen),
            onPressed: () => context.push(AppRouter.createSourcingRequest),
          )
        ],
      ),
      body: myRequestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PhosphorIcon(PhosphorIconsRegular.warning, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              TextButton(
                onPressed: () => ref.invalidate(mySourcingRequestsFutureProvider(1)),
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
                  PhosphorIcon(PhosphorIconsRegular.clipboardText, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'You haven\'t made any requests yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.push(AppRouter.createSourcingRequest),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Create a Request'),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(mySourcingRequestsFutureProvider(1));
            },
            color: kDarkGreen,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final req = requests[index];
                
                return GestureDetector(
                  onTap: () => context.push(AppRouter.buyerRequestDetails, extra: req),
                  child: Container(
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
                              req.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12, 
                                fontWeight: FontWeight.bold,
                                color: req.status == 'open' ? kFreshGreen : Colors.grey[700],
                              ),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeago.format(req.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            '${req.offersCount} Offers',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: kAccentOrange),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
              },
            ),
          );
        },
      ),
    );
  }
}
