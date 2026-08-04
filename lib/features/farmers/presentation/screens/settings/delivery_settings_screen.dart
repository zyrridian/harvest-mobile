import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/delivery_settings_controller.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/farmer_settings_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/features/farmers/domain/entities/delivery_settings.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class DeliverySettingsScreen extends ConsumerStatefulWidget {
  const DeliverySettingsScreen({super.key});

  @override
  ConsumerState<DeliverySettingsScreen> createState() =>
      _DeliverySettingsScreenState();
}

class _DeliverySettingsScreenState
    extends ConsumerState<DeliverySettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _farmerDeliveryEnabled = false;
  bool _cashOnDeliveryEnabled = false;
  late TextEditingController _baseFeeController;
  late TextEditingController _perKmRateController;
  late TextEditingController _maxRadiusKmController;
  late TextEditingController _minOrderForFreeController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _baseFeeController = TextEditingController();
    _perKmRateController = TextEditingController();
    _maxRadiusKmController = TextEditingController();
    _minOrderForFreeController = TextEditingController();
    _notesController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(farmerSettingsControllerProvider);
      state.maybeWhen(
        data: (_, settings) {
          setState(() {
            _farmerDeliveryEnabled = settings.farmerDeliveryEnabled;
            _cashOnDeliveryEnabled = settings.cashOnDeliveryEnabled;
            _baseFeeController.text = settings.baseFee.toStringAsFixed(0);
            _perKmRateController.text = settings.perKmRate.toStringAsFixed(0);
            _maxRadiusKmController.text =
                settings.maxRadiusKm.toStringAsFixed(0);
            _minOrderForFreeController.text =
                settings.minOrderForFree.toStringAsFixed(0);
            _notesController.text = settings.notes ?? '';
          });
        },
        orElse: () {},
      );
    });
  }

  @override
  void dispose() {
    _baseFeeController.dispose();
    _perKmRateController.dispose();
    _maxRadiusKmController.dispose();
    _minOrderForFreeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newSettings = DeliverySettings(
        farmerDeliveryEnabled: _farmerDeliveryEnabled,
        baseFee: double.tryParse(_baseFeeController.text.trim()) ?? 0,
        perKmRate: double.tryParse(_perKmRateController.text.trim()) ?? 0,
        maxRadiusKm: double.tryParse(_maxRadiusKmController.text.trim()) ?? 0,
        minOrderForFree:
            double.tryParse(_minOrderForFreeController.text.trim()) ?? 0,
        cashOnDeliveryEnabled: _cashOnDeliveryEnabled,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      ref
          .read(deliverySettingsControllerProvider.notifier)
          .updateSettings(newSettings)
          .then((_) {
        final state = ref.read(deliverySettingsControllerProvider);
        if (!state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Delivery settings updated')),
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
    final saveState = ref.watch(deliverySettingsControllerProvider);

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
          'Delivery Settings',
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
              _buildSwitchTile(
                title: 'Enable Farmer Delivery',
                subtitle: 'Allow customers to request delivery from your farm.',
                value: _farmerDeliveryEnabled,
                onChanged: (val) =>
                    setState(() => _farmerDeliveryEnabled = val),
              ),
              const SizedBox(height: 24),
              if (_farmerDeliveryEnabled) ...[
                Text(
                  'Pricing & Rules',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kDarkGreen),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _baseFeeController,
                  label: 'Base Delivery Fee',
                  icon: PhosphorIconsRegular.money,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _perKmRateController,
                  label: 'Rate per Km',
                  icon: PhosphorIconsRegular.car,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _maxRadiusKmController,
                  label: 'Max Delivery Radius (Km)',
                  icon: PhosphorIconsRegular.mapTrifold,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _minOrderForFreeController,
                  label: 'Min Order for Free Delivery (Optional)',
                  icon: PhosphorIconsRegular.gift,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                _buildSwitchTile(
                  title: 'Cash on Delivery (COD)',
                  subtitle: 'Accept cash payment upon delivery.',
                  value: _cashOnDeliveryEnabled,
                  onChanged: (val) =>
                      setState(() => _cashOnDeliveryEnabled = val),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _notesController,
                  label: 'Delivery Notes (Optional)',
                  icon: PhosphorIconsRegular.note,
                  maxLines: 3,
                  hint:
                      'e.g., Deliveries happen on Tuesday and Friday mornings.',
                ),
                const SizedBox(height: 32),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveState.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: saveState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          'Save Settings',
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
        border: Border.all(color: kPillGrey),
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
          style: TextStyle(fontSize: 12, color: kTextGrey),
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
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kTextGrey, fontSize: 13),
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
          ),
        ),
      ],
    );
  }
}
