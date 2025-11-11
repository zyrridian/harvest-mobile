import 'package:equatable/equatable.dart';

// Detailed Product Entity for Product Detail Screen
class ProductDetail extends Equatable {
  final String productId;
  final String name;
  final String slug;
  final String description;
  final String? longDescription;
  final ProductCategory category;
  final ProductSubcategory? subcategory;
  final double price;
  final String currency;
  final String unit;
  final ProductDiscount? discount;
  final int stockQuantity;
  final int minimumOrder;
  final int maximumOrder;
  final double? unitWeight;
  final List<ProductImage> images;
  final List<ProductVideo>? videos;
  final ProductSeller seller;
  final List<ProductSpecification>? specifications;
  final List<ProductCertification>? certifications;
  final ProductRating rating;
  final ProductReviewSummary? reviews;
  final List<String> tags;
  final ProductLabels labels;
  final DateTime? harvestDate;
  final ProductAvailability availability;
  final ProductDeliveryOptions deliveryOptions;
  final List<BulkPricing>? bulkPricing;
  final List<RelatedProduct>? relatedProducts;
  final List<RelatedProduct>? frequentlyBoughtTogether;
  final ProductStats stats;
  final ProductPolicies? policies;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final bool isFavorite;
  final bool isInCart;
  final bool isInWishlist;

  const ProductDetail({
    required this.productId,
    required this.name,
    required this.slug,
    required this.description,
    this.longDescription,
    required this.category,
    this.subcategory,
    required this.price,
    required this.currency,
    required this.unit,
    this.discount,
    required this.stockQuantity,
    required this.minimumOrder,
    required this.maximumOrder,
    this.unitWeight,
    required this.images,
    this.videos,
    required this.seller,
    this.specifications,
    this.certifications,
    required this.rating,
    this.reviews,
    required this.tags,
    required this.labels,
    this.harvestDate,
    required this.availability,
    required this.deliveryOptions,
    this.bulkPricing,
    this.relatedProducts,
    this.frequentlyBoughtTogether,
    required this.stats,
    this.policies,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    required this.isFavorite,
    required this.isInCart,
    required this.isInWishlist,
  });

  double get finalPrice => discount?.discountedPrice ?? price;
  bool get hasDiscount => discount != null;
  bool get isInStock => availability.status == 'in_stock' && stockQuantity > 0;
  bool get isLowStock => availability.isLowStock ?? false;

  @override
  List<Object?> get props => [
        productId,
        name,
        slug,
        description,
        longDescription,
        category,
        subcategory,
        price,
        currency,
        unit,
        discount,
        stockQuantity,
        minimumOrder,
        maximumOrder,
        unitWeight,
        images,
        videos,
        seller,
        specifications,
        certifications,
        rating,
        reviews,
        tags,
        labels,
        harvestDate,
        availability,
        deliveryOptions,
        bulkPricing,
        relatedProducts,
        frequentlyBoughtTogether,
        stats,
        policies,
        createdAt,
        updatedAt,
        publishedAt,
        isFavorite,
        isInCart,
        isInWishlist,
      ];
}

// Product Category
class ProductCategory extends Equatable {
  final String categoryId;
  final String name;
  final String slug;

  const ProductCategory({
    required this.categoryId,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [categoryId, name, slug];
}

// Product Subcategory
class ProductSubcategory extends Equatable {
  final String subcategoryId;
  final String name;
  final String slug;

  const ProductSubcategory({
    required this.subcategoryId,
    required this.name,
    required this.slug,
  });

  @override
  List<Object?> get props => [subcategoryId, name, slug];
}

// Product Discount
class ProductDiscount extends Equatable {
  final String? discountId;
  final String type; // percentage, fixed
  final double value;
  final double discountedPrice;
  final double? savings;
  final DateTime? validFrom;
  final DateTime validUntil;
  final String? reason;

  const ProductDiscount({
    this.discountId,
    required this.type,
    required this.value,
    required this.discountedPrice,
    this.savings,
    this.validFrom,
    required this.validUntil,
    this.reason,
  });

  @override
  List<Object?> get props => [
        discountId,
        type,
        value,
        discountedPrice,
        savings,
        validFrom,
        validUntil,
        reason
      ];
}

// Product Image
class ProductImage extends Equatable {
  final String imageId;
  final String url;
  final String thumbnailUrl;
  final String? mediumUrl;
  final String? altText;
  final bool isPrimary;
  final int order;

  const ProductImage({
    required this.imageId,
    required this.url,
    required this.thumbnailUrl,
    this.mediumUrl,
    this.altText,
    required this.isPrimary,
    required this.order,
  });

  @override
  List<Object?> get props =>
      [imageId, url, thumbnailUrl, mediumUrl, altText, isPrimary, order];
}

// Product Video
class ProductVideo extends Equatable {
  final String videoId;
  final String url;
  final String thumbnailUrl;
  final int duration;
  final String? title;

  const ProductVideo({
    required this.videoId,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    this.title,
  });

  @override
  List<Object?> get props => [videoId, url, thumbnailUrl, duration, title];
}

// Product Seller
class ProductSeller extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;
  final double rating;
  final int? reviewsCount;
  final bool verified;
  final String? verificationBadge;
  final SellerLocation location;
  final int? responseRate;
  final String? responseTime;
  final int? totalProducts;
  final DateTime? joinedSince;
  final int? followersCount;

  const ProductSeller({
    required this.userId,
    required this.name,
    this.profilePicture,
    required this.rating,
    this.reviewsCount,
    required this.verified,
    this.verificationBadge,
    required this.location,
    this.responseRate,
    this.responseTime,
    this.totalProducts,
    this.joinedSince,
    this.followersCount,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        profilePicture,
        rating,
        reviewsCount,
        verified,
        verificationBadge,
        location,
        responseRate,
        responseTime,
        totalProducts,
        joinedSince,
        followersCount,
      ];
}

// Seller Location
class SellerLocation extends Equatable {
  final String city;
  final String province;
  final String? detailedAddress;
  final double? latitude;
  final double? longitude;
  final double? distance;

  const SellerLocation({
    required this.city,
    required this.province,
    this.detailedAddress,
    this.latitude,
    this.longitude,
    this.distance,
  });

  @override
  List<Object?> get props =>
      [city, province, detailedAddress, latitude, longitude, distance];
}

// Product Specification
class ProductSpecification extends Equatable {
  final String key;
  final String value;

  const ProductSpecification({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}

// Product Certification
class ProductCertification extends Equatable {
  final String certificationId;
  final String name;
  final String issuer;
  final String certificateNumber;
  final DateTime issueDate;
  final DateTime expiryDate;
  final bool verified;
  final String? badgeUrl;

  const ProductCertification({
    required this.certificationId,
    required this.name,
    required this.issuer,
    required this.certificateNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.verified,
    this.badgeUrl,
  });

  @override
  List<Object?> get props => [
        certificationId,
        name,
        issuer,
        certificateNumber,
        issueDate,
        expiryDate,
        verified,
        badgeUrl
      ];
}

// Product Rating
class ProductRating extends Equatable {
  final double average;
  final int count;
  final RatingDistribution distribution;

  const ProductRating({
    required this.average,
    required this.count,
    required this.distribution,
  });

  @override
  List<Object?> get props => [average, count, distribution];
}

// Rating Distribution
class RatingDistribution extends Equatable {
  final int fiveStar;
  final int fourStar;
  final int threeStar;
  final int twoStar;
  final int oneStar;

  const RatingDistribution({
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  @override
  List<Object?> get props => [fiveStar, fourStar, threeStar, twoStar, oneStar];
}

// Product Review Summary
class ProductReviewSummary extends Equatable {
  final int totalCount;
  final int withPhotosCount;
  final List<ProductReview>? recentReviews;

  const ProductReviewSummary({
    required this.totalCount,
    required this.withPhotosCount,
    this.recentReviews,
  });

  @override
  List<Object?> get props => [totalCount, withPhotosCount, recentReviews];
}

// Product Review
class ProductReview extends Equatable {
  final String reviewId;
  final int rating;
  final String? title;
  final String comment;
  final ReviewBuyer buyer;
  final List<ReviewImage>? images;
  final int helpfulCount;
  final bool isHelpful;
  final SellerResponse? sellerResponse;
  final DateTime createdAt;

  const ProductReview({
    required this.reviewId,
    required this.rating,
    this.title,
    required this.comment,
    required this.buyer,
    this.images,
    required this.helpfulCount,
    required this.isHelpful,
    this.sellerResponse,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        reviewId,
        rating,
        title,
        comment,
        buyer,
        images,
        helpfulCount,
        isHelpful,
        sellerResponse,
        createdAt
      ];
}

// Review Buyer
class ReviewBuyer extends Equatable {
  final String userId;
  final String name;
  final String? profilePicture;
  final bool isVerifiedPurchase;

  const ReviewBuyer({
    required this.userId,
    required this.name,
    this.profilePicture,
    required this.isVerifiedPurchase,
  });

  @override
  List<Object?> get props => [userId, name, profilePicture, isVerifiedPurchase];
}

// Review Image
class ReviewImage extends Equatable {
  final String imageId;
  final String url;
  final String thumbnailUrl;

  const ReviewImage({
    required this.imageId,
    required this.url,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [imageId, url, thumbnailUrl];
}

// Seller Response
class SellerResponse extends Equatable {
  final String comment;
  final DateTime respondedAt;

  const SellerResponse({
    required this.comment,
    required this.respondedAt,
  });

  @override
  List<Object?> get props => [comment, respondedAt];
}

// Product Labels
class ProductLabels extends Equatable {
  final bool isOrganic;
  final bool isCertified;
  final bool isNew;
  final bool isFeatured;
  final bool isBestSeller;
  final bool? isOnSale;

  const ProductLabels({
    required this.isOrganic,
    required this.isCertified,
    required this.isNew,
    required this.isFeatured,
    required this.isBestSeller,
    this.isOnSale,
  });

  @override
  List<Object?> get props =>
      [isOrganic, isCertified, isNew, isFeatured, isBestSeller, isOnSale];
}

// Product Availability
class ProductAvailability extends Equatable {
  final String status; // in_stock, out_of_stock, pre_order, coming_soon
  final DateTime? availableDate;
  final DateTime? estimatedRestock;
  final int? lowStockThreshold;
  final bool? isLowStock;

  const ProductAvailability({
    required this.status,
    this.availableDate,
    this.estimatedRestock,
    this.lowStockThreshold,
    this.isLowStock,
  });

  @override
  List<Object?> get props =>
      [status, availableDate, estimatedRestock, lowStockThreshold, isLowStock];
}

// Product Delivery Options
class ProductDeliveryOptions extends Equatable {
  final SelfPickupOption? selfPickup;
  final HomeDeliveryOption? homeDelivery;
  final SameDayDeliveryOption? sameDayDelivery;
  final ExpressDeliveryOption? expressDelivery;

  const ProductDeliveryOptions({
    this.selfPickup,
    this.homeDelivery,
    this.sameDayDelivery,
    this.expressDelivery,
  });

  @override
  List<Object?> get props =>
      [selfPickup, homeDelivery, sameDayDelivery, expressDelivery];
}

// Self Pickup Option
class SelfPickupOption extends Equatable {
  final bool available;
  final String? address;
  final String? instructions;

  const SelfPickupOption({
    required this.available,
    this.address,
    this.instructions,
  });

  @override
  List<Object?> get props => [available, address, instructions];
}

// Home Delivery Option
class HomeDeliveryOption extends Equatable {
  final bool available;
  final double? fee;
  final double? freeDeliveryThreshold;
  final String? estimatedDelivery;
  final List<String>? deliveryAreas;

  const HomeDeliveryOption({
    required this.available,
    this.fee,
    this.freeDeliveryThreshold,
    this.estimatedDelivery,
    this.deliveryAreas,
  });

  @override
  List<Object?> get props =>
      [available, fee, freeDeliveryThreshold, estimatedDelivery, deliveryAreas];
}

// Same Day Delivery Option
class SameDayDeliveryOption extends Equatable {
  final bool available;
  final String? cutoffTime;
  final double? additionalFee;

  const SameDayDeliveryOption({
    required this.available,
    this.cutoffTime,
    this.additionalFee,
  });

  @override
  List<Object?> get props => [available, cutoffTime, additionalFee];
}

// Express Delivery Option
class ExpressDeliveryOption extends Equatable {
  final bool available;
  final double? fee;
  final String? estimatedDelivery;
  final String? cutoffTime;

  const ExpressDeliveryOption({
    required this.available,
    this.fee,
    this.estimatedDelivery,
    this.cutoffTime,
  });

  @override
  List<Object?> get props => [available, fee, estimatedDelivery, cutoffTime];
}

// Bulk Pricing
class BulkPricing extends Equatable {
  final int minQuantity;
  final int? maxQuantity;
  final double pricePerUnit;
  final double discountPercentage;

  const BulkPricing({
    required this.minQuantity,
    this.maxQuantity,
    required this.pricePerUnit,
    required this.discountPercentage,
  });

  @override
  List<Object?> get props =>
      [minQuantity, maxQuantity, pricePerUnit, discountPercentage];
}

// Related Product
class RelatedProduct extends Equatable {
  final String productId;
  final String name;
  final double price;
  final String? image;
  final double? rating;

  const RelatedProduct({
    required this.productId,
    required this.name,
    required this.price,
    this.image,
    this.rating,
  });

  @override
  List<Object?> get props => [productId, name, price, image, rating];
}

// Product Stats
class ProductStats extends Equatable {
  final int views;
  final int? viewsToday;
  final int favorites;
  final int? inCarts;
  final int orders;
  final int? inquiries;
  final int? shares;

  const ProductStats({
    required this.views,
    this.viewsToday,
    required this.favorites,
    this.inCarts,
    required this.orders,
    this.inquiries,
    this.shares,
  });

  @override
  List<Object?> get props =>
      [views, viewsToday, favorites, inCarts, orders, inquiries, shares];
}

// Product Policies
class ProductPolicies extends Equatable {
  final String? returnPolicy;
  final String? refundPolicy;
  final String? warranty;

  const ProductPolicies({
    this.returnPolicy,
    this.refundPolicy,
    this.warranty,
  });

  @override
  List<Object?> get props => [returnPolicy, refundPolicy, warranty];
}
