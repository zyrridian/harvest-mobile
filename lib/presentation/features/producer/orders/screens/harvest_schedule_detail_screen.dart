import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class HarvestScheduleDetailScreen extends ConsumerStatefulWidget {
  const HarvestScheduleDetailScreen({super.key});

  @override
  ConsumerState<HarvestScheduleDetailScreen> createState() => _HarvestScheduleDetailScreenState();
}

class _HarvestScheduleDetailScreenState extends ConsumerState<HarvestScheduleDetailScreen> {
  bool _isPickupArranged = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Schedule Details',
          style: TextStyle(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(),
            const SizedBox(height: 24),
            _buildBuyerInfo(),
            const SizedBox(height: 24),
            _buildOrderDetails(),
            const SizedBox(height: 24),
            _buildPaymentSummary(),
            const SizedBox(height: 40),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isPickupArranged ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isPickupArranged ? Colors.green.withOpacity(0.3) : kAccentOrange.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            _isPickupArranged ? PhosphorIconsFill.checkCircle : PhosphorIconsFill.clockUser,
            size: 40,
            color: _isPickupArranged ? Colors.green : kAccentOrange,
          ),
          const SizedBox(height: 12),
          Text(
            _isPickupArranged ? 'Pickup Arranged' : 'Awaiting Confirmation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isPickupArranged ? Colors.green[800] : kAccentOrange,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Order #HAR-550',
            style: TextStyle(
              fontSize: 14,
              color: kTextGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buyer Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorderColor),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=33'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fresh Market Inc.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Wholesale Buyer',
                      style: TextStyle(
                        fontSize: 13,
                        color: kTextGrey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(PhosphorIconsFill.chatCircleText, color: kDarkGreen),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F5F2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agreed Harvest & Pickup',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorderColor),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                icon: PhosphorIconsRegular.calendar,
                title: 'Harvest Date',
                value: 'June 28, 2026',
              ),
              const Divider(height: 24, color: kBorderColor),
              _buildDetailRow(
                icon: PhosphorIconsRegular.clock,
                title: 'Pickup Time',
                value: '10:00 AM - 12:00 PM',
              ),
              const Divider(height: 24, color: kBorderColor),
              _buildDetailRow(
                icon: PhosphorIconsRegular.package,
                title: 'Items',
                value: '100kg Potatoes',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, color: kTextGrey, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: kTextGrey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kDarkGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kDarkGreen,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kCardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorderColor),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount', style: TextStyle(color: kTextGrey)),
                  Text('\$450.00', style: TextStyle(fontWeight: FontWeight.w600, color: kDarkGreen)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Deposit Paid ', style: TextStyle(color: kTextGrey)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text('PAID', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Text('\$90.00', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: kBorderColor, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Balance Due at Pickup', style: TextStyle(fontWeight: FontWeight.bold, color: kDarkGreen)),
                  Text('\$360.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kAccentOrange)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_isPickupArranged) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: () {
            // Show QR code for buyer to scan upon pickup
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kDarkGreen, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(PhosphorIconsRegular.qrCode, color: kDarkGreen),
              const SizedBox(width: 8),
              Text(
                'Show Pickup QR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kDarkGreen,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isPickupArranged = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pickup has been confirmed!')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kDarkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Confirm Pickup Arranged',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
