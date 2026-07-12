import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/presentation/features/preorder/providers/preorder_controller.dart';
import 'package:harvest_app/presentation/features/producer/products/providers/farmer_campaigns_controller.dart';
import 'package:harvest_app/domain/entities/create_preorder_campaign_params.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePreorderCampaignScreen extends ConsumerStatefulWidget {
  const CreatePreorderCampaignScreen({super.key});

  @override
  ConsumerState<CreatePreorderCampaignScreen> createState() => _CreatePreorderCampaignScreenState();
}

class _CreatePreorderCampaignScreenState extends ConsumerState<CreatePreorderCampaignScreen> {
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
        minimumOrderQuantity: int.tryParse(_minimumOrderQuantityController.text) ?? 1,
        depositPercentage: int.tryParse(_depositPercentageController.text) ?? 0,
        status: "ACTIVE",
      );

      // We will call the controller here
      final success = await ref.read(preOrderControllerProvider.notifier).createCampaign(params);
      
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
            const SnackBar(content: Text('Failed to create campaign. Please try again.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields and dates.')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        title: const Text('New Preorder Campaign'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A2F25),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'e.g. Fresh Organic Tomatoes',
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Description', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'e.g. Sweet and juicy tomatoes from our next harvest.',
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Unit', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _unitController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'e.g. kg',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price per Unit', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _pricePerUnitController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'e.g. 25000',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Target Quantity', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _targetQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'e.g. 100',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Min. Order Qty', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _minimumOrderQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'e.g. 1',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deposit Percentage (%)', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _depositPercentageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'e.g. 50',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Harvest Date', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _estimatedHarvestDate == null 
                                  ? 'Select Date' 
                                  : '${_estimatedHarvestDate!.toLocal()}'.split(' ')[0],
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
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D4A3E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _submit,
                  child: Text('Create Campaign', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
