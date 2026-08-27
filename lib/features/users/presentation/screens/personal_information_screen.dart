import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'dart:io';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/profile_controller.dart';
import '../../../system/presentation/providers/utility_providers.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class PersonalInformationScreen extends ConsumerStatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  ConsumerState<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends ConsumerState<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  bool _isLoading = false;
  bool _isEditing = false;
  bool _isUploadingPicture = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(profileControllerProvider).when(
          initial: () => const Scaffold(backgroundColor: kBgColor),
          loading: () => const Scaffold(
            backgroundColor: kBgColor,
            body: Center(child: CircularProgressIndicator(color: kDarkGreen)),
          ),
          error: (e) => Scaffold(
            backgroundColor: kBgColor,
            body: Center(child: Text(e.toString(), style: TextStyle())),
          ),
          data: (profile) {
            if (!_isEditing) {
              _nameController.text = profile.name;
              _emailController.text = profile.email;
              _phoneController.text = profile.phoneNumber ?? '';
              _bioController.text = profile.bio ?? '';
            }

            return WebConstrainedBox(
              maxWidth: 600,
              child: Scaffold(
                backgroundColor: kBgColor,
                appBar: AppBar(
                  backgroundColor: kBgColor,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
                        color: kDarkGreen),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: kDarkGreen,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                  ),
                  actions: [
                    if (!_isEditing)
                      TextButton(
                        onPressed: () {
                          setState(() => _isEditing = true);
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: kDarkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Profile Picture Section
                        Center(
                          child: GestureDetector(
                            onTap: (!_isEditing ||
                                    _isLoading ||
                                    _isUploadingPicture)
                                ? null
                                : _changeProfilePicture,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: kPillGrey,
                                        border: Border.all(
                                            color: Colors.white, width: 4),
                                        image: profile.avatarUrl != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    profile.avatarUrl!),
                                                fit: BoxFit.cover,
                                                colorFilter: _isEditing
                                                    ? null
                                                    : const ColorFilter.mode(
                                                        Colors.grey,
                                                        BlendMode.saturation),
                                              )
                                            : null,
                                        boxShadow: [
                                          BoxShadow(
                                            color: kDarkGreen.withValues(
                                                alpha: 0.1),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: profile.avatarUrl == null
                                          ? const PhosphorIcon(
                                              PhosphorIconsRegular.user,
                                              size: 60,
                                              color: kTextGrey)
                                          : null,
                                    ),
                                    if (_isEditing)
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: kDarkGreen,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                        child: const PhosphorIcon(
                                            PhosphorIconsRegular.camera,
                                            size: 18,
                                            color: Colors.white),
                                      ),
                                  ],
                                ),
                                if (_isUploadingPicture)
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.black.withValues(alpha: 0.5),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        if (_isEditing) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: (_isLoading || _isUploadingPicture)
                                ? null
                                : _changeProfilePicture,
                            child: Text(
                              'Change Profile Picture',
                              style: TextStyle(
                                color: kDarkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Form Fields
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: PhosphorIconsRegular.user,
                          enabled: _isEditing,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: PhosphorIconsRegular.envelope,
                          enabled: false, // Email cannot be edited here
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: PhosphorIconsRegular.phone,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),

                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: _bioController,
                          label: 'Bio',
                          icon: PhosphorIconsRegular.info,
                          enabled: _isEditing,
                          maxLines: 3,
                        ),

                        const SizedBox(height: 12),

                        // Account Info Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kDarkGreen.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: kDarkGreen.withOpacity(0.1)),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Member Since',
                                _formatDate(profile.createdAt),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Last Updated',
                                _formatDate(profile.updatedAt),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Save/Cancel Buttons
                        if (_isEditing)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          setState(() => _isEditing = false);
                                        },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: kTextGrey,
                                    side: BorderSide(color: kPillGrey),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kDarkGreen,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
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
          },
        );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        color: enabled ? kDarkGreen : kTextGrey,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: kTextGrey),
        prefixIcon: PhosphorIcon(icon, color: kTextGrey),
        filled: true,
        fillColor: enabled ? Colors.white : kPillGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPillGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPillGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kDarkGreen, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kPillGrey),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: kTextGrey,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: kDarkGreen,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profileController = ref.read(profileControllerProvider.notifier);
      await profileController.updateUserProfile(
        name: _nameController.text,
        phoneNumber:
            _phoneController.text.isEmpty ? null : _phoneController.text,
        bio: _bioController.text.isEmpty ? null : _bioController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully',
              style: TextStyle(),
            ),
            backgroundColor: kDarkGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update profile',
              style: TextStyle(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    if (!mounted) return;

    setState(() => _isUploadingPicture = true);

    try {
      final uploadFileUseCase = ref.read(uploadFileUseCaseProvider);
      final result = await uploadFileUseCase(File(pickedFile.path));

      await result.fold(
        (failure) async {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message, style: TextStyle()),
              backgroundColor: Colors.red,
            ),
          );
        },
        (uploadedFile) async {
          final profileController =
              ref.read(profileControllerProvider.notifier);
          await profileController.updateProfileImage(uploadedFile.url);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile picture updated successfully',
                  style: TextStyle()),
              backgroundColor: kDarkGreen,
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to update profile picture', style: TextStyle()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingPicture = false);
    }
  }
}
