import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/farmers/domain/entities/farm_profile_request.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_profile.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/edit_farm_profile_controller.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/farmer_settings_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest_app/features/users/presentation/screens/map_picker_screen.dart';
import 'package:harvest_app/features/system/presentation/providers/master_provider.dart';
import 'package:harvest_app/core/widgets/image_picker_bottom_sheet.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class EditFarmProfileScreen extends ConsumerStatefulWidget {
  const EditFarmProfileScreen({super.key});

  @override
  ConsumerState<EditFarmProfileScreen> createState() =>
      _EditFarmProfileScreenState();
}

class _EditFarmProfileScreenState extends ConsumerState<EditFarmProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _phoneController;
  late TextEditingController _specialtiesController;

  double _latitude = 0.0;
  double _longitude = 0.0;
  int _provinceId = 0;

  String? _profileImagePath;
  String? _coverImagePath;

  FarmerProfile? _currentProfile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _phoneController = TextEditingController();
    _specialtiesController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(farmerSettingsControllerProvider);
      state.maybeWhen(
        data: (profile, _) {
          setState(() {
            _currentProfile = profile;
            _nameController.text = profile.name;
            _descriptionController.text = profile.description ?? '';
            _addressController.text = profile.address ?? '';
            _cityController.text = profile.city ?? '';
            _stateController.text = profile.state ?? '';
            _phoneController.text = profile.phoneNumber ?? '';
            _specialtiesController.text = profile.specialties.join(', ');
            _latitude = profile.latitude ?? 0.0;
            _longitude = profile.longitude ?? 0.0;
            _profileImagePath = profile.profileImage;
            _coverImagePath = profile.coverImage;
          });
        },
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _phoneController.dispose();
    _specialtiesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = FarmProfileRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        profileImage: _profileImagePath,
        coverImage: _coverImagePath,
        address: _addressController.text.trim(),
        city: _cityController.text.trim().isNotEmpty
            ? _cityController.text.trim()
            : null,
        state: _stateController.text.trim().isNotEmpty
            ? _stateController.text.trim()
            : null,
        phoneNumber: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        latitude: _latitude,
        longitude: _longitude,
        specialties: _specialtiesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      );

      ref
          .read(editFarmProfileControllerProvider.notifier)
          .updateProfile(request)
          .then((_) {
        final state = ref.read(editFarmProfileControllerProvider);
        if (!state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.toString())),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(editFarmProfileControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => context.pop(),
        ),
        iconTheme: const IconThemeData(color: kDarkGreen),
        title: Text(
          'Edit Farm Profile',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kDarkGreen,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePickers(),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Farm Name',
                icon: PhosphorIconsRegular.farm,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: PhosphorIconsRegular.textAa,
                maxLines: 3,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: PhosphorIconsRegular.mapPin,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
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
                        liteModeEnabled: true, // Fixes freezing on Android emulators for static maps
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
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const PhosphorIcon(
                                  PhosphorIconsRegular.pencilSimple,
                                  size: 16,
                                  color: kDarkGreen),
                              const SizedBox(width: 4),
                              const Text(
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
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _stateController,
                      label: 'State/Province',
                      icon: PhosphorIconsRegular.mapTrifold,
                      readOnly: true,
                      onTap: _showProvinceSelector,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      icon: PhosphorIconsRegular.buildings,
                      readOnly: true,
                      onTap: _showCitySelector,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: PhosphorIconsRegular.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _specialtiesController,
                label: 'Specialties (comma separated)',
                icon: PhosphorIconsRegular.tag,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: editState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: editState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(
            fontSize: 15,
            color: kDarkGreen,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: kPillGrey,
            prefixIcon: icon != null
                ? PhosphorIcon(icon, color: kTextGrey, size: 22)
                : null,
            suffixIcon: readOnly
                ? const PhosphorIcon(PhosphorIconsRegular.caretDown,
                    color: kTextGrey, size: 20)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kDarkGreen, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cover Image',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            ImagePickerBottomSheet.show(context, onImagePicked: (path) {
              setState(() => _coverImagePath = path);
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: kPillGrey,
              borderRadius: BorderRadius.circular(12),
              image: _coverImagePath != null
                  ? DecorationImage(
                      image: (_coverImagePath!.startsWith('http') || _coverImagePath!.startsWith('blob:'))
                          ? NetworkImage(_coverImagePath!)
                          : FileImage(File(_coverImagePath!)) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _coverImagePath == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PhosphorIcon(PhosphorIconsRegular.image,
                          color: kTextGrey, size: 32),
                      const SizedBox(height: 8),
                      const Text('Tap to upload cover image',
                          style: TextStyle(color: kTextGrey, fontSize: 13)),
                    ],
                  )
                : null,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Profile Image',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  ImagePickerBottomSheet.show(context, onImagePicked: (path) {
                    setState(() => _profileImagePath = path);
                  });
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: kPillGrey,
                    shape: BoxShape.circle,
                    image: _profileImagePath != null
                        ? DecorationImage(
                            image: (_profileImagePath!.startsWith('http') || _profileImagePath!.startsWith('blob:'))
                                ? NetworkImage(_profileImagePath!)
                                : FileImage(File(_profileImagePath!))
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _profileImagePath == null
                      ? const Center(
                          child: PhosphorIcon(PhosphorIconsRegular.user,
                              color: kTextGrey, size: 40),
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    ImagePickerBottomSheet.show(context, onImagePicked: (path) {
                      setState(() => _profileImagePath = path);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kDarkGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const PhosphorIcon(PhosphorIconsRegular.camera,
                        color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

  Future<void> _showProvinceSelector() async {
    try {
      final items = await ref.read(provincesProvider.future);
      if (!mounted) return;
      _showSelectionSheet(
        'Select State',
        items.map((p) => _SelectionItem(p.name, p.id)).toList(),
        (item) {
          setState(() {
            _stateController.text = item.label;
            _provinceId = item.id;
            _cityController.clear();
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error loading states: $e')));
      }
    }
  }

  Future<void> _showCitySelector() async {
    if (_provinceId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a state first')));
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
                style: const TextStyle(
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
                    title: Text(item.label,
                        style: const TextStyle(color: kDarkGreen)),
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
}

class _SelectionItem {
  final String label;
  final int id;
  _SelectionItem(this.label, this.id);
}
