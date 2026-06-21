import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../../core/config/router/app_router.dart';

const kBgColor = Color(0xFFF7F9F8);
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class ProductManagementScreen extends ConsumerStatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  ConsumerState<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends ConsumerState<ProductManagementScreen> {
  // Mock data for products
  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Organic Tomatoes',
      'category': 'Vegetables',
      'price': 4.50,
      'unit': 'kg',
      'inStock': true,
      'imageUrl': 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=200&q=80',
    },
    {
      'id': '2',
      'name': 'Fresh Basil',
      'category': 'Herbs',
      'price': 2.00,
      'unit': 'bunch',
      'inStock': true,
      'imageUrl': 'https://images.unsplash.com/photo-1618164436241-ecaf17c38555?w=200&q=80',
    },
    {
      'id': '3',
      'name': 'Free-range Eggs',
      'category': 'Dairy & Eggs',
      'price': 6.50,
      'unit': 'dozen',
      'inStock': false,
      'imageUrl': 'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=200&q=80',
    },
    {
      'id': '4',
      'name': 'Russet Potatoes',
      'category': 'Vegetables',
      'price': 3.00,
      'unit': 'kg',
      'inStock': true,
      'imageUrl': 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=200&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        title: Text(
          'My Products',
          style: GoogleFonts.inter(
            color: kDarkGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIconsRegular.magnifyingGlass, color: kDarkGreen),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIconsRegular.faders, color: kDarkGreen),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
        itemCount: _products.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = _products[index];
          return _buildProductCard(product, index);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRouter.addProduct);
        },
        backgroundColor: kDarkGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Product',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    final inStock = product['inStock'] as bool;
    
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(product['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: !inStock
                  ? BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            
            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: inStock ? kDarkGreen : kTextGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['category'],
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: kTextGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price'].toStringAsFixed(2)} / ${product['unit']}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: inStock ? kAccentOrange : kTextGrey.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            
            // Stock Toggle & Action
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Switch.adaptive(
                  value: inStock,
                  activeColor: kDarkGreen,
                  onChanged: (value) {
                    setState(() {
                      _products[index]['inStock'] = value;
                    });
                  },
                ),
                Text(
                  inStock ? 'In Stock' : 'Out of Stock',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: inStock ? kDarkGreen : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
