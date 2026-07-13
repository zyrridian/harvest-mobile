import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:harvest_app/domain/entities/address.dart';
import 'package:harvest_app/features/system/presentation/providers/master_provider.dart';
import '../providers/address_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_picker_screen.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kCream = Color(0xFFF0EAD6);
const kAccentOrange = kDarkGreen;
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class AddEditAddressScreen extends ConsumerStatefulWidget {
  final Address? address; // null for add, non-null for edit

  const AddEditAddressScreen({super.key, this.address});

  @override
  ConsumerState<AddEditAddressScreen> createState() =>
      _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Form controllers
  late TextEditingController _labelController;
  late TextEditingController _recipientNameController;
  late TextEditingController _phoneController;
  late TextEditingController _fullAddressController;
  late TextEditingController _provinceController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _subdistrictController;
  late TextEditingController _postalCodeController;
  late TextEditingController _notesController;

  // Simulated location data
  int _provinceId = 0;
  int _cityId = 0;
  int _districtId = 0;
  double _latitude = -6.1944;
  double _longitude = 106.8229;
  bool _isPrimary = false;

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    _labelController = TextEditingController(text: addr?.label ?? '');
    _recipientNameController =
        TextEditingController(text: addr?.recipientName ?? '');
    _phoneController = TextEditingController(text: addr?.phone ?? '');
    _fullAddressController =
        TextEditingController(text: addr?.fullAddress ?? '');
    _provinceController = TextEditingController(text: addr?.province ?? '');
    _cityController = TextEditingController(text: addr?.city ?? '');
    _districtController = TextEditingController(text: addr?.district ?? '');
    _subdistrictController =
        TextEditingController(text: addr?.subdistrict ?? '');
    _postalCodeController = TextEditingController(text: addr?.postalCode ?? '');
    _notesController = TextEditingController(text: addr?.notes ?? '');

    if (addr != null) {
      _provinceId = addr.provinceId;
      _cityId = addr.cityId;
      _districtId = addr.districtId;
      _latitude = addr.latitude;
      _longitude = addr.longitude;
      _isPrimary = addr.isPrimary;
    }
  }

  @override
  void dispose() {
    _labelController.dispose();
    _recipientNameController.dispose();
    _phoneController.dispose();
    _fullAddressController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _subdistrictController.dispose();
    _postalCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.address == null) {
        // Add new address
        final useCase = ref.read(addAddressUseCaseProvider);
        final result = await useCase(
          label: _labelController.text,
          recipientName: _recipientNameController.text,
          phone: _phoneController.text,
          fullAddress: _fullAddressController.text,
          province: _provinceController.text,
          provinceId: _provinceId,
          city: _cityController.text,
          cityId: _cityId,
          district: _districtController.text,
          districtId: _districtId,
          subdistrict: _subdistrictController.text.isEmpty
              ? null
              : _subdistrictController.text,
          postalCode: _postalCodeController.text,
          latitude: _latitude,
          longitude: _longitude,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          isPrimary: _isPrimary,
        );

        await result.fold(
          (failure) async {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${failure.toString()}')),
              );
            }
          },
          (address) async {
            await ref.read(addressControllerProvider.notifier).refresh();
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address added successfully')),
              );
            }
          },
        );
      } else {
        // Update existing address
        final useCase = ref.read(updateAddressUseCaseProvider);
        final result = await useCase(
          addressId: widget.address!.addressId,
          label: _labelController.text,
          recipientName: _recipientNameController.text,
          phone: _phoneController.text,
          fullAddress: _fullAddressController.text,
          province: _provinceController.text,
          provinceId: _provinceId,
          city: _cityController.text,
          cityId: _cityId,
          district: _districtController.text,
          districtId: _districtId,
          subdistrict: _subdistrictController.text.isEmpty
              ? null
              : _subdistrictController.text,
          postalCode: _postalCodeController.text,
          latitude: _latitude,
          longitude: _longitude,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          isPrimary: _isPrimary,
        );

        await result.fold(
          (failure) async {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${failure.toString()}')),
              );
            }
          },
          (address) async {
            await ref.read(addressControllerProvider.notifier).refresh();
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address updated successfully')),
              );
            }
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
              color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Address' : 'Add New Address',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Label
            _buildTextField(
              controller: _labelController,
              label: 'Address Label',
              hint: 'e.g. Home, Office',
              icon: PhosphorIconsRegular.tag,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Label is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _recipientNameController,
              label: 'Recipient Name',
              hint: 'Full name',
              icon: PhosphorIconsRegular.user,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Recipient name is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+62 812-xxxx-xxxx',
              icon: PhosphorIconsRegular.phone,
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Phone number is required' : null,
            ),
            const SizedBox(height: 12),
            // Map Preview
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPillGrey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    GoogleMap(
                      key: ValueKey('$_latitude-$_longitude'),
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_latitude, _longitude),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('preview'),
                          position: LatLng(_latitude, _longitude),
                        ),
                      },
                      zoomControlsEnabled: false,
                      scrollGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _showLocationPicker,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          // boxShadow: const [
                          //   BoxShadow(
                          //     color: Colors.black12,
                          //     blurRadius: 4,
                          //   ),
                          // ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const PhosphorIcon(
                                PhosphorIconsRegular.pencilSimple,
                                size: 16,
                                color: kDarkGreen),
                            const SizedBox(width: 4),
                            Text(
                              'Change',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _fullAddressController,
              label: 'Street Address',
              hint: 'House number, street name',
              icon: PhosphorIconsRegular.house,
              maxLines: 4,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Street address is required' : null,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _provinceController,
                    label: 'Province',
                    hint: 'Select',
                    readOnly: true,
                    onTap: _showProvinceSelector,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    hint: 'Select',
                    readOnly: true,
                    onTap: _showCitySelector,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _districtController,
                    label: 'District',
                    hint: 'Select',
                    readOnly: true,
                    onTap: _showDistrictSelector,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _postalCodeController,
                    label: 'Zip Code',
                    hint: '12345',
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _notesController,
              label: 'Notes (Optional)',
              hint: 'Gate code, landmark, etc.',
              icon: PhosphorIconsRegular.note,
              maxLines: 4,
            ),

            SwitchListTile(
              title: Text('Set as primary address',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kDarkGreen)),
              value: _isPrimary,
              onChanged: (val) => setState(() => _isPrimary = val),
              activeColor: kAccentOrange,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(
                        isEdit ? 'Update Address' : 'Save Address',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kTextGrey,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(color: kDarkGreen, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: icon != null
                ? PhosphorIcon(icon, color: kTextGrey, size: 20)
                : null,
            suffixIcon: readOnly
                ? const PhosphorIcon(PhosphorIconsRegular.caretDown,
                    color: kTextGrey)
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPillGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPillGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kDarkGreen),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  // --- Mock Selectors (Keep existing logic, just update styling if needed) ---

  Future<void> _showProvinceSelector() async {
    try {
      final items = await ref.read(provincesProvider.future);
      if (!mounted) return;
      _showSelectionSheet(
        'Select Province',
        items.map((p) => _SelectionItem(p.name, p.id)).toList(),
        (item) {
          setState(() {
            _provinceController.text = item.label;
            _provinceId = item.id;
            _cityController.clear();
            _cityId = 0;
            _districtController.clear();
            _districtId = 0;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading provinces: $e')));
      }
    }
  }

  Future<void> _showCitySelector() async {
    if (_provinceId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a province first')));
      return;
    }
    try {
      final items = await ref.read(citiesProvider(_provinceId).future);
      if (!mounted) return;
      _showSelectionSheet(
        'Select City',
        items.map((c) => _SelectionItem(c.name, c.id)).toList(),
        (item) {
          setState(() {
            _cityController.text = item.label;
            _cityId = item.id;
            _districtController.clear();
            _districtId = 0;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error loading cities: $e')));
      }
    }
  }

  Future<void> _showDistrictSelector() async {
    if (_cityId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a city first')));
      return;
    }
    try {
      final items = await ref.read(districtsProvider(_cityId).future);
      if (!mounted) return;
      _showSelectionSheet(
        'Select District',
        items.map((d) => _SelectionItem(d.name, d.id)).toList(),
        (item) {
          setState(() {
            _districtController.text = item.label;
            _districtId = item.id;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading districts: $e')));
      }
    }
  }

  void _showSelectionSheet(String title, List<_SelectionItem> items,
      Function(_SelectionItem) onSelect) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title:
                        Text(item.label, style: TextStyle(color: kDarkGreen)),
                    onTap: () {
                      onSelect(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLocationPicker() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(
          initialLocation: LatLng(_latitude, _longitude),
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated successfully')),
      );
    }
  }
}

class _SelectionItem {
  final String label;
  final int id;
  _SelectionItem(this.label, this.id);
}
