import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePreorderCampaignScreen extends ConsumerStatefulWidget {
  const CreatePreorderCampaignScreen({super.key});

  @override
  ConsumerState<CreatePreorderCampaignScreen> createState() => _CreatePreorderCampaignScreenState();
}

class _CreatePreorderCampaignScreenState extends ConsumerState<CreatePreorderCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _targetQuantityController = TextEditingController();
  final _depositAmountController = TextEditingController();

  DateTime? _deadline;
  DateTime? _estimatedHarvestDate;
  bool _depositRequired = false;

  @override
  void dispose() {
    _productIdController.dispose();
    _targetQuantityController.dispose();
    _depositAmountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _deadline != null && _estimatedHarvestDate != null) {
      // Implement the actual submit logic here using the PreOrderRepository
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign created successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  Future<void> _pickDate(bool isDeadline) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isDeadline) {
          _deadline = date;
        } else {
          _estimatedHarvestDate = date;
        }
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
              Text('Select Product', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Dummy implementation. Will be replaced by consumer from FarmerProductsController
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Choose a product...',
                  fillColor: Colors.white,
                  filled: true,
                ),
                items: const [
                  DropdownMenuItem(value: 'p1', child: Text('Strawberry Ganitri - Batch #4')),
                  DropdownMenuItem(value: 'p2', child: Text('Organic Tomatoes - Box')),
                  DropdownMenuItem(value: 'p3', child: Text('Fresh Basil - 500g')),
                ],
                onChanged: (value) {
                  _productIdController.text = value ?? '';
                },
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Text('Target Quantity', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _targetQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 50',
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
                        Text('Deadline', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _pickDate(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(_deadline == null ? 'Select Date' : '${_deadline!.toLocal()}'.split(' ')[0]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harvest Date', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _pickDate(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(_estimatedHarvestDate == null ? 'Select Date' : '${_estimatedHarvestDate!.toLocal()}'.split(' ')[0]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Require Deposit', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                value: _depositRequired,
                activeColor: const Color(0xFF2D4A3E),
                onChanged: (val) => setState(() => _depositRequired = val),
              ),
              if (_depositRequired) ...[
                const SizedBox(height: 16),
                Text('Deposit Amount (Rp)', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _depositAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 50000',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],
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
