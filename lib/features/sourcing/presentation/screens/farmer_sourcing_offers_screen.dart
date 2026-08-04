import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/sourcing_controller.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kFreshGreen = Color(0xFF10B981);

class FarmerSourcingOffersScreen extends ConsumerStatefulWidget {
  const FarmerSourcingOffersScreen({super.key});

  @override
  ConsumerState<FarmerSourcingOffersScreen> createState() =>
      _FarmerSourcingOffersScreenState();
}

class _FarmerSourcingOffersScreenState extends ConsumerState<FarmerSourcingOffersScreen> {
  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(mySourcingOffersFutureProvider(1));

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
          'My Submitted Offers',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
        ),
      ),
      body: offersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PhosphorIcon(PhosphorIconsRegular.warning, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              TextButton(
                onPressed: () => ref.invalidate(mySourcingOffersFutureProvider(1)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (paginatedData) {
          final offers = paginatedData.data;

          if (offers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PhosphorIcon(PhosphorIconsRegular.empty, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'You haven\'t submitted any offers yet',
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
              ref.invalidate(mySourcingOffersFutureProvider(1));
            },
            color: kDarkGreen,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: offers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final offer = offers[index];
                final request = offer.request; // Available in response for me endpoint

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
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: offer.status == 'accepted' 
                                  ? kFreshGreen.withOpacity(0.1) 
                                  : (offer.status == 'rejected' ? Colors.red.withOpacity(0.1) : kPillGrey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              offer.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: offer.status == 'accepted' 
                                    ? kFreshGreen 
                                    : (offer.status == 'rejected' ? Colors.red : Colors.grey[700]),
                              ),
                            ),
                          ),
                          Text(
                            timeago.format(offer.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Request Context
                      if (request != null) ...[
                        Text(
                          'For: ${request.title}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kDarkGreen,
                              ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      
                      const Divider(),
                      const SizedBox(height: 8),

                      Text(
                        'Your Price: Rp ${offer.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: kAccentOrange, fontSize: 16),
                      ),
                      if (offer.notes != null && offer.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Notes: ${offer.notes}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                      
                      if (offer.status == 'accepted') ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kDarkGreen.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(PhosphorIconsFill.chatCircleText, color: kDarkGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'The buyer accepted your offer! Check your chats.',
                                  style: TextStyle(color: kDarkGreen, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
