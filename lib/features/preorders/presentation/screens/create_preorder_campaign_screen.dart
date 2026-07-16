import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/preorders/presentation/providers/preorder_controller.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmer_campaigns_controller.dart';
import 'package:harvest_app/features/preorders/domain/entities/create_preorder_campaign_params.dart';
import 'package:harvest_app/features/preorders/domain/entities/preorder_campaign.dart';
import 'package:harvest_app/core/widgets/app_cached_image.dart';
import 'package:harvest_app/core/widgets/image_picker_bottom_sheet.dart';
import 'package:harvest_app/features/system/presentation/providers/utility_providers.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Colors.white;
const kInputBg = Color(0xFFF5F5F5);
const kDarkGreen = Color(0xFF1A2F25);
const kTextGrey = Color(0xFF6E7A75);

class CreatePreorderCampaignScreen extends ConsumerStatefulWidget {
  final PreorderCampaign? campaign;
  const CreatePreorderCampaignScreen({super.key, this.campaign});

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
  List<String> _images = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.campaign != null) {
      final c = widget.campaign!;
      _titleController.text = c.productName ?? '';
      _descriptionController.text = c.description ?? '';
      _unitController.text = c.unit ?? '';
      _pricePerUnitController.text = c.price?.toString() ?? '';
      _targetQuantityController.text = c.targetQuantity.toString();
      _minimumOrderQuantityController.text = '1'; // Default as minimum order qty might not be directly in campaign
      _depositPercentageController.text = c.depositAmount.toString();
      _estimatedHarvestDate = c.estimatedHarvestDate;
      if (c.images != null && c.images!.isNotEmpty) {
        _images = List.from(c.images!);
      } else if (c.productImage != null) {
        _images = [c.productImage!];
      }
    }
  }

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
      setState(() {
        _isLoading = true;
      });

      // 1. Upload local images first
      List<String> finalImages = [];
      for (final imagePath in _images) {
        if (!imagePath.startsWith('http')) {
          // It's a local file, we need to upload it
          final uploadUseCase = ref.read(uploadFileUseCaseProvider);
          final result = await uploadUseCase(File(imagePath));
          
          final uploadFailed = result.fold(
            (failure) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to upload image: ${failure.message}')),
                );
                setState(() => _isLoading = false);
              }
              return true;
            },
            (uploadedFile) {
              finalImages.add(uploadedFile.url);
              return false;
            },
          );

          if (uploadFailed) return; // Stop submission if upload fails
        } else {
          // Already uploaded
          finalImages.add(imagePath);
        }
      }

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
        status: widget.campaign?.status ?? "ACTIVE",
        images: finalImages,
      );

      final isEditing = widget.campaign != null;
      bool success = false;
      
      if (isEditing) {
        success = await ref
            .read(preOrderControllerProvider.notifier)
            .updateCampaign(widget.campaign!.id, params);
      } else {
        success = await ref
            .read(preOrderControllerProvider.notifier)
            .createCampaign(params);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        if (success) {
          ref.read(farmerCampaignsControllerProvider.notifier).refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditing ? 'Campaign updated successfully!' : 'Campaign created successfully!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isEditing ? 'Failed to update campaign. Please try again.' : 'Failed to create campaign. Please try again.')),
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

  Widget _buildImagesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Campaign Images'),
        if (_images.isEmpty)
          InkWell(
            onTap: () {
              ImagePickerBottomSheet.show(context, onImagePicked: (path) {
                setState(() {
                  _images.add(path);
                });
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: kInputBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kInputBg), // No harsh border
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(PhosphorIconsRegular.camera,
                      color: kDarkGreen, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add campaign images',
                    style: TextStyle(color: kTextGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ..._images.asMap().entries.map((entry) {
                final index = entry.key;
                final url = entry.value;
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AppCachedImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.red, size: 14),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              InkWell(
                onTap: () {
                  ImagePickerBottomSheet.show(context, onImagePicked: (path) {
                    setState(() {
                      _images.add(path);
                    });
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: kInputBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kInputBg),
                  ),
                  child: const Center(
                    child: Icon(PhosphorIconsRegular.plus, color: kDarkGreen),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          widget.campaign == null ? 'New Pre Order Campaign' : 'Edit Pre Order Campaign',
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
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: kDarkGreen))
        : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagesInput(),
              const SizedBox(height: 20),
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
