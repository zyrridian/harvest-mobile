import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_detail.dart';

part 'product_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductDetailModel {
  @JsonKey(name: 'product_id')
  final String productId;
  final String name;
  final String slug;
  final String description;
  @JsonKey(name: 'long_description')
  final String? longDescription;
  final ProductCategoryModel category;
  final ProductSubcategoryModel? subcategory;
  final double price;
  final String currency;
  final String unit;
  final ProductDiscountModel? discount;
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @JsonKey(name: 'minimum_order')
  final int minimumOrder;
  @JsonKey(name: 'maximum_order')
  final int maximumOrder;
  @JsonKey(name: 'unit_weight')
  final double? unitWeight;
  final List<ProductImageModel> images;
  final List<ProductVideoModel>? videos;
  final ProductSellerModel seller;
  final List<ProductSpecificationModel>? specifications;
  final List<ProductCertificationModel>? certifications;
  final ProductRatingModel rating;
  final ProductReviewSummaryModel? reviews;
  final List<String> tags;
  final ProductLabelsModel labels;
  @JsonKey(name: 'harvest_date')
  final String? harvestDate;
  final ProductAvailabilityModel availability;
  @JsonKey(name: 'delivery_options')
  final ProductDeliveryOptionsModel deliveryOptions;
  @JsonKey(name: 'bulk_pricing')
  final List<BulkPricingModel>? bulkPricing;
  @JsonKey(name: 'related_products')
  final List<RelatedProductModel>? relatedProducts;
  @JsonKey(name: 'frequently_bought_together')
  final List<RelatedProductModel>? frequentlyBoughtTogether;
  final ProductStatsModel stats;
  final ProductPoliciesModel? policies;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'published_at')
  final String? publishedAt;
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;
  @JsonKey(name: 'is_in_cart')
  final bool isInCart;
  @JsonKey(name: 'is_in_wishlist')
  final bool isInWishlist;

  ProductDetailModel({
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

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailModelToJson(this);

  ProductDetail toEntity() {
    return ProductDetail(
      productId: productId,
      name: name,
      slug: slug,
      description: description,
      longDescription: longDescription,
      category: category.toEntity(),
      subcategory: subcategory?.toEntity(),
      price: price,
      currency: currency,
      unit: unit,
      discount: discount?.toEntity(),
      stockQuantity: stockQuantity,
      minimumOrder: minimumOrder,
      maximumOrder: maximumOrder,
      unitWeight: unitWeight,
      images: images.map((e) => e.toEntity()).toList(),
      videos: videos?.map((e) => e.toEntity()).toList(),
      seller: seller.toEntity(),
      specifications: specifications?.map((e) => e.toEntity()).toList(),
      certifications: certifications?.map((e) => e.toEntity()).toList(),
      rating: rating.toEntity(),
      reviews: reviews?.toEntity(),
      tags: tags,
      labels: labels.toEntity(),
      harvestDate: harvestDate != null ? DateTime.parse(harvestDate!) : null,
      availability: availability.toEntity(),
      deliveryOptions: deliveryOptions.toEntity(),
      bulkPricing: bulkPricing?.map((e) => e.toEntity()).toList(),
      relatedProducts: relatedProducts?.map((e) => e.toEntity()).toList(),
      frequentlyBoughtTogether:
          frequentlyBoughtTogether?.map((e) => e.toEntity()).toList(),
      stats: stats.toEntity(),
      policies: policies?.toEntity(),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      publishedAt: publishedAt != null ? DateTime.parse(publishedAt!) : null,
      isFavorite: isFavorite,
      isInCart: isInCart,
      isInWishlist: isInWishlist,
    );
  }
}

@JsonSerializable()
class ProductCategoryModel {
  @JsonKey(name: 'category_id')
  final String categoryId;
  final String name;
  final String slug;

  ProductCategoryModel(
      {required this.categoryId, required this.name, required this.slug});

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryModelToJson(this);

  ProductCategory toEntity() =>
      ProductCategory(categoryId: categoryId, name: name, slug: slug);
}

@JsonSerializable()
class ProductSubcategoryModel {
  @JsonKey(name: 'subcategory_id')
  final String subcategoryId;
  final String name;
  final String slug;

  ProductSubcategoryModel(
      {required this.subcategoryId, required this.name, required this.slug});

  factory ProductSubcategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSubcategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSubcategoryModelToJson(this);

  ProductSubcategory toEntity() =>
      ProductSubcategory(subcategoryId: subcategoryId, name: name, slug: slug);
}

@JsonSerializable()
class ProductDiscountModel {
  @JsonKey(name: 'discount_id')
  final String? discountId;
  final String type;
  final double value;
  @JsonKey(name: 'discounted_price')
  final double discountedPrice;
  final double? savings;
  @JsonKey(name: 'valid_from')
  final String? validFrom;
  @JsonKey(name: 'valid_until')
  final String validUntil;
  final String? reason;

  ProductDiscountModel({
    this.discountId,
    required this.type,
    required this.value,
    required this.discountedPrice,
    this.savings,
    this.validFrom,
    required this.validUntil,
    this.reason,
  });

  factory ProductDiscountModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDiscountModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDiscountModelToJson(this);

  ProductDiscount toEntity() => ProductDiscount(
        discountId: discountId,
        type: type,
        value: value,
        discountedPrice: discountedPrice,
        savings: savings,
        validFrom: validFrom != null ? DateTime.parse(validFrom!) : null,
        validUntil: DateTime.parse(validUntil),
        reason: reason,
      );
}

@JsonSerializable()
class ProductImageModel {
  @JsonKey(name: 'image_id')
  final String imageId;
  final String url;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  @JsonKey(name: 'medium_url')
  final String? mediumUrl;
  @JsonKey(name: 'alt_text')
  final String? altText;
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  final int order;

  ProductImageModel({
    required this.imageId,
    required this.url,
    required this.thumbnailUrl,
    this.mediumUrl,
    this.altText,
    required this.isPrimary,
    required this.order,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductImageModelToJson(this);

  ProductImage toEntity() => ProductImage(
        imageId: imageId,
        url: url,
        thumbnailUrl: thumbnailUrl,
        mediumUrl: mediumUrl,
        altText: altText,
        isPrimary: isPrimary,
        order: order,
      );
}

@JsonSerializable()
class ProductVideoModel {
  @JsonKey(name: 'video_id')
  final String videoId;
  final String url;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  final int duration;
  final String? title;

  ProductVideoModel({
    required this.videoId,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    this.title,
  });

  factory ProductVideoModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVideoModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductVideoModelToJson(this);

  ProductVideo toEntity() => ProductVideo(
        videoId: videoId,
        url: url,
        thumbnailUrl: thumbnailUrl,
        duration: duration,
        title: title,
      );
}

@JsonSerializable(explicitToJson: true)
class ProductSellerModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  final double rating;
  @JsonKey(name: 'reviews_count')
  final int? reviewsCount;
  final bool verified;
  @JsonKey(name: 'verification_badge')
  final String? verificationBadge;
  final SellerLocationModel location;
  @JsonKey(name: 'response_rate')
  final int? responseRate;
  @JsonKey(name: 'response_time')
  final String? responseTime;
  @JsonKey(name: 'total_products')
  final int? totalProducts;
  @JsonKey(name: 'joined_since')
  final String? joinedSince;
  @JsonKey(name: 'followers_count')
  final int? followersCount;

  ProductSellerModel({
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

  factory ProductSellerModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSellerModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSellerModelToJson(this);

  ProductSeller toEntity() => ProductSeller(
        userId: userId,
        name: name,
        profilePicture: profilePicture,
        rating: rating,
        reviewsCount: reviewsCount,
        verified: verified,
        verificationBadge: verificationBadge,
        location: location.toEntity(),
        responseRate: responseRate,
        responseTime: responseTime,
        totalProducts: totalProducts,
        joinedSince: joinedSince != null ? DateTime.parse(joinedSince!) : null,
        followersCount: followersCount,
      );
}

@JsonSerializable()
class SellerLocationModel {
  final String city;
  final String province;
  @JsonKey(name: 'detailed_address')
  final String? detailedAddress;
  final double? latitude;
  final double? longitude;
  final double? distance;

  SellerLocationModel({
    required this.city,
    required this.province,
    this.detailedAddress,
    this.latitude,
    this.longitude,
    this.distance,
  });

  factory SellerLocationModel.fromJson(Map<String, dynamic> json) =>
      _$SellerLocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$SellerLocationModelToJson(this);

  SellerLocation toEntity() => SellerLocation(
        city: city,
        province: province,
        detailedAddress: detailedAddress,
        latitude: latitude,
        longitude: longitude,
        distance: distance,
      );
}

@JsonSerializable()
class ProductSpecificationModel {
  final String key;
  final String value;

  ProductSpecificationModel({required this.key, required this.value});

  factory ProductSpecificationModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSpecificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSpecificationModelToJson(this);

  ProductSpecification toEntity() =>
      ProductSpecification(key: key, value: value);
}

@JsonSerializable()
class ProductCertificationModel {
  @JsonKey(name: 'certification_id')
  final String certificationId;
  final String name;
  final String issuer;
  @JsonKey(name: 'certificate_number')
  final String certificateNumber;
  @JsonKey(name: 'issue_date')
  final String issueDate;
  @JsonKey(name: 'expiry_date')
  final String expiryDate;
  final bool verified;
  @JsonKey(name: 'badge_url')
  final String? badgeUrl;

  ProductCertificationModel({
    required this.certificationId,
    required this.name,
    required this.issuer,
    required this.certificateNumber,
    required this.issueDate,
    required this.expiryDate,
    required this.verified,
    this.badgeUrl,
  });

  factory ProductCertificationModel.fromJson(Map<String, dynamic> json) =>
      _$ProductCertificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCertificationModelToJson(this);

  ProductCertification toEntity() => ProductCertification(
        certificationId: certificationId,
        name: name,
        issuer: issuer,
        certificateNumber: certificateNumber,
        issueDate: DateTime.parse(issueDate),
        expiryDate: DateTime.parse(expiryDate),
        verified: verified,
        badgeUrl: badgeUrl,
      );
}

@JsonSerializable(explicitToJson: true)
class ProductRatingModel {
  final double average;
  final int count;
  final RatingDistributionModel distribution;

  ProductRatingModel(
      {required this.average, required this.count, required this.distribution});

  factory ProductRatingModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRatingModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductRatingModelToJson(this);

  ProductRating toEntity() => ProductRating(
      average: average, count: count, distribution: distribution.toEntity());
}

@JsonSerializable()
class RatingDistributionModel {
  @JsonKey(name: '5_star')
  final int fiveStar;
  @JsonKey(name: '4_star')
  final int fourStar;
  @JsonKey(name: '3_star')
  final int threeStar;
  @JsonKey(name: '2_star')
  final int twoStar;
  @JsonKey(name: '1_star')
  final int oneStar;

  RatingDistributionModel({
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  factory RatingDistributionModel.fromJson(Map<String, dynamic> json) =>
      _$RatingDistributionModelFromJson(json);
  Map<String, dynamic> toJson() => _$RatingDistributionModelToJson(this);

  RatingDistribution toEntity() => RatingDistribution(
        fiveStar: fiveStar,
        fourStar: fourStar,
        threeStar: threeStar,
        twoStar: twoStar,
        oneStar: oneStar,
      );
}

@JsonSerializable(explicitToJson: true)
class ProductReviewSummaryModel {
  @JsonKey(name: 'total_count')
  final int totalCount;
  @JsonKey(name: 'with_photos_count')
  final int withPhotosCount;
  @JsonKey(name: 'recent_reviews')
  final List<ProductReviewModel>? recentReviews;

  ProductReviewSummaryModel({
    required this.totalCount,
    required this.withPhotosCount,
    this.recentReviews,
  });

  factory ProductReviewSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductReviewSummaryModelToJson(this);

  ProductReviewSummary toEntity() => ProductReviewSummary(
        totalCount: totalCount,
        withPhotosCount: withPhotosCount,
        recentReviews: recentReviews?.map((e) => e.toEntity()).toList(),
      );
}

@JsonSerializable(explicitToJson: true)
class ProductReviewModel {
  @JsonKey(name: 'review_id')
  final String reviewId;
  final int rating;
  final String? title;
  final String comment;
  final ReviewBuyerModel buyer;
  final List<ReviewImageModel>? images;
  @JsonKey(name: 'helpful_count')
  final int helpfulCount;
  @JsonKey(name: 'is_helpful')
  final bool isHelpful;
  @JsonKey(name: 'seller_response')
  final SellerResponseModel? sellerResponse;
  @JsonKey(name: 'created_at')
  final String createdAt;

  ProductReviewModel({
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

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductReviewModelToJson(this);

  ProductReview toEntity() => ProductReview(
        reviewId: reviewId,
        rating: rating,
        title: title,
        comment: comment,
        buyer: buyer.toEntity(),
        images: images?.map((e) => e.toEntity()).toList(),
        helpfulCount: helpfulCount,
        isHelpful: isHelpful,
        sellerResponse: sellerResponse?.toEntity(),
        createdAt: DateTime.parse(createdAt),
      );
}

@JsonSerializable()
class ReviewBuyerModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  @JsonKey(name: 'is_verified_purchase')
  final bool isVerifiedPurchase;

  ReviewBuyerModel({
    required this.userId,
    required this.name,
    this.profilePicture,
    required this.isVerifiedPurchase,
  });

  factory ReviewBuyerModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewBuyerModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewBuyerModelToJson(this);

  ReviewBuyer toEntity() => ReviewBuyer(
        userId: userId,
        name: name,
        profilePicture: profilePicture,
        isVerifiedPurchase: isVerifiedPurchase,
      );
}

@JsonSerializable()
class ReviewImageModel {
  @JsonKey(name: 'image_id')
  final String imageId;
  final String url;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;

  ReviewImageModel(
      {required this.imageId, required this.url, required this.thumbnailUrl});

  factory ReviewImageModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewImageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewImageModelToJson(this);

  ReviewImage toEntity() =>
      ReviewImage(imageId: imageId, url: url, thumbnailUrl: thumbnailUrl);
}

@JsonSerializable()
class SellerResponseModel {
  final String comment;
  @JsonKey(name: 'responded_at')
  final String respondedAt;

  SellerResponseModel({required this.comment, required this.respondedAt});

  factory SellerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SellerResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SellerResponseModelToJson(this);

  SellerResponse toEntity() => SellerResponse(
      comment: comment, respondedAt: DateTime.parse(respondedAt));
}

@JsonSerializable()
class ProductLabelsModel {
  @JsonKey(name: 'is_organic')
  final bool isOrganic;
  @JsonKey(name: 'is_certified')
  final bool isCertified;
  @JsonKey(name: 'is_new')
  final bool isNew;
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @JsonKey(name: 'is_best_seller')
  final bool isBestSeller;
  @JsonKey(name: 'is_on_sale')
  final bool? isOnSale;

  ProductLabelsModel({
    required this.isOrganic,
    required this.isCertified,
    required this.isNew,
    required this.isFeatured,
    required this.isBestSeller,
    this.isOnSale,
  });

  factory ProductLabelsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductLabelsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductLabelsModelToJson(this);

  ProductLabels toEntity() => ProductLabels(
        isOrganic: isOrganic,
        isCertified: isCertified,
        isNew: isNew,
        isFeatured: isFeatured,
        isBestSeller: isBestSeller,
        isOnSale: isOnSale,
      );
}

@JsonSerializable()
class ProductAvailabilityModel {
  final String status;
  @JsonKey(name: 'available_date')
  final String? availableDate;
  @JsonKey(name: 'estimated_restock')
  final String? estimatedRestock;
  @JsonKey(name: 'low_stock_threshold')
  final int? lowStockThreshold;
  @JsonKey(name: 'is_low_stock')
  final bool? isLowStock;

  ProductAvailabilityModel({
    required this.status,
    this.availableDate,
    this.estimatedRestock,
    this.lowStockThreshold,
    this.isLowStock,
  });

  factory ProductAvailabilityModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAvailabilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductAvailabilityModelToJson(this);

  ProductAvailability toEntity() => ProductAvailability(
        status: status,
        availableDate:
            availableDate != null ? DateTime.parse(availableDate!) : null,
        estimatedRestock:
            estimatedRestock != null ? DateTime.parse(estimatedRestock!) : null,
        lowStockThreshold: lowStockThreshold,
        isLowStock: isLowStock,
      );
}

@JsonSerializable(explicitToJson: true)
class ProductDeliveryOptionsModel {
  @JsonKey(name: 'self_pickup')
  final SelfPickupOptionModel? selfPickup;
  @JsonKey(name: 'home_delivery')
  final HomeDeliveryOptionModel? homeDelivery;
  @JsonKey(name: 'same_day_delivery')
  final SameDayDeliveryOptionModel? sameDayDelivery;
  @JsonKey(name: 'express_delivery')
  final ExpressDeliveryOptionModel? expressDelivery;

  ProductDeliveryOptionsModel({
    this.selfPickup,
    this.homeDelivery,
    this.sameDayDelivery,
    this.expressDelivery,
  });

  factory ProductDeliveryOptionsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDeliveryOptionsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDeliveryOptionsModelToJson(this);

  ProductDeliveryOptions toEntity() => ProductDeliveryOptions(
        selfPickup: selfPickup?.toEntity(),
        homeDelivery: homeDelivery?.toEntity(),
        sameDayDelivery: sameDayDelivery?.toEntity(),
        expressDelivery: expressDelivery?.toEntity(),
      );
}

@JsonSerializable()
class SelfPickupOptionModel {
  final bool available;
  final String? address;
  final String? instructions;

  SelfPickupOptionModel(
      {required this.available, this.address, this.instructions});

  factory SelfPickupOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SelfPickupOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SelfPickupOptionModelToJson(this);

  SelfPickupOption toEntity() => SelfPickupOption(
      available: available, address: address, instructions: instructions);
}

@JsonSerializable()
class HomeDeliveryOptionModel {
  final bool available;
  final double? fee;
  @JsonKey(name: 'free_delivery_threshold')
  final double? freeDeliveryThreshold;
  @JsonKey(name: 'estimated_delivery')
  final String? estimatedDelivery;
  @JsonKey(name: 'delivery_areas')
  final List<String>? deliveryAreas;

  HomeDeliveryOptionModel({
    required this.available,
    this.fee,
    this.freeDeliveryThreshold,
    this.estimatedDelivery,
    this.deliveryAreas,
  });

  factory HomeDeliveryOptionModel.fromJson(Map<String, dynamic> json) =>
      _$HomeDeliveryOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeDeliveryOptionModelToJson(this);

  HomeDeliveryOption toEntity() => HomeDeliveryOption(
        available: available,
        fee: fee,
        freeDeliveryThreshold: freeDeliveryThreshold,
        estimatedDelivery: estimatedDelivery,
        deliveryAreas: deliveryAreas,
      );
}

@JsonSerializable()
class SameDayDeliveryOptionModel {
  final bool available;
  @JsonKey(name: 'cutoff_time')
  final String? cutoffTime;
  @JsonKey(name: 'additional_fee')
  final double? additionalFee;

  SameDayDeliveryOptionModel(
      {required this.available, this.cutoffTime, this.additionalFee});

  factory SameDayDeliveryOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SameDayDeliveryOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SameDayDeliveryOptionModelToJson(this);

  SameDayDeliveryOption toEntity() => SameDayDeliveryOption(
      available: available,
      cutoffTime: cutoffTime,
      additionalFee: additionalFee);
}

@JsonSerializable()
class ExpressDeliveryOptionModel {
  final bool available;
  final double? fee;
  @JsonKey(name: 'estimated_delivery')
  final String? estimatedDelivery;
  @JsonKey(name: 'cutoff_time')
  final String? cutoffTime;

  ExpressDeliveryOptionModel(
      {required this.available,
      this.fee,
      this.estimatedDelivery,
      this.cutoffTime});

  factory ExpressDeliveryOptionModel.fromJson(Map<String, dynamic> json) =>
      _$ExpressDeliveryOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpressDeliveryOptionModelToJson(this);

  ExpressDeliveryOption toEntity() => ExpressDeliveryOption(
        available: available,
        fee: fee,
        estimatedDelivery: estimatedDelivery,
        cutoffTime: cutoffTime,
      );
}

@JsonSerializable()
class BulkPricingModel {
  @JsonKey(name: 'min_quantity')
  final int minQuantity;
  @JsonKey(name: 'max_quantity')
  final int? maxQuantity;
  @JsonKey(name: 'price_per_unit')
  final double pricePerUnit;
  @JsonKey(name: 'discount_percentage')
  final double discountPercentage;

  BulkPricingModel({
    required this.minQuantity,
    this.maxQuantity,
    required this.pricePerUnit,
    required this.discountPercentage,
  });

  factory BulkPricingModel.fromJson(Map<String, dynamic> json) =>
      _$BulkPricingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BulkPricingModelToJson(this);

  BulkPricing toEntity() => BulkPricing(
        minQuantity: minQuantity,
        maxQuantity: maxQuantity,
        pricePerUnit: pricePerUnit,
        discountPercentage: discountPercentage,
      );
}

@JsonSerializable()
class RelatedProductModel {
  @JsonKey(name: 'product_id')
  final String productId;
  final String name;
  final double price;
  final String? image;
  final double? rating;

  RelatedProductModel(
      {required this.productId,
      required this.name,
      required this.price,
      this.image,
      this.rating});

  factory RelatedProductModel.fromJson(Map<String, dynamic> json) =>
      _$RelatedProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$RelatedProductModelToJson(this);

  RelatedProduct toEntity() => RelatedProduct(
      productId: productId,
      name: name,
      price: price,
      image: image,
      rating: rating);
}

@JsonSerializable()
class ProductStatsModel {
  final int views;
  @JsonKey(name: 'views_today')
  final int? viewsToday;
  final int favorites;
  @JsonKey(name: 'in_carts')
  final int? inCarts;
  final int orders;
  final int? inquiries;
  final int? shares;

  ProductStatsModel({
    required this.views,
    this.viewsToday,
    required this.favorites,
    this.inCarts,
    required this.orders,
    this.inquiries,
    this.shares,
  });

  factory ProductStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductStatsModelToJson(this);

  ProductStats toEntity() => ProductStats(
        views: views,
        viewsToday: viewsToday,
        favorites: favorites,
        inCarts: inCarts,
        orders: orders,
        inquiries: inquiries,
        shares: shares,
      );
}

@JsonSerializable()
class ProductPoliciesModel {
  @JsonKey(name: 'return_policy')
  final String? returnPolicy;
  @JsonKey(name: 'refund_policy')
  final String? refundPolicy;
  final String? warranty;

  ProductPoliciesModel({this.returnPolicy, this.refundPolicy, this.warranty});

  factory ProductPoliciesModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPoliciesModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductPoliciesModelToJson(this);

  ProductPolicies toEntity() => ProductPolicies(
      returnPolicy: returnPolicy,
      refundPolicy: refundPolicy,
      warranty: warranty);
}
