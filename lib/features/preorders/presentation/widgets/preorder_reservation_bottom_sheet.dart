import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/features/users/presentation/providers/address_controller.dart';
import 'package:harvest_app/features/users/presentation/screens/add_edit_address_screen.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PreorderReservationBottomSheet extends ConsumerStatefulWidget {
  final PreorderCampaign campaign;

  const PreorderReservationBottomSheet({
    super.key,
    required this.campaign,
  });

  @override
  ConsumerState<PreorderReservationBottomSheet> createState() =>
      _PreorderReservationBottomSheetState();
}

class _PreorderReservationBottomSheetState
    extends ConsumerState<PreorderReservationBottomSheet> {
  late int _quantity;
  String _deliveryMethod = 'delivery';
  String? _selectedAddressId;
  bool _isLoading = false;

  final formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _quantity = widget.campaign.minimumOrder ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final double price = widget.campaign.price ?? 0;
    final int remaining =
        (widget.campaign.targetQuantity - widget.campaign.currentReservations)
            .clamp(0, 99999);
    final addressState = ref.watch(addressControllerProvider);
    final int minOrder = widget.campaign.minimumOrder ?? 1;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reserve ${widget.campaign.productName}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              IconButton(
                icon: const PhosphorIcon(PhosphorIconsRegular.x),
                onPressed: () => context.pop(),
              )
            ],
          ),
          if (minOrder > 1) ...[
            const SizedBox(height: 4),
            Text(
              'Minimum order is $minOrder ${widget.campaign.unit ?? 'kg'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
          const SizedBox(height: 16),
          // Quantity selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quantity (${widget.campaign.unit ?? 'kg'})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > minOrder
                        ? () {
                            setState(() {
                              _quantity--;
                            });
                          }
                        : null,
                    icon: const PhosphorIcon(PhosphorIconsRegular.minusCircle),
                  ),
                  Text(
                    '$_quantity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    onPressed: _quantity < remaining
                        ? () {
                            setState(() {
                              _quantity++;
                            });
                          }
                        : null,
                    icon: const PhosphorIcon(PhosphorIconsRegular.plusCircle),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          // Delivery Method
          Text(
            'Delivery Method',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Delivery'),
                  value: 'delivery',
                  groupValue: _deliveryMethod,
                  onChanged: (val) => setState(() {
                    _deliveryMethod = val!;
                  }),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Pickup'),
                  value: 'pickup',
                  groupValue: _deliveryMethod,
                  onChanged: (val) => setState(() {
                    _deliveryMethod = val!;
                  }),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          if (_deliveryMethod == 'delivery') ...[
            const SizedBox(height: 16),
            Text(
              'Select Address',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            addressState.when(
              initial: () => const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err) => Text('Error loading addresses: $err'),
              data: (addresses) {
                if (addresses.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          'No addresses found. Please add a delivery address.'),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AddEditAddressScreen(),
                            ),
                          );
                        },
                        icon: const PhosphorIcon(PhosphorIconsRegular.plus,
                            size: 18),
                        label: const Text('Add Address'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (_selectedAddressId == null) {
                  // auto-select primary or first
                  final primary = addresses.firstWhere((a) => a.isPrimary,
                      orElse: () => addresses.first);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      _selectedAddressId = primary.addressId;
                    });
                  });
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedAddressId,
                      isExpanded: true,
                      items: addresses.map((addr) {
                        return DropdownMenuItem(
                          value: addr.addressId,
                          child: Text(
                            addr.fullAddress ?? addr.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() {
                        _selectedAddressId = val;
                      }),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AddEditAddressScreen(),
                            ),
                          );
                        },
                        icon: const PhosphorIcon(PhosphorIconsRegular.plus,
                            size: 16),
                        label: const Text('Add New Address'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                formatter.format(price * _quantity).replaceAll(',00', ''),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitReservation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Confirm Reservation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReservation() async {
    if (_deliveryMethod == 'delivery' && _selectedAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final usecase = ref.read(reservePreOrderUseCaseProvider);
      final result = await usecase.call(
        harvestId: widget.campaign.id,
        quantity: _quantity,
        deliveryMethod: _deliveryMethod,
        addressId: _selectedAddressId,
      );

      setState(() {
        _isLoading = false;
      });

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (success) {
          // refresh details and lists
          ref.invalidate(preorderDetailProvider(widget.campaign.id));
          ref.invalidate(myReservationsProvider);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reservation successful!')),
          );
          if (context.canPop()) {
            context.pop();
          }
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reserve: $e')),
      );
    }
  }
}
