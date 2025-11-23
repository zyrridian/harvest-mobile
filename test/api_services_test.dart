import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Basic App Tests', () {
    test('String manipulation works correctly', () {
      const testString = 'Harvest App';
      expect(testString.length, 11);
      expect(testString.toLowerCase(), 'harvest app');
      expect(testString.contains('Harvest'), true);
    });

    test('List operations work correctly', () {
      final fruits = ['Apple', 'Banana', 'Orange'];
      expect(fruits.length, 3);
      expect(fruits.first, 'Apple');
      expect(fruits.last, 'Orange');

      fruits.add('Mango');
      expect(fruits.length, 4);
    });

    test('Math operations are accurate', () {
      expect(2 + 2, 4);
      expect(10 - 5, 5);
      expect(3 * 4, 12);
      expect(15 / 3, 5);
    });

    test('Boolean logic works correctly', () {
      expect(true && true, true);
      expect(true, isTrue);
      expect(!false, true);
      expect(5 > 3, true);
      expect(10 < 5, false);
    });
  });

  group('Data Validation Tests', () {
    test('Email validation pattern', () {
      final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

      expect(emailPattern.hasMatch('user@example.com'), true);
      expect(emailPattern.hasMatch('test.user@domain.co.id'), true);
      expect(emailPattern.hasMatch('invalid-email'), false);
      expect(emailPattern.hasMatch('missing@domain'), false);
    });

    test('Price formatting', () {
      double price = 15000.50;
      String formattedPrice = 'Rp ${price.toStringAsFixed(0)}';

      expect(formattedPrice, 'Rp 15001');
    });

    test('Date comparison', () {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      final yesterday = now.subtract(const Duration(days: 1));

      expect(tomorrow.isAfter(now), true);
      expect(yesterday.isBefore(now), true);
    });
  });

  group('Mock Data Tests', () {
    test('Product model-like structure', () {
      final product = {
        'id': '1',
        'name': 'Fresh Tomatoes',
        'price': 25000,
        'category': 'Vegetables',
        'inStock': true,
      };

      expect(product['name'], 'Fresh Tomatoes');
      expect(product['price'], 25000);
      expect(product['inStock'], true);
      expect(product.containsKey('category'), true);
    });

    test('User model-like structure', () {
      final user = {
        'id': '123',
        'name': 'John Farmer',
        'email': 'john@farm.com',
        'role': 'farmer',
        'verified': true,
      };

      expect(user['role'], 'farmer');
      expect(user['verified'], true);
      expect(user['email'], contains('@'));
    });

    test('Order calculation', () {
      final items = [
        {'name': 'Apple', 'quantity': 3, 'price': 5000},
        {'name': 'Banana', 'quantity': 2, 'price': 3000},
      ];

      int total = 0;
      for (var item in items) {
        total += (item['quantity'] as int) * (item['price'] as int);
      }

      expect(total, 21000); // (3 * 5000) + (2 * 3000)
    });
  });
}
