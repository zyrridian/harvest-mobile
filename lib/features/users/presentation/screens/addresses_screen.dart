import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/features/users/domain/entities/address.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../providers/address_controller.dart';
import 'add_edit_address_screen.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kCream = Color(0xFFF0EAD6);
const kAccentOrange = kDarkGreen;
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        titleSpacing: 0,
        title: Text(
          'My Addresses',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kDarkGreen,
                  shape: BoxShape.circle,
                ),
                child: const PhosphorIcon(PhosphorIconsRegular.plus, color: Colors.white, size: 20),
              ),
              onPressed: () => _showAddAddressDialog(context, ref),
              tooltip: 'Add address',
            ),
          ),
        ],
      ),
      body: addressState.maybeWhen(
        data: (addresses) => _buildAddressesList(context, ref, addresses),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error) => Center(child: Text('Error: $error')),
        orElse: () => const SizedBox(),
      ),
    );
  }

  Widget _buildAddressesList(
      BuildContext context, WidgetRef ref, List<Address> addresses) {
    if (addresses.isEmpty) {
      return RefreshIndicator(
        color: kDarkGreen,
        backgroundColor: Colors.white,
        onRefresh: () => ref.read(addressControllerProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: kCream,
                shape: BoxShape.circle,
              ),
              child: const PhosphorIcon(PhosphorIconsRegular.mapPinLine,
                  size: 48, color: kDarkGreen),
            ),
            const SizedBox(height: 16),
            Text(
              'No addresses saved',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a location to start ordering.',
              style: TextStyle(color: kTextGrey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddAddressDialog(context, ref),
              icon: const PhosphorIcon(PhosphorIconsRegular.plus),
              label: const Text('Add Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: kDarkGreen,
      backgroundColor: Colors.white,
      onRefresh: () => ref.read(addressControllerProvider.notifier).refresh(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        itemCount: addresses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final address = addresses[index];
          return _buildAddressCard(context, ref, address);
        },
      ),
    );
  }

  Widget _buildAddressCard(
      BuildContext context, WidgetRef ref, Address address) {
    return Container(
      decoration: BoxDecoration(
        color: address.isPrimary ? kCream.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: address.isPrimary ? kDarkGreen : kPillGrey,
          width: address.isPrimary ? 2.0 : 1.0,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: kDarkGreen.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showAddressOptions(context, ref, address),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: kPillGrey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        address.label.toUpperCase(),
                        style: TextStyle(
                          color: kDarkGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (address.isPrimary)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: kDarkGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const PhosphorIcon(PhosphorIconsFill.checkCircle,
                                color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            const Text(
                              'Primary',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    PhosphorIcon(PhosphorIconsRegular.dotsThree, color: kTextGrey),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PhosphorIcon(PhosphorIconsRegular.mapPin,
                        color: kAccentOrange, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.recipientName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: kDarkGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.phone,
                            style: TextStyle(
                                color: kTextGrey, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${address.fullAddress}\n${address.district}, ${address.city}, ${address.province} ${address.postalCode}',
                            style: TextStyle(
                                color: kDarkGreen, height: 1.4),
                          ),
                          if (address.notes != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kCream,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const PhosphorIcon(PhosphorIconsRegular.info,
                                      size: 16, color: kDarkGreen),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      address.notes!,
                                      style: TextStyle(
                                        color: kDarkGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  // ... (Keep _showAddressOptions, _showAddAddressDialog, _setPrimaryAddress, _deleteAddress logic)
  void _showAddressOptions(
    BuildContext context,
    WidgetRef ref,
    Address address,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            if (!address.isPrimary)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kDarkGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const PhosphorIcon(PhosphorIconsRegular.star, color: kDarkGreen),
                ),
                title: Text(
                  'Set as Primary',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _setPrimaryAddress(context, ref, address.addressId);
                },
              ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kDarkGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const PhosphorIcon(PhosphorIconsRegular.pencilSimple, color: kDarkGreen),
              ),
              title: Text(
                'Edit Address',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEditAddressScreen(address: address),
                  ),
                );
              },
            ),
            if (!address.isPrimary)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const PhosphorIcon(PhosphorIconsRegular.trash, color: Colors.red),
                ),
                title: Text(
                  'Delete Address',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _deleteAddress(context, ref, address.addressId);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditAddressScreen(),
      ),
    );
  }

  Future<void> _setPrimaryAddress(
    BuildContext context,
    WidgetRef ref,
    String addressId,
  ) async {
    final useCase = ref.read(setPrimaryAddressUseCaseProvider);
    final result = await useCase(addressId);

    if (!context.mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${failure.toString()}')),
        );
      },
      (_) {
        ref.read(addressControllerProvider.notifier).refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Primary address updated')),
        );
      },
    );
  }

  Future<void> _deleteAddress(
    BuildContext context,
    WidgetRef ref,
    String addressId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final useCase = ref.read(deleteAddressUseCaseProvider);
      final result = await useCase(addressId);

      if (!context.mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${failure.toString()}')),
          );
        },
        (_) {
          ref.read(addressControllerProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address deleted')),
          );
        },
      );
    }
  }
}
