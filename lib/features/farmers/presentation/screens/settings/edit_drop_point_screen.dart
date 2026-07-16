import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/drop_points_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/domain/entities/drop_point.dart';
import 'package:harvest_app/domain/entities/drop_point.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kBorderColor = Color(0xFFE5E7EB);

class EditDropPointScreen extends ConsumerStatefulWidget {
  final DropPoint? dropPoint;

  const EditDropPointScreen({super.key, this.dropPoint});

  @override
  ConsumerState<EditDropPointScreen> createState() => _EditDropPointScreenState();
}

class _EditDropPointScreenState extends ConsumerState<EditDropPointScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _whatWeSellController;
  late TextEditingController _addressController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _imageUrlController;
  late TextEditingController _tagsController;
  late TextEditingController _operatingHoursController;
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.dropPoint?.name ?? '');
    _descriptionController = TextEditingController(text: widget.dropPoint?.description ?? '');
    _whatWeSellController = TextEditingController(text: widget.dropPoint?.whatWeSell ?? '');
    _addressController = TextEditingController(text: widget.dropPoint?.address ?? '');
    _latitudeController = TextEditingController(text: widget.dropPoint?.latitude.toString() ?? '');
    _longitudeController = TextEditingController(text: widget.dropPoint?.longitude.toString() ?? '');
    _imageUrlController = TextEditingController(text: widget.dropPoint?.imageUrl ?? '');
    _tagsController = TextEditingController(text: widget.dropPoint?.tags.join(', ') ?? '');
    _operatingHoursController = TextEditingController(text: widget.dropPoint?.operatingHours ?? '');
    _isActive = widget.dropPoint?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _whatWeSellController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageUrlController.dispose();
    _tagsController.dispose();
    _operatingHoursController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final tagsList = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final newDropPoint = DropPoint(
        id: widget.dropPoint?.id ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        whatWeSell: _whatWeSellController.text.trim(),
        latitude: double.tryParse(_latitudeController.text.trim()) ?? 0.0,
        longitude: double.tryParse(_longitudeController.text.trim()) ?? 0.0,
        address: _addressController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        isActive: _isActive,
        tags: tagsList,
        operatingHours: _operatingHoursController.text.trim(),
      );

      bool success;
      if (widget.dropPoint == null) {
        success = await ref.read(dropPointsControllerProvider.notifier).createDropPoint(newDropPoint);
      } else {
        success = await ref.read(dropPointsControllerProvider.notifier).updateDropPoint(widget.dropPoint!.id, newDropPoint);
      }

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) context.pop();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save drop point')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.dropPoint != null;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Drop Point' : 'New Drop Point',
          style: TextStyle(color: kDarkGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkGreen),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwitchTile(
                title: 'Drop Point Active',
                subtitle: 'Customers can see and select this location.',
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: PhosphorIconsRegular.storefront,
                hint: 'e.g. Downtown Farmers Market',
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: PhosphorIconsRegular.textAa,
                maxLines: 3,
                hint: 'e.g. Find us near the west entrance.',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _whatWeSellController,
                label: 'What we sell here',
                icon: PhosphorIconsRegular.package,
                hint: 'e.g. Only vegetables and fruits',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Full Address',
                icon: PhosphorIconsRegular.mapPin,
                maxLines: 2,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _latitudeController,
                      label: 'Latitude',
                      icon: PhosphorIconsRegular.compass,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _longitudeController,
                      label: 'Longitude',
                      icon: PhosphorIconsRegular.compass,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _operatingHoursController,
                label: 'Operating Hours',
                icon: PhosphorIconsRegular.clock,
                hint: 'e.g. Sat & Sun: 8 AM - 12 PM',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tagsController,
                label: 'Tags (Comma separated)',
                icon: PhosphorIconsRegular.tag,
                hint: 'e.g. Organic, Weekend',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                icon: PhosphorIconsRegular.image,
                hint: 'https://...',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Save Drop Point',
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

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: kDarkGreen),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        value: value,
        activeColor: kAccentOrange,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? hint,
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
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.grey.shade500) : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryGreen),
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
}
