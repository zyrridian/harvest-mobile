import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../domain/entities/address.dart';
import '../../../providers/address_providers.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
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
  int _provinceId = 31;
  int _cityId = 3171;
  int _districtId = 317101;
  double _latitude = -6.1944;
  double _longitude = 106.8229;

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
        );

        result.fold(
          (failure) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${failure.toString()}')),
              );
            }
          },
          (address) {
            ref.invalidate(addressesProvider);
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
        );

        result.fold(
          (failure) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${failure.toString()}')),
              );
            }
          },
          (address) {
            ref.invalidate(addressesProvider);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? 'Edit Address' : 'Add New Address',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
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
              icon: Icons.label_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Label is required' : null,
            ),
            const SizedBox(height: 20),

            // Contact Info Section
            Text('Contact Info',
                style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen)),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _recipientNameController,
              label: 'Recipient Name',
              hint: 'Full name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Recipient name is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+62 812-xxxx-xxxx',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Phone number is required' : null,
            ),
            const SizedBox(height: 24),

            // Location Section
            Text('Location Details',
                style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen)),
            const SizedBox(height: 12),

            // Pin Map Button
            OutlinedButton.icon(
              onPressed: _showLocationPicker,
              icon: const Icon(Icons.map_outlined, color: kDarkGreen),
              label: Text('Pin Location on Map',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: kDarkGreen,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: kDarkGreen),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _fullAddressController,
              label: 'Street Address',
              hint: 'House number, street name',
              icon: Icons.home_outlined,
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
              icon: Icons.note_alt_outlined,
              maxLines: 4,
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
                        style: GoogleFonts.dmSans(
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
          style: GoogleFonts.dmSans(
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
          style: GoogleFonts.dmSans(
              color: kDarkGreen, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.dmSans(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            prefixIcon:
                icon != null ? Icon(icon, color: kTextGrey, size: 20) : null,
            suffixIcon: readOnly
                ? const Icon(Icons.arrow_drop_down, color: kTextGrey)
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

  void _showProvinceSelector() {
    _showSelectionSheet('Select Province', [
      _SelectionItem('DKI Jakarta', 31),
      _SelectionItem('Jawa Barat', 32),
      _SelectionItem('Jawa Timur', 35),
    ], (item) {
      _provinceController.text = item.label;
      _provinceId = item.id;
    });
  }

  void _showCitySelector() {
    _showSelectionSheet('Select City', [
      _SelectionItem('Jakarta Pusat', 3171),
      _SelectionItem('Jakarta Selatan', 3174),
      _SelectionItem('Jakarta Barat', 3173),
    ], (item) {
      _cityController.text = item.label;
      _cityId = item.id;
    });
  }

  void _showDistrictSelector() {
    _showSelectionSheet('Select District', [
      _SelectionItem('Menteng', 317101),
      _SelectionItem('Tanah Abang', 317102),
      _SelectionItem('Gambir', 317103),
    ], (item) {
      _districtController.text = item.label;
      _districtId = item.id;
    });
  }

  void _showSelectionSheet(String title, List<_SelectionItem> items,
      Function(_SelectionItem) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkGreen)),
            const SizedBox(height: 16),
            ...items.map((item) => ListTile(
                  title: Text(item.label,
                      style: GoogleFonts.dmSans(color: kDarkGreen)),
                  onTap: () {
                    onSelect(item);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showLocationPicker() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Map picker would open here', style: GoogleFonts.dmSans()),
        backgroundColor: kDarkGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _SelectionItem {
  final String label;
  final int id;
  _SelectionItem(this.label, this.id);
}
