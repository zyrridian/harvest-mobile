// // Example: How to use translations in home_screen.dart
// // This is just a reference - you can apply this pattern to any screen

// import 'package:flutter/material.dart';
// import '../../../../core/localization/app_localizations.dart';
// // OR use the extension for cleaner code:
// import '../../../../core/utils/localization_extension.dart';

// class HomeScreenExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Method 1: Standard approach
//     final l10n = AppLocalizations.of(context)!;
    
//     // Method 2: Using extension (cleaner)
//     // Just use: context.l10n.home
    
//     return Scaffold(
//       appBar: AppBar(
//         // Instead of: title: Text('Harvest Market.'),
//         title: Text(l10n.appName),
//         // OR with extension:
//         // title: Text(context.l10n.appName),
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           // Instead of: 'Search fresh products...'
//           Text(l10n.searchFreshProducts),
//           // OR: Text(context.l10n.searchFreshProducts),
          
//           // Categories header
//           // Instead of: 'Shop by Category'
//           Text(l10n.shopByCategory),
          
//           // Farmers section
//           // Instead of: 'Farmers Near You'
//           Text(l10n.farmersNearYou),
          
//           // Map button
//           // Instead of: 'View Map'
//           ElevatedButton(
//             child: Text(l10n.viewMap),
//             onPressed: () {},
//           ),
          
//           // Fresh Today section
//           // Instead of: 'Fresh Today'
//           Text(l10n.freshToday),
          
//           // See all link
//           // Instead of: 'See all'
//           TextButton(
//             child: Text(l10n.seeAll),
//             onPressed: () {},
//           ),
//         ],
//       ),
      
//       // Bottom navigation
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           // Instead of: BottomNavigationBarItem(label: 'Home')
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: l10n.home,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.school),
//             label: l10n.learn,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.receipt_long),
//             label: l10n.orders,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: l10n.profile,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Available translation keys (from en.json):
// // - app_name, home, learn, orders, profile
// // - farmers, cart, checkout, search
// // - search_fresh_products, shop_by_category
// // - farmers_near_you, view_map, fresh_today, see_all
// // - my_cart, cart_empty, start_shopping
// // - my_orders, processing, delivered, cancelled
// // - edit_profile, personal_information, my_addresses
// // - logout, language, save, cancel, delete, edit
// // And 100+ more...
