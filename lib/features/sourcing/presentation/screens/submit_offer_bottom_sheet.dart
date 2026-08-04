import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../domain/entities/sourcing_request.dart';
import '../providers/sourcing_controller.dart';

const kDarkGreen = Color(0xFF1A2F25);
const kPillGrey = Color(0xFFF0F2F0);
const kFreshGreen = Color(0xFF10B981);

class SubmitOfferBottomSheet extends ConsumerStatefulWidget {
  final SourcingRequest request;
  
  const SubmitOfferBottomSheet({super.key, required this.request});

  @override
  ConsumerState<SubmitOfferBottomSheet> createState() =>
      _SubmitOfferBottomSheetState();
}

class _SubmitOfferBottomSheetState extends ConsumerState<SubmitOfferBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final priceStr = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final price = double.tryParse(priceStr) ?? 0.0;
      
      if (price <= 0) return;

      ref.read(sourcingActionControllerProvider.notifier).submitOffer(
            requestId: widget.request.id,
            price: price,
            notes: _notesController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(sourcingActionControllerProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      } else if (next is AsyncData && previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offer submitted successfully')),
        );
        context.pop();
      }
    });

    final isLoading = ref.watch(sourcingActionControllerProvider) is AsyncLoading;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Submit Offer',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                    ),
                    IconButton(
                      icon: const PhosphorIcon(PhosphorIconsRegular.x),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Request Info summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kPillGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.request.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkGreen),
                      ),
                      if (widget.request.budget != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Buyer Budget: Rp ${widget.request.budget!.toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Price
                Text(
                  'Your Price Offer',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold, color: kDarkGreen),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    filled: true,
                    fillColor: kPillGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Price is required';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Notes
                Text(
                  'Additional Notes (Optional)',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold, color: kDarkGreen),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'e.g. Delivery included, best quality guaranteed...',
                    filled: true,
                    fillColor: kPillGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kFreshGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Submit Offer',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
