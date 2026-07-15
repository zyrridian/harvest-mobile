import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/sourcing/domain/entities/sourcing_request.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../providers/sourcing_controller.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kFreshGreen = Color(0xFF10B981);

class BuyerRequestDetailsScreen extends ConsumerStatefulWidget {
  final SourcingRequest request;
  const BuyerRequestDetailsScreen({super.key, required this.request});

  @override
  ConsumerState<BuyerRequestDetailsScreen> createState() =>
      _BuyerRequestDetailsScreenState();
}

class _BuyerRequestDetailsScreenState
    extends ConsumerState<BuyerRequestDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final offersAsync = ref.watch(sourcingOffersFutureProvider(widget.request.id));
    final actionState = ref.watch(sourcingActionControllerProvider);

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
          'Request Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.request.status == 'open' ? kFreshGreen.withOpacity(0.1) : kPillGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.request.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.request.status == 'open' ? kFreshGreen : Colors.grey[700],
                          ),
                        ),
                      ),
                      Text(
                        timeago.format(widget.request.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.request.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.request.description,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  if (widget.request.budget != null) ...[
                    Row(
                      children: [
                        const Icon(PhosphorIconsRegular.money, color: kDarkGreen, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Budget: Rp ${widget.request.budget?.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: kDarkGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (widget.request.status == 'open') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: actionState.isLoading ? null : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Cancel Request?'),
                              content: const Text('Are you sure you want to cancel this request?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
                                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, cancel')),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await ref.read(sourcingActionControllerProvider.notifier).cancelRequest(widget.request.id);
                            if (context.mounted) {
                              context.pop(); // Go back
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cancel Request'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(20),
              child: Text(
                'Received Offers',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen,
                    ),
              ),
            ),
          ),
          offersAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: kDarkGreen)),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
            data: (offers) {
              if (offers.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PhosphorIcon(PhosphorIconsRegular.empty, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No offers yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final offer = offers[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: kPillGrey,
                                backgroundImage: offer.farmer?.profileImage != null ? NetworkImage(offer.farmer!.profileImage!) : null,
                                child: offer.farmer?.profileImage == null ? const Icon(PhosphorIconsRegular.user, color: Colors.grey) : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      offer.farmer?.name ?? 'Unknown Farmer',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    if (offer.farmer?.rating != null)
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            offer.farmer!.rating!.toStringAsFixed(1),
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp ${offer.price.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: kAccentOrange, fontSize: 16),
                              ),
                            ],
                          ),
                          if (offer.notes != null && offer.notes!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(offer.notes!, style: TextStyle(color: Colors.grey[700])),
                            ),
                          ],
                          const SizedBox(height: 16),
                          if (widget.request.status == 'open')
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: actionState.isLoading ? null : () async {
                                  final convId = await ref.read(sourcingActionControllerProvider.notifier).acceptOffer(offer.id);
                                  if (convId != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Offer accepted! Check your chats.')),
                                    );
                                    context.pop(); // Go back to requests list
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Accept Offer & Chat'),
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: offer.status == 'accepted' ? kFreshGreen.withOpacity(0.1) : kPillGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                offer.status.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: offer.status == 'accepted' ? kFreshGreen : Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  childCount: offers.length,
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }
}
