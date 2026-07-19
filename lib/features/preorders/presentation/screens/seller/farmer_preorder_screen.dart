import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../../../../core/widgets/app_cached_image.dart';
import '../../providers/seller/farmer_campaigns_controller.dart';
import '../../../domain/entities/preorder_campaign.dart';
import '../create_preorder_campaign_screen.dart';
import 'farmer_campaign_detail_screen.dart';

const _kBgColor = Color(0xFFFFFFFF);
const _kDarkGreen = Color(0xFF1A2F25);
const _kAccentOrange = Color(0xFFE86A33);
const _kBorderColor = Color(0xFFE5E7EB);
const _kTextGrey = Color(0xFF6E7A75);

class FarmerPreorderScreen extends ConsumerWidget {
  const FarmerPreorderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsState = ref.watch(farmerCampaignsControllerProvider);

    return Scaffold(
      backgroundColor: _kBgColor,
      appBar: AppBar(
        backgroundColor: _kBgColor,
        surfaceTintColor: _kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
              color: _kDarkGreen),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: const Text(
          'Pre-order Campaigns',
          style: TextStyle(
            color: _kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: _kDarkGreen,
        backgroundColor: Colors.white,
        onRefresh: () async {
          await ref.read(farmerCampaignsControllerProvider.notifier).refresh();
        },
        child: campaignsState.maybeWhen(
          initial: () => const Center(
            child: CircularProgressIndicator(color: _kDarkGreen),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: _kDarkGreen),
          ),
          error: (error) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(error.toString(),
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .read(farmerCampaignsControllerProvider.notifier)
                      .refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (campaigns) {
            if (campaigns.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(PhosphorIconsRegular.calendarBlank,
                          size: 56, color: _kTextGrey),
                      const SizedBox(height: 16),
                      const Text(
                        'No pre-order campaigns yet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _kDarkGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create one to start selling before harvest',
                        style: TextStyle(color: _kTextGrey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CreatePreorderCampaignScreen(),
                            ),
                          );
                        },
                        icon: const PhosphorIcon(
                          PhosphorIconsRegular.plus,
                          color: AppColors.white,
                        ),
                        label: const Text('New Campaign'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100),
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final campaign = campaigns[index];
                return _CampaignCard(
                  campaign: campaign,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FarmerCampaignDetailScreen(campaign: campaign),
                    ),
                  ),
                );
              },
            );
          },
          orElse: () => const SizedBox.shrink(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addCampaignFab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreatePreorderCampaignScreen(),
            ),
          );
        },
        backgroundColor: _kDarkGreen,
        shape: const CircleBorder(),
        child:
            const PhosphorIcon(PhosphorIconsRegular.plus, color: Colors.white),
      ),
    );
  }
}

// ─── Campaign Card ────────────────────────────────────────────────────────────

class _CampaignCard extends ConsumerWidget {
  final FarmerPreorderCampaign campaign;
  final VoidCallback? onTap;
  const _CampaignCard({required this.campaign, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = campaign.targetQuantity > 0
        ? campaign.currentBookedQuantity / campaign.targetQuantity
        : 0.0;

    final images = campaign.images;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (images.isNotEmpty)
                      Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: PageView.builder(
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return AppCachedImage(
                                imageUrl: images[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  campaign.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _kDarkGreen,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              _StatusMenu(campaign: campaign),
                            ],
                          ),
                          if (campaign.pricePerUnit != null &&
                              campaign.unit != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Rp ${campaign.pricePerUnit} / ${campaign.unit}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: _kTextGrey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Target Quantity',
                              style:
                                  TextStyle(fontSize: 12, color: _kTextGrey)),
                          const SizedBox(height: 4),
                          Text('${campaign.targetQuantity}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _kDarkGreen)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Reservations',
                              style:
                                  TextStyle(fontSize: 12, color: _kTextGrey)),
                          const SizedBox(height: 4),
                          Text('${campaign.currentBookedQuantity}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _kDarkGreen)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: _kBorderColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0 ? _kDarkGreen : _kAccentOrange),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: _kBorderColor),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(PhosphorIconsRegular.calendar,
                            size: 14, color: _kTextGrey),
                        const SizedBox(width: 4),
                        Text(
                          'Est. Harvest: ${DateFormat('MMM dd').format(campaign.estimatedHarvestDate)}',
                          style:
                              const TextStyle(fontSize: 12, color: _kTextGrey),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreatePreorderCampaignScreen(
                                campaign: campaign),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(PhosphorIconsRegular.pencilSimple,
                              size: 14, color: _kAccentOrange),
                          const SizedBox(width: 4),
                          const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _kAccentOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReservationsBottomSheet(
      BuildContext context, WidgetRef ref, PreorderCampaign campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReservationsSheet(campaign: campaign),
    );
  }
}

// ─── Status Popup Menu ────────────────────────────────────────────────────────

class _StatusMenu extends ConsumerWidget {
  final FarmerPreorderCampaign campaign;
  const _StatusMenu({required this.campaign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      onSelected: (String result) async {
        if (result == 'delete') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Campaign'),
              content: const Text(
                  'Are you sure you want to delete this campaign? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          if (confirm == true) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deleting campaign...')),
            );
            final success = await ref
                .read(preOrderControllerProvider.notifier)
                .deleteCampaign(campaign.id);
            if (success && context.mounted) {
              ref.read(farmerCampaignsControllerProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Campaign deleted')),
              );
            }
          }
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Updating status to $result...')),
          );
          final success = await ref
              .read(preOrderControllerProvider.notifier)
              .updateCampaignStatus(campaign.id, result);
          if (success && context.mounted) {
            ref.read(farmerCampaignsControllerProvider.notifier).refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Status updated to $result')),
            );
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(value: 'DRAFT', child: Text('Draft')),
        const PopupMenuItem<String>(value: 'ACTIVE', child: Text('Active')),
        const PopupMenuItem<String>(
            value: 'FULLY_BOOKED', child: Text('Fully Booked')),
        const PopupMenuItem<String>(value: 'READY', child: Text('Ready')),
        const PopupMenuItem<String>(
            value: 'COMPLETED', child: Text('Completed')),
        const PopupMenuItem<String>(
            value: 'CANCELLED', child: Text('Cancelled')),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete Campaign', style: TextStyle(color: Colors.red)),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (campaign.status ?? 'Unknown').toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _kDarkGreen,
              ),
            ),
            const SizedBox(width: 4),
            const PhosphorIcon(PhosphorIconsRegular.caretDown,
                size: 14, color: _kDarkGreen),
          ],
        ),
      ),
    );
  }
}

// ─── Reservations Bottom Sheet ────────────────────────────────────────────────

class _ReservationsSheet extends ConsumerWidget {
  final PreorderCampaign campaign;
  const _ReservationsSheet({required this.campaign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Reservations for ${campaign.productName ?? 'Campaign'}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _kDarkGreen,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const PhosphorIcon(PhosphorIconsRegular.x,
                      color: _kDarkGreen),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _kBorderColor),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Target Quantity',
                        style: TextStyle(fontSize: 13, color: _kTextGrey)),
                    const SizedBox(height: 4),
                    Text(
                      '${campaign.targetQuantity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _kDarkGreen,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Total Reserved',
                        style: TextStyle(fontSize: 13, color: _kTextGrey)),
                    const SizedBox(height: 4),
                    Text(
                      '${campaign.currentReservations}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _kDarkGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _kBorderColor),
          if (campaign.status != 'COMPLETED')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Start Fulfillment?'),
                        content: const Text(
                            'This will convert all paid reservations into Orders in your Order Tracking screen, allowing you to plan routes and manage logistics.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Confirm',
                                style: TextStyle(color: _kDarkGreen)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Starting fulfillment...')),
                      );
                      final success = await ref
                          .read(preOrderControllerProvider.notifier)
                          .fulfillCampaign(campaign.id);
                      if (!context.mounted) return;
                      if (success) {
                        ref
                            .read(farmerCampaignsControllerProvider.notifier)
                            .refresh();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Fulfillment started! Check your Orders tab.'),
                            backgroundColor: _kDarkGreen,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to start fulfillment.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kDarkGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Fulfillment',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            child: (campaign.reservations == null ||
                    campaign.reservations!.isEmpty)
                ? const Center(
                    child: Text(
                      'No reservations yet.',
                      style: TextStyle(color: _kTextGrey, fontSize: 15),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: campaign.reservations!.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: _kBorderColor),
                    itemBuilder: (context, index) {
                      final res = campaign.reservations![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100]!,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(PhosphorIconsRegular.user,
                                  color: _kDarkGreen, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    res.buyerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _kDarkGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Status: ${res.status.replaceAll('_', ' ')}',
                                    style: const TextStyle(
                                        fontSize: 13, color: _kTextGrey),
                                  ),
                                  if (res.deliveryMethod != null)
                                    Text(
                                      'Delivery: ${res.deliveryMethod}',
                                      style: const TextStyle(
                                          fontSize: 13, color: _kTextGrey),
                                    ),
                                  if (res.fullAddress != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: InkWell(
                                        onTap: () async {
                                          if (res.latitude != null &&
                                              res.longitude != null) {
                                            final url = Uri.parse(
                                                'https://www.google.com/maps/search/?api=1&query=${res.latitude},${res.longitude}');
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url);
                                            }
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (res.latitude != null)
                                              const Icon(
                                                  PhosphorIconsRegular.mapPin,
                                                  size: 14,
                                                  color: _kAccentOrange),
                                            if (res.latitude != null)
                                              const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                res.fullAddress!,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: res.latitude != null
                                                      ? _kDarkGreen
                                                      : _kTextGrey,
                                                  decoration: res.latitude !=
                                                          null
                                                      ? TextDecoration.underline
                                                      : null,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else if (res.addressId != null)
                                    Text(
                                      'Address ID: ${res.addressId!.length > 8 ? res.addressId!.substring(0, 8) : res.addressId}...',
                                      style: const TextStyle(
                                          fontSize: 13, color: _kTextGrey),
                                    ),
                                  if (res.paymentMethod != null)
                                    Text(
                                      'Payment: ${res.paymentMethod}',
                                      style: const TextStyle(
                                          fontSize: 13, color: _kTextGrey),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${res.quantity} ${campaign.unit ?? 'items'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: _kAccentOrange,
                                    fontSize: 16,
                                  ),
                                ),
                                if (res.totalPrice != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Rp ${res.totalPrice?.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: _kDarkGreen,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
