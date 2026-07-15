import 'package:equatable/equatable.dart';

enum ProductType { regular, perishable }

enum FreshnessLevel { justHarvested, fresh, good, fair }

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final String unit; // kg, pcs, bunch, etc.
  final String imageUrl;
  final List<String> images;
  final bool isOrganic;
  final bool isAvailable;
  final int stock;
  final double? discount;
  final double rating;
  final int reviewCount;
  final String? farmerId;
  final String? farmerName;
  final String? farmerProfileImage;
  final double? farmerDistance; // Distance from user in km
  final DateTime? harvestDate;
  final List<String> tags;
  final DateTime? createdAt;

  // --- Perishable Product Fields ---
  final ProductType productType;
  final bool isPerishable;
  final int? shelfLifeDays; // How long product stays fresh
  final DateTime? bestBeforeDate;
  final FreshnessLevel? freshnessLevel;

  // --- Pre-Order Fields ---
  final bool acceptsPreOrder;
  final DateTime? nextHarvestDate;
  final int? preOrderAvailableQty;
  final double? preOrderPrice; // Special price for pre-orders
  final String? harvestScheduleId; // Link to harvest schedule

  // --- Location/Radius Fields ---
  final double? farmerLatitude;
  final double? farmerLongitude;
  final bool isWithinRadius; // Whether farmer is within user's preferred radius
  
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.unit,
    required this.imageUrl,
    this.images = const [],
    this.isOrganic = false,
    this.isAvailable = true,
    required this.stock,
    this.discount,
    required this.rating,
    required this.reviewCount,
    this.farmerId,
    this.farmerName,
    this.farmerProfileImage,
    this.farmerDistance,
    this.harvestDate,
    this.tags = const [],
    this.createdAt,
    // Perishable fields
    this.productType = ProductType.regular,
    this.isPerishable = false,
    this.shelfLifeDays,
    this.bestBeforeDate,
    this.freshnessLevel,
    // Pre-order fields
    this.acceptsPreOrder = false,
    this.nextHarvestDate,
    this.preOrderAvailableQty,
    this.preOrderPrice,
    this.harvestScheduleId,
    // Location fields
    this.farmerLatitude,
    this.farmerLongitude,
    this.isWithinRadius = false,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? price,
    String? unit,
    String? imageUrl,
    List<String>? images,
    bool? isOrganic,
    bool? isAvailable,
    int? stock,
    double? discount,
    double? rating,
    int? reviewCount,
    String? farmerId,
    String? farmerName,
    String? farmerProfileImage,
    double? farmerDistance,
    DateTime? harvestDate,
    List<String>? tags,
    DateTime? createdAt,
    ProductType? productType,
    bool? isPerishable,
    int? shelfLifeDays,
    DateTime? bestBeforeDate,
    FreshnessLevel? freshnessLevel,
    bool? acceptsPreOrder,
    DateTime? nextHarvestDate,
    int? preOrderAvailableQty,
    double? preOrderPrice,
    String? harvestScheduleId,
    double? farmerLatitude,
    double? farmerLongitude,
    bool? isWithinRadius,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      isOrganic: isOrganic ?? this.isOrganic,
      isAvailable: isAvailable ?? this.isAvailable,
      stock: stock ?? this.stock,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      farmerProfileImage: farmerProfileImage ?? this.farmerProfileImage,
      farmerDistance: farmerDistance ?? this.farmerDistance,
      harvestDate: harvestDate ?? this.harvestDate,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      productType: productType ?? this.productType,
      isPerishable: isPerishable ?? this.isPerishable,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      bestBeforeDate: bestBeforeDate ?? this.bestBeforeDate,
      freshnessLevel: freshnessLevel ?? this.freshnessLevel,
      acceptsPreOrder: acceptsPreOrder ?? this.acceptsPreOrder,
      nextHarvestDate: nextHarvestDate ?? this.nextHarvestDate,
      preOrderAvailableQty: preOrderAvailableQty ?? this.preOrderAvailableQty,
      preOrderPrice: preOrderPrice ?? this.preOrderPrice,
      harvestScheduleId: harvestScheduleId ?? this.harvestScheduleId,
      farmerLatitude: farmerLatitude ?? this.farmerLatitude,
      farmerLongitude: farmerLongitude ?? this.farmerLongitude,
      isWithinRadius: isWithinRadius ?? this.isWithinRadius,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  double get finalPrice {
    if (discount != null && discount! > 0) {
      return price * (1 - discount! / 100);
    }
    return price;
  }

  bool get hasDiscount => discount != null && discount! > 0;

  /// Days until product expires (for perishables)
  int? get daysUntilExpiry {
    if (bestBeforeDate == null) return null;
    return bestBeforeDate!.difference(DateTime.now()).inDays;
  }

  /// Days until next harvest (for pre-orders)
  int? get daysUntilHarvest {
    if (nextHarvestDate == null) return null;
    return nextHarvestDate!.difference(DateTime.now()).inDays;
  }

  /// Whether pre-order is available
  bool get canPreOrder {
    return acceptsPreOrder &&
        nextHarvestDate != null &&
        (preOrderAvailableQty == null || preOrderAvailableQty! > 0);
  }

  /// Whether product is freshly harvested (within 24 hours)
  bool get isJustHarvested {
    if (harvestDate == null) return false;
    return DateTime.now().difference(harvestDate!).inHours < 24;
  }

  /// Get freshness label for display
  String get freshnessLabel {
    if (freshnessLevel == null) return '';
    switch (freshnessLevel!) {
      case FreshnessLevel.justHarvested:
        return 'Just Harvested';
      case FreshnessLevel.fresh:
        return 'Fresh';
      case FreshnessLevel.good:
        return 'Good';
      case FreshnessLevel.fair:
        return 'Fair';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        price,
        unit,
        imageUrl,
        images,
        isOrganic,
        isAvailable,
        stock,
        discount,
        rating,
        reviewCount,
        farmerId,
        farmerName,
        farmerProfileImage,
        farmerDistance,
        harvestDate,
        tags,
        createdAt,
        productType,
        isPerishable,
        shelfLifeDays,
        bestBeforeDate,
        freshnessLevel,
        acceptsPreOrder,
        nextHarvestDate,
        preOrderAvailableQty,
        preOrderPrice,
        harvestScheduleId,
        farmerLatitude,
        farmerLongitude,
        isWithinRadius,
        isFavorite,
      ];
}
