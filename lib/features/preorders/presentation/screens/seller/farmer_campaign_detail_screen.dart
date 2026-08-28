import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign.dart';
import 'package:harvest_app/features/preorders/domain/entities/farmer_preorder_campaign_detail.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import '../../../../../core/config/router/app_router.dart';
import '../../../../../core/widgets/app_cached_image.dart';
import '../../providers/seller/farmer_campaigns_controller.dart';
import 'package:harvest_app/features/chat/presentation/providers/messaging_providers.dart';

const _kBg = Color(0xFFFFFFFF);
const _kDark = Color(0xFF1A2F25);
const _kGreen = Color(0xFF2D4A3E);
const _kOrange = Color(0xFFE86A33);
const _kBorder = Color(0xFFE5E7EB);
const _kGrey = Color(0xFF6E7A75);
const _kSurface = Color(0xFFF8F9FA);

// ─── Dummy data for buyers missing from backend ───────────────────────────────

const _dummyAvatars = [
  'https://i.pravatar.cc/150?img=1',
  'https://i.pravatar.cc/150?img=2',
  'https://i.pravatar.cc/150?img=3',
  'https://i.pravatar.cc/150?img=4',
  'https://i.pravatar.cc/150?img=5',
];

const _dummyAddresses = [
  'Jl. Sudirman No. 12, Jakarta Pusat, DKI Jakarta 10220',
  'Jl. Raya Bogor Km 30, Cimanggis, Depok 16952',
  'Jl. Gatot Subroto No. 45, Bandung 40261',
  'Jl. Merdeka Barat No. 7, Malang 65111',
  'Jl. Imam Bonjol No. 22, Semarang 50132',
];

// ─── Campaign Detail Screen ───────────────────────────────────────────────────

class FarmerCampaignDetailScreen extends ConsumerStatefulWidget {
  final FarmerPreorderCampaign campaign;

  const FarmerCampaignDetailScreen({super.key, required this.campaign});

  @override
  ConsumerState<FarmerCampaignDetailScreen> createState() =>
      _FarmerCampaignDetailScreenState();
}

class _FarmerCampaignDetailScreenState
    extends ConsumerState<FarmerCampaignDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final detailAsync =
        ref.watch(farmerCampaignDetailProvider(widget.campaign.id));

    // Fallback data from widget.campaign
    final displayCampaign = widget.campaign;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(farmerCampaignDetailProvider(widget.campaign.id));
        await ref.read(farmerCampaignsControllerProvider.notifier).refresh();
      },
      child: Scaffold(
        backgroundColor: _kBg,
        body: CustomScrollView(
          slivers: [
            // ── Hero App Bar ──────────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 240,
              pinned: true,
              backgroundColor: _kBg,
              surfaceTintColor: _kBg,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  if (context.canPop()) context.pop();
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: detailAsync.maybeWhen(
                  data: (detail) {
                    final images = detail.images.isNotEmpty
                        ? detail.images
                        : widget.campaign.images;
                    if (images.isEmpty) {
                      return Container(
                        color: _kDark,
                        child: const Center(
                          child: Icon(PhosphorIconsFill.calendarCheck,
                              color: Colors.white54, size: 48),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (idx) =>
                              setState(() => _currentImageIndex = idx),
                          itemBuilder: (context, index) {
                            return AppCachedImage(
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.zero,
                            );
                          },
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentImageIndex == index ? 24 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _currentImageIndex == index
                                        ? _kOrange
                                        : Colors.white.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  orElse: () {
                    final images = widget.campaign.images;
                    if (images.isEmpty) {
                      return Container(
                        color: _kDark,
                        child: const Center(
                          child: Icon(PhosphorIconsFill.calendarCheck,
                              color: Colors.white54, size: 48),
                        ),
                      );
                    }
                    return AppCachedImage(
                      imageUrl: images.first,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.zero,
                    );
                  },
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name + status badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            detailAsync.hasValue
                                ? detailAsync.value!.title
                                : displayCampaign.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: _kDark,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _StatusBadge(
                            status: detailAsync.hasValue
                                ? detailAsync.value!.status
                                : displayCampaign.status ?? 'UNKNOWN'),
                      ],
                    ),

                    Builder(builder: (context) {
                      final price = detailAsync.hasValue
                          ? detailAsync.value!.pricePerUnit
                          : displayCampaign.pricePerUnit;
                      final unit = detailAsync.hasValue
                          ? detailAsync.value!.unit
                          : displayCampaign.unit;
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Rp ${NumberFormat('#,###').format(price)} / $unit',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _kOrange,
                          ),
                        ),
                      );
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: 20),

                    // Stats row
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _kSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _kBorder),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Builder(builder: (context) {
                                final reserved = detailAsync.hasValue
                                    ? detailAsync.value!.totalPeopleReserved
                                    : displayCampaign.currentBookedQuantity;
                                return _StatItem(
                                  icon: PhosphorIconsFill.users,
                                  label: 'Reserved',
                                  value: '$reserved',
                                  color: _kDark,
                                );
                              }),
                              _buildDivider(),
                              Builder(builder: (context) {
                                final target = detailAsync.hasValue
                                    ? detailAsync.value!.targetQuantity
                                    : displayCampaign.targetQuantity;
                                return _StatItem(
                                  icon: PhosphorIconsFill.target,
                                  label: 'Target',
                                  value: '$target',
                                  color: _kDark,
                                );
                              }),
                              _buildDivider(),
                              Builder(builder: (context) {
                                final harvest = detailAsync.hasValue
                                    ? detailAsync.value!.estimatedHarvestDate
                                    : displayCampaign.estimatedHarvestDate;
                                return _StatItem(
                                  icon: PhosphorIconsFill.calendarCheck,
                                  label: 'Harvest',
                                  value: DateFormat('MMM dd').format(harvest),
                                  color: _kGreen,
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Builder(builder: (context) {
                            final target = detailAsync.hasValue
                                ? detailAsync.value!.targetQuantity
                                : displayCampaign.targetQuantity;
                            final booked = detailAsync.hasValue
                                ? detailAsync.value!.currentBookedQuantity
                                : displayCampaign.currentBookedQuantity;
                            final progress = target > 0 ? booked / target : 0.0;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Campaign Progress',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: _kDark)),
                                    Text(
                                        '${(progress * 100).toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: _kOrange)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress.clamp(0.0, 1.0),
                                    backgroundColor: _kBorder,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            _kOrange),
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // // Fulfillment button
                    // Builder(builder: (context) {
                    //   final status = detailAsync.hasValue
                    //       ? detailAsync.value!.status
                    //       : displayCampaign.status;
                    //   final booked = detailAsync.hasValue
                    //       ? detailAsync.value!.currentBookedQuantity
                    //       : displayCampaign.currentBookedQuantity;
                    //   if (status != 'COMPLETED' && booked > 0) {
                    //     return _FulfillmentButton(campaign: displayCampaign);
                    //   }
                    //   return const SizedBox.shrink();
                    // }),

                    // const SizedBox(height: 28),

                    // Reservations header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reservations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _kDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _kDark.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Builder(builder: (context) {
                            final count = detailAsync.hasValue
                                ? detailAsync.value!.totalPeopleReserved
                                : displayCampaign.currentBookedQuantity;
                            return Text(
                              '$count buyers',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _kDark,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Reservations List ─────────────────────────────────────────────
            _buildReservationsList(context, detailAsync),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() => Container(
        width: 1,
        height: 36,
        color: _kBorder,
        margin: const EdgeInsets.symmetric(horizontal: 16),
      );

  Widget _buildReservationsList(BuildContext context,
      AsyncValue<FarmerPreorderCampaignDetail> detailAsync) {
    return detailAsync.maybeWhen(
      data: (detail) {
        final reservations = detail.reservations;
        if (reservations.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('No reservations yet.',
                    style: TextStyle(color: _kGrey)),
              ),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _ReservationCard(
              reservation: reservations[index],
              index: index,
              campaign: widget.campaign,
            ),
            childCount: reservations.length,
          ),
        );
      },
      orElse: () {
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator(color: _kOrange)),
          ),
        );
      },
    );
  }
}

// ─── Reservation Card (real data) ────────────────────────────────────────────

class _ReservationCard extends ConsumerStatefulWidget {
  final FarmerPreorderReservation reservation;
  final int index;
  final FarmerPreorderCampaign campaign;

  const _ReservationCard({
    required this.reservation,
    required this.index,
    required this.campaign,
  });

  @override
  ConsumerState<_ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends ConsumerState<_ReservationCard> {
  late String _currentStatus;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.reservation.status;
  }

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservation;
    final campaign = widget.campaign;
    final avatarUrl = reservation.buyerAvatarUrl ??
        _dummyAvatars[widget.index % _dummyAvatars.length];
    final address = reservation.fullAddress ?? 'No address provided';
    final hasCoords =
        reservation.latitude != null && reservation.longitude != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top: buyer info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      avatarUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: _kSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(PhosphorIconsFill.user,
                            color: _kGrey, size: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name + status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reservation.buyerName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _kDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            _StatusPill(status: _currentStatus),
                            const SizedBox(width: 8),
                            if (reservation.paymentMethod != null)
                              Text(
                                '· ${reservation.paymentMethod}',
                                style: const TextStyle(
                                    fontSize: 12, color: _kGrey),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Quantity + price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${reservation.quantity} ${campaign.unit ?? 'items'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _kOrange,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###').format(reservation.totalPrice.toInt())}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _kDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Address row
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _kBorder)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(PhosphorIconsFill.mapPin,
                      size: 16, color: _kOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _kGrey,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _kBorder)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Chat
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIconsRegular.chatCircle,
                      label: 'Chat',
                      color: _kDark,
                      onTap: () async {
                        final startConversation =
                            ref.read(startConversationUsecaseProvider);
                        final result = await startConversation(
                          recipientId: reservation.buyerId,
                          type: 'general',
                        );

                        result.fold(
                          (failure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Could not open chat: ${failure.message}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          (data) {
                            final convId =
                                data['data']?['conversation_id'] as String? ??
                                    reservation.conversationId ??
                                    'new_${reservation.buyerId}';

                            context.push(
                              AppRouter.chat,
                              extra: {
                                'conversationId': convId,
                                'farmerName': reservation.buyerName,
                                'farmerAvatar': avatarUrl,
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 6),

                  // View Map (only if coords exist)
                  if (hasCoords)
                    ...([
                      Expanded(
                        child: _ActionButton(
                          icon: PhosphorIconsRegular.mapTrifold,
                          label: 'Map',
                          color: _kGreen,
                          onTap: () => _showMapBottomSheet(
                              context, reservation, address),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ]),

                  // Navigate
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIconsRegular.navigationArrow,
                      label: 'Navigate',
                      color: _kOrange,
                      onTap: () => _openGoogleMaps(
                        lat: reservation.latitude,
                        lng: reservation.longitude,
                        address: address,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Status change
                  Expanded(
                    child: _isUpdating
                        ? const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: _kDark),
                            ),
                          )
                        : _ActionButton(
                            icon: PhosphorIconsRegular.arrowsClockwise,
                            label: 'Status',
                            color: const Color(0xFF7C5CBF),
                            onTap: () => _showStatusSheet(context, reservation),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusSheet(
      BuildContext context, FarmerPreorderReservation reservation) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => _ReservationStatusSheet(
        currentStatus: _currentStatus,
        buyerName: reservation.buyerName,
        onStatusSelected: (newStatus) async {
          Navigator.pop(sheetContext);
          setState(() => _isUpdating = true);
          final errorMessage = await ref
              .read(preOrderControllerProvider.notifier)
              .updateReservationStatus(reservation.id, newStatus);
          if (mounted) {
            setState(() {
              _isUpdating = false;
              if (errorMessage == null) _currentStatus = newStatus;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  errorMessage == null
                      ? 'Status updated to ${newStatus.replaceAll("_", " ")}'
                      : errorMessage,
                ),
                backgroundColor: errorMessage == null ? _kDark : Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  void _showMapBottomSheet(BuildContext context,
      FarmerPreorderReservation reservation, String address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MapPreviewSheet(
        reservation: reservation,
        address: address,
      ),
    );
  }

  Future<void> _openGoogleMaps({
    required double? lat,
    required double? lng,
    required String address,
  }) async {
    final Uri url;
    if (lat != null && lng != null) {
      url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    } else {
      final encoded = Uri.encodeComponent(address);
      url =
          Uri.parse('https://www.google.com/maps/search/?api=1&query=$encoded');
    }
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Could not launch Google Maps: $e');
      await launchUrl(url, mode: LaunchMode.platformDefault);
    }
  }
}

// ─── Dummy Reservation Card ───────────────────────────────────────────────────

class _DummyReservationCard extends StatelessWidget {
  final int index;
  final String unit;

  const _DummyReservationCard({required this.index, required this.unit});

  static const _names = [
    'Budi Santoso',
    'Siti Rahayu',
    'Ahmad Fauzi',
    'Dewi Lestari',
    'Eko Prasetyo',
  ];
  static const _quantities = [5, 10, 8, 12, 6];
  static const _statuses = [
    'PAID',
    'PENDING_PAYMENT',
    'PAID',
    'CONFIRMED',
    'PAID'
  ];
  static const _payments = ['Transfer', 'COD', 'Transfer', 'Transfer', 'COD'];
  static const _dummyLats = [-6.2088, -6.3662, -6.9175, -7.9666, -6.9932];
  static const _dummyLngs = [106.8456, 106.8325, 107.6191, 112.6326, 110.4203];

  @override
  Widget build(BuildContext context) {
    final name = _names[index % _names.length];
    final avatarUrl = _dummyAvatars[index % _dummyAvatars.length];
    final address = _dummyAddresses[index % _dummyAddresses.length];
    final qty = _quantities[index % _quantities.length];
    final status = _statuses[index % _statuses.length];
    final payment = _payments[index % _payments.length];
    final lat = _dummyLats[index % _dummyLats.length];
    final lng = _dummyLngs[index % _dummyLngs.length];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      avatarUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: _kSurface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(PhosphorIconsFill.user,
                            color: _kGrey, size: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _kDark,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'DEMO',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            _StatusPill(status: status),
                            const SizedBox(width: 8),
                            Text('· $payment',
                                style: const TextStyle(
                                    fontSize: 12, color: _kGrey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$qty $unit',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _kOrange,
                        ),
                      ),
                      Text(
                        'Demo data',
                        style: const TextStyle(
                          fontSize: 11,
                          color: _kGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _kBorder)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(PhosphorIconsFill.mapPin,
                      size: 16, color: _kOrange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _kGrey,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _kBorder)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIconsRegular.chatCircle,
                      label: 'Chat',
                      color: _kDark,
                      onTap: () {
                        context.push(
                          AppRouter.chat,
                          extra: {
                            'conversationId': 'conv_dummy_$index',
                            'farmerName': name,
                            'farmerAvatar': avatarUrl,
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIconsRegular.mapTrifold,
                      label: 'Map',
                      color: _kGreen,
                      onTap: () => {},
                      // _showDummyMap(context, name, address, lat, lng),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIconsRegular.navigationArrow,
                      label: 'Navigate',
                      color: _kOrange,
                      onTap: () async {
                        final url = Uri.parse(
                            'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _ActionButton(
                      icon: PhosphorIconsRegular.arrowsClockwise,
                      label: 'Status',
                      color: const Color(0xFF7C5CBF),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Status update not available for demo data'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reservation Status Sheet ─────────────────────────────────────────────────

class _ReservationStatusSheet extends StatelessWidget {
  final String currentStatus;
  final String buyerName;
  final Future<void> Function(String status) onStatusSelected;

  const _ReservationStatusSheet({
    required this.currentStatus,
    required this.buyerName,
    required this.onStatusSelected,
  });

  static const _statuses = [
    (
      'PENDING_PAYMENT',
      'Pending Payment',
      Color(0xFFE86A33), // Orange
      PhosphorIconsRegular.clockCountdown
    ),
    (
      'PAID',
      'Paid',
      Color(0xFF2E7D32), // Green
      PhosphorIconsRegular.checkCircle
    ),
    ('COMPLETED', 'Completed', Color(0xFF1A2F25), PhosphorIconsRegular.star),
    ('CANCELLED', 'Cancelled', Colors.red, PhosphorIconsRegular.xCircle),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Row(
              children: [
                const Icon(PhosphorIconsFill.arrowsClockwise,
                    color: Color(0xFF7C5CBF), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Update Reservation Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _kDark,
                        ),
                      ),
                      Text(
                        buyerName,
                        style: const TextStyle(fontSize: 12, color: _kGrey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: _kGrey),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _kBorder),

          // Status options
          ..._statuses.map((entry) {
            final (value, label, color, icon) = entry;
            final isCurrent = currentStatus.toUpperCase() == value;
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              title: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: isCurrent ? color : _kDark,
                ),
              ),
              trailing: isCurrent
                  ? Icon(PhosphorIconsFill.checkCircle, color: color, size: 20)
                  : null,
              onTap: isCurrent ? null : () => onStatusSelected(value),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Map Preview Bottom Sheet ─────────────────────────────────────────────────

class _MapPreviewSheet extends StatelessWidget {
  final FarmerPreorderReservation reservation;
  final String address;

  const _MapPreviewSheet({
    required this.reservation,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final lat = reservation.latitude;
    final lng = reservation.longitude;
    final mapsUrl = lat != null && lng != null
        ? 'https://www.google.com/maps/search/?api=1&query=$lat,$lng'
        : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';

    // We use a static map image from Yandex Static API
    final staticMapUrl = lat != null && lng != null
        ? 'https://static-maps.yandex.ru/1.x/?lang=en_US&ll=$lng,$lat&z=14&l=map&size=600,300&pt=$lng,$lat,pm2rdm'
        : null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: [
                const Icon(PhosphorIconsFill.mapPin, color: _kOrange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reservation.buyerName,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _kDark,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: _kGrey),
                ),
              ],
            ),
          ),

          // Address
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(PhosphorIconsRegular.mapPin,
                    size: 14, color: _kGrey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(
                        fontSize: 13, color: _kGrey, height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: _kBorder),

          // Map preview area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _kBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Static map image via OpenStreetMap tile
                  if (lat != null && lng != null)
                    Positioned.fill(
                      child: Image.network(
                        staticMapUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(color: _kDark),
                          );
                        },
                        errorBuilder: (_, __, ___) =>
                            _MapFallback(lat: lat, lng: lng),
                      ),
                    )
                  else
                    _MapFallback(lat: lat, lng: lng),

                  // Coordinate overlay
                  if (lat != null && lng != null)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Open in Google Maps button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = Uri.parse(mapsUrl);
                  try {
                    if (!await launchUrl(url,
                        mode: LaunchMode.externalApplication)) {
                      await launchUrl(url, mode: LaunchMode.platformDefault);
                    }
                  } catch (e) {
                    debugPrint('Could not launch Google Maps: $e');
                    await launchUrl(url, mode: LaunchMode.platformDefault);
                  }
                },
                icon: const Icon(PhosphorIconsFill.navigationArrow, size: 18),
                label: const Text('Open in Google Maps'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Map Fallback Widget ──────────────────────────────────────────────────────

class _MapFallback extends StatelessWidget {
  final double? lat;
  final double? lng;

  const _MapFallback({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _kDark.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(PhosphorIconsFill.mapPin, color: _kDark, size: 36),
          ),
          const SizedBox(height: 12),
          if (lat != null && lng != null)
            Text(
              '${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kDark,
              ),
            )
          else
            const Text(
              'No coordinates available',
              style: TextStyle(fontSize: 13, color: _kGrey),
            ),
          const SizedBox(height: 4),
          const Text(
            'Tap "Open in Google Maps" to navigate',
            style: TextStyle(fontSize: 12, color: _kGrey),
          ),
        ],
      ),
    );
  }
}

// ─── Fulfillment Button ───────────────────────────────────────────────────────

class _FulfillmentButton extends ConsumerWidget {
  final FarmerPreorderCampaign campaign;

  const _FulfillmentButton({required this.campaign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Start Fulfillment?'),
              content: const Text(
                'This will convert all paid reservations into Orders in your Order Tracking screen.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Confirm', style: TextStyle(color: _kDark)),
                ),
              ],
            ),
          );
          if (confirm == true) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Starting fulfillment...')),
            );
            final success = await ref
                .read(preOrderControllerProvider.notifier)
                .fulfillCampaign(campaign.id);
            if (!context.mounted) return;
            if (success) {
              ref.read(farmerCampaignsControllerProvider.notifier).refresh();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fulfillment started! Check your Orders.'),
                  backgroundColor: _kDark,
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
        icon: const Icon(PhosphorIconsFill.truck, size: 18),
        label: const Text('Start Fulfillment'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _kDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: _kGrey),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.$1,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: colors.$2,
        ),
      ),
    );
  }

  (Color, Color) _statusColor(String s) {
    switch (s.toUpperCase()) {
      case 'ACTIVE':
        return (const Color(0xFFE8F5E9), const Color(0xFF2E7D32));
      case 'FULLY_BOOKED':
        return (const Color(0xFFE3F2FD), const Color(0xFF1565C0));
      case 'COMPLETED':
        return (_kDark.withValues(alpha: 0.1), _kDark);
      case 'CANCELLED':
        return (const Color(0xFFFFEBEE), Colors.red);
      case 'HARVESTING':
      case 'READY':
        return (const Color(0xFFFFF3E0), _kOrange);
      default:
        return (_kBorder, _kGrey);
    }
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status.toUpperCase()) {
      case 'PAID':
      case 'CONFIRMED':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'PENDING_PAYMENT':
        bg = const Color(0xFFFFF3E0);
        fg = _kOrange;
        break;
      case 'CANCELLED':
        bg = const Color(0xFFFFEBEE);
        fg = Colors.red;
        break;
      default:
        bg = _kBorder;
        fg = _kGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
