import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/presentation/shared_widgets/image_picker_bottom_sheet.dart';
import '../providers/farmer_settings_controller.dart';
import '../providers/edit_farm_profile_controller.dart';
import 'package:harvest_app/domain/entities/farm_profile_request.dart';
import 'package:harvest_app/domain/entities/farmer_profile.dart';

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
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  
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
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(farmerSettingsControllerProvider);
      state.maybeWhen(
        data: (profile, _) {
          setState(() {
            _currentProfile = profile;
            _nameController.text = profile.name;
            _descriptionController.text = profile.description;
            _addressController.text = profile.address;
            _cityController.text = profile.city ?? '';
            _stateController.text = profile.state ?? '';
            _phoneController.text = profile.phoneNumber ?? '';
            _specialtiesController.text = profile.specialties.join(', ');
            _latitudeController.text = profile.latitude.toString();
            _longitudeController.text = profile.longitude.toString();
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
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = FarmProfileRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
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
        latitude: double.tryParse(_latitudeController.text.trim()) ?? (_currentProfile?.latitude ?? 0.0),
        longitude: double.tryParse(_longitudeController.text.trim()) ?? (_currentProfile?.longitude ?? 0.0),
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
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _latitudeController,
                      label: 'Latitude',
                      icon: PhosphorIconsRegular.mapPin,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _longitudeController,
                      label: 'Longitude',
                      icon: PhosphorIconsRegular.mapPin,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      icon: PhosphorIconsRegular.buildings,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _stateController,
                      label: 'State',
                      icon: PhosphorIconsRegular.mapTrifold,
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
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: kDarkGreen,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon:
                maxLines == 1 ? PhosphorIcon(icon, color: kTextGrey) : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              borderSide: const BorderSide(color: Colors.red),
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
                      image: _coverImagePath!.startsWith('http')
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
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kPillGrey,
                  shape: BoxShape.circle,
                  image: _profileImagePath != null
                      ? DecorationImage(
                          image: _profileImagePath!.startsWith('http')
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
}
