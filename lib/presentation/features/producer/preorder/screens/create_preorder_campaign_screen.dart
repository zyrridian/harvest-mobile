import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/features/preorder/providers/preorder_controller.dart';
import 'package:harvest_app/presentation/features/producer/products/providers/farmer_campaigns_controller.dart';
import 'package:harvest_app/domain/entities/create_preorder_campaign_params.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Colors.white;
const kInputBg = Color(0xFFF5F5F5);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGrey = Color(0xFF6E7A75);

class CreatePreorderCampaignScreen extends ConsumerStatefulWidget {
  const CreatePreorderCampaignScreen({super.key});

  @override
  ConsumerState<CreatePreorderCampaignScreen> createState() =>
      _CreatePreorderCampaignScreenState();
}

class _CreatePreorderCampaignScreenState
    extends ConsumerState<CreatePreorderCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitController = TextEditingController();
  final _pricePerUnitController = TextEditingController();
  final _targetQuantityController = TextEditingController();
  final _minimumOrderQuantityController = TextEditingController();
  final _depositPercentageController = TextEditingController();

  DateTime? _estimatedHarvestDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    _pricePerUnitController.dispose();
    _targetQuantityController.dispose();
    _minimumOrderQuantityController.dispose();
    _depositPercentageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _estimatedHarvestDate != null) {
      final params = CreatePreorderCampaignParams(
        title: _titleController.text,
        description: _descriptionController.text,
        unit: _unitController.text,
        pricePerUnit: double.tryParse(_pricePerUnitController.text) ?? 0,
        targetQuantity: int.tryParse(_targetQuantityController.text) ?? 0,
        estimatedHarvestDate: _estimatedHarvestDate!,
        minimumOrderQuantity:
            int.tryParse(_minimumOrderQuantityController.text) ?? 1,
        depositPercentage: int.tryParse(_depositPercentageController.text) ?? 0,
        status: "ACTIVE",
      );

      // We will call the controller here
      final success = await ref
          .read(preOrderControllerProvider.notifier)
          .createCampaign(params);

      if (mounted) {
        if (success) {
          // Refresh the farmer campaigns list to show the new campaign
          ref.read(farmerCampaignsControllerProvider.notifier).refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Campaign created successfully!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to create campaign. Please try again.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all required fields and dates.')),
      );
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _estimatedHarvestDate = date;
      });
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: kDarkGreen,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false, int maxLines = 1, bool requiredField = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (requiredField && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kTextGrey.withValues(alpha: 0.5)),
        filled: true,
        fillColor: kInputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          borderSide: const BorderSide(color: kDarkGreen, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'New Pre Order Campaign',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kDarkGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ) ??
              TextStyle(
                color: kDarkGreen,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
        ),
        backgroundColor: kBgColor,
        foregroundColor: kDarkGreen,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Title'),
              _buildTextField(_titleController, 'e.g. Fresh Organic Tomatoes'),
              const SizedBox(height: 20),
              _buildLabel('Description'),
              _buildTextField(_descriptionController,
                  'e.g. Sweet and juicy tomatoes from our next harvest.',
                  maxLines: 3),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Unit'),
                        _buildTextField(_unitController, 'e.g. kg'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Price per Unit'),
                        _buildTextField(_pricePerUnitController, 'e.g. 25000',
                            isNumber: true),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Target Quantity'),
                        _buildTextField(_targetQuantityController, 'e.g. 100',
                            isNumber: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Min. Order Qty'),
                        _buildTextField(
                            _minimumOrderQuantityController, 'e.g. 1',
                            isNumber: true),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Deposit %'),
                        _buildTextField(_depositPercentageController, 'e.g. 50',
                            isNumber: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Estimated Harvest Date'),
                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: kInputBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _estimatedHarvestDate == null
                                        ? 'Select Date'
                                        : '${_estimatedHarvestDate!.toLocal()}'
                                            .split(' ')[0],
                                    style: TextStyle(
                                      color: _estimatedHarvestDate == null
                                          ? kTextGrey.withValues(alpha: 0.5)
                                          : Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(PhosphorIconsRegular.calendarBlank,
                                    color: kTextGrey.withValues(alpha: 0.5),
                                    size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submit,
                  child: Text('Create Campaign',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
