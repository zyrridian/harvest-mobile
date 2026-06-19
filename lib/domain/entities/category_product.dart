class CategoryProduct {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String sellerId;
  final String sellerName;
  final double price;
  final String unit;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isPremium;
  final bool isOrganic;
  final int stockQuantity;
  final String? discount;

  CategoryProduct({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.sellerId,
    required this.sellerName,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.isPremium = false,
    this.isOrganic = false,
    required this.stockQuantity,
    this.discount,
  });
}
