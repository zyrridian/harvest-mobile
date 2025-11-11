// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailModel _$ProductDetailModelFromJson(Map<String, dynamic> json) =>
    ProductDetailModel(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      longDescription: json['long_description'] as String?,
      category: ProductCategoryModel.fromJson(
          json['category'] as Map<String, dynamic>),
      subcategory: json['subcategory'] == null
          ? null
          : ProductSubcategoryModel.fromJson(
              json['subcategory'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      unit: json['unit'] as String,
      discount: json['discount'] == null
          ? null
          : ProductDiscountModel.fromJson(
              json['discount'] as Map<String, dynamic>),
      stockQuantity: (json['stock_quantity'] as num).toInt(),
      minimumOrder: (json['minimum_order'] as num).toInt(),
      maximumOrder: (json['maximum_order'] as num).toInt(),
      unitWeight: (json['unit_weight'] as num?)?.toDouble(),
      images: (json['images'] as List<dynamic>)
          .map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      videos: (json['videos'] as List<dynamic>?)
          ?.map((e) => ProductVideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      seller:
          ProductSellerModel.fromJson(json['seller'] as Map<String, dynamic>),
      specifications: (json['specifications'] as List<dynamic>?)
          ?.map((e) =>
              ProductSpecificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) =>
              ProductCertificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rating:
          ProductRatingModel.fromJson(json['rating'] as Map<String, dynamic>),
      reviews: json['reviews'] == null
          ? null
          : ProductReviewSummaryModel.fromJson(
              json['reviews'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      labels:
          ProductLabelsModel.fromJson(json['labels'] as Map<String, dynamic>),
      harvestDate: json['harvest_date'] as String?,
      availability: ProductAvailabilityModel.fromJson(
          json['availability'] as Map<String, dynamic>),
      deliveryOptions: ProductDeliveryOptionsModel.fromJson(
          json['delivery_options'] as Map<String, dynamic>),
      bulkPricing: (json['bulk_pricing'] as List<dynamic>?)
          ?.map((e) => BulkPricingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      relatedProducts: (json['related_products'] as List<dynamic>?)
          ?.map((e) => RelatedProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      frequentlyBoughtTogether: (json['frequently_bought_together']
              as List<dynamic>?)
          ?.map((e) => RelatedProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: ProductStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      policies: json['policies'] == null
          ? null
          : ProductPoliciesModel.fromJson(
              json['policies'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      publishedAt: json['published_at'] as String?,
      isFavorite: json['is_favorite'] as bool,
      isInCart: json['is_in_cart'] as bool,
      isInWishlist: json['is_in_wishlist'] as bool,
    );

Map<String, dynamic> _$ProductDetailModelToJson(ProductDetailModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'long_description': instance.longDescription,
      'category': instance.category.toJson(),
      'subcategory': instance.subcategory?.toJson(),
      'price': instance.price,
      'currency': instance.currency,
      'unit': instance.unit,
      'discount': instance.discount?.toJson(),
      'stock_quantity': instance.stockQuantity,
      'minimum_order': instance.minimumOrder,
      'maximum_order': instance.maximumOrder,
      'unit_weight': instance.unitWeight,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'videos': instance.videos?.map((e) => e.toJson()).toList(),
      'seller': instance.seller.toJson(),
      'specifications':
          instance.specifications?.map((e) => e.toJson()).toList(),
      'certifications':
          instance.certifications?.map((e) => e.toJson()).toList(),
      'rating': instance.rating.toJson(),
      'reviews': instance.reviews?.toJson(),
      'tags': instance.tags,
      'labels': instance.labels.toJson(),
      'harvest_date': instance.harvestDate,
      'availability': instance.availability.toJson(),
      'delivery_options': instance.deliveryOptions.toJson(),
      'bulk_pricing': instance.bulkPricing?.map((e) => e.toJson()).toList(),
      'related_products':
          instance.relatedProducts?.map((e) => e.toJson()).toList(),
      'frequently_bought_together':
          instance.frequentlyBoughtTogether?.map((e) => e.toJson()).toList(),
      'stats': instance.stats.toJson(),
      'policies': instance.policies?.toJson(),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'published_at': instance.publishedAt,
      'is_favorite': instance.isFavorite,
      'is_in_cart': instance.isInCart,
      'is_in_wishlist': instance.isInWishlist,
    };

ProductCategoryModel _$ProductCategoryModelFromJson(
        Map<String, dynamic> json) =>
    ProductCategoryModel(
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$ProductCategoryModelToJson(
        ProductCategoryModel instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'name': instance.name,
      'slug': instance.slug,
    };

ProductSubcategoryModel _$ProductSubcategoryModelFromJson(
        Map<String, dynamic> json) =>
    ProductSubcategoryModel(
      subcategoryId: json['subcategory_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$ProductSubcategoryModelToJson(
        ProductSubcategoryModel instance) =>
    <String, dynamic>{
      'subcategory_id': instance.subcategoryId,
      'name': instance.name,
      'slug': instance.slug,
    };

ProductDiscountModel _$ProductDiscountModelFromJson(
        Map<String, dynamic> json) =>
    ProductDiscountModel(
      discountId: json['discount_id'] as String?,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num).toDouble(),
      savings: (json['savings'] as num?)?.toDouble(),
      validFrom: json['valid_from'] as String?,
      validUntil: json['valid_until'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ProductDiscountModelToJson(
        ProductDiscountModel instance) =>
    <String, dynamic>{
      'discount_id': instance.discountId,
      'type': instance.type,
      'value': instance.value,
      'discounted_price': instance.discountedPrice,
      'savings': instance.savings,
      'valid_from': instance.validFrom,
      'valid_until': instance.validUntil,
      'reason': instance.reason,
    };

ProductImageModel _$ProductImageModelFromJson(Map<String, dynamic> json) =>
    ProductImageModel(
      imageId: json['image_id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      mediumUrl: json['medium_url'] as String?,
      altText: json['alt_text'] as String?,
      isPrimary: json['is_primary'] as bool,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$ProductImageModelToJson(ProductImageModel instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'medium_url': instance.mediumUrl,
      'alt_text': instance.altText,
      'is_primary': instance.isPrimary,
      'order': instance.order,
    };

ProductVideoModel _$ProductVideoModelFromJson(Map<String, dynamic> json) =>
    ProductVideoModel(
      videoId: json['video_id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      duration: (json['duration'] as num).toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$ProductVideoModelToJson(ProductVideoModel instance) =>
    <String, dynamic>{
      'video_id': instance.videoId,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'duration': instance.duration,
      'title': instance.title,
    };

ProductSellerModel _$ProductSellerModelFromJson(Map<String, dynamic> json) =>
    ProductSellerModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: (json['reviews_count'] as num?)?.toInt(),
      verified: json['verified'] as bool,
      verificationBadge: json['verification_badge'] as String?,
      location: SellerLocationModel.fromJson(
          json['location'] as Map<String, dynamic>),
      responseRate: (json['response_rate'] as num?)?.toInt(),
      responseTime: json['response_time'] as String?,
      totalProducts: (json['total_products'] as num?)?.toInt(),
      joinedSince: json['joined_since'] as String?,
      followersCount: (json['followers_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductSellerModelToJson(ProductSellerModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
      'rating': instance.rating,
      'reviews_count': instance.reviewsCount,
      'verified': instance.verified,
      'verification_badge': instance.verificationBadge,
      'location': instance.location.toJson(),
      'response_rate': instance.responseRate,
      'response_time': instance.responseTime,
      'total_products': instance.totalProducts,
      'joined_since': instance.joinedSince,
      'followers_count': instance.followersCount,
    };

SellerLocationModel _$SellerLocationModelFromJson(Map<String, dynamic> json) =>
    SellerLocationModel(
      city: json['city'] as String,
      province: json['province'] as String,
      detailedAddress: json['detailed_address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SellerLocationModelToJson(
        SellerLocationModel instance) =>
    <String, dynamic>{
      'city': instance.city,
      'province': instance.province,
      'detailed_address': instance.detailedAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
    };

ProductSpecificationModel _$ProductSpecificationModelFromJson(
        Map<String, dynamic> json) =>
    ProductSpecificationModel(
      key: json['key'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$ProductSpecificationModelToJson(
        ProductSpecificationModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
    };

ProductCertificationModel _$ProductCertificationModelFromJson(
        Map<String, dynamic> json) =>
    ProductCertificationModel(
      certificationId: json['certification_id'] as String,
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      certificateNumber: json['certificate_number'] as String,
      issueDate: json['issue_date'] as String,
      expiryDate: json['expiry_date'] as String,
      verified: json['verified'] as bool,
      badgeUrl: json['badge_url'] as String?,
    );

Map<String, dynamic> _$ProductCertificationModelToJson(
        ProductCertificationModel instance) =>
    <String, dynamic>{
      'certification_id': instance.certificationId,
      'name': instance.name,
      'issuer': instance.issuer,
      'certificate_number': instance.certificateNumber,
      'issue_date': instance.issueDate,
      'expiry_date': instance.expiryDate,
      'verified': instance.verified,
      'badge_url': instance.badgeUrl,
    };

ProductRatingModel _$ProductRatingModelFromJson(Map<String, dynamic> json) =>
    ProductRatingModel(
      average: (json['average'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
      distribution: RatingDistributionModel.fromJson(
          json['distribution'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductRatingModelToJson(ProductRatingModel instance) =>
    <String, dynamic>{
      'average': instance.average,
      'count': instance.count,
      'distribution': instance.distribution.toJson(),
    };

RatingDistributionModel _$RatingDistributionModelFromJson(
        Map<String, dynamic> json) =>
    RatingDistributionModel(
      fiveStar: (json['5_star'] as num).toInt(),
      fourStar: (json['4_star'] as num).toInt(),
      threeStar: (json['3_star'] as num).toInt(),
      twoStar: (json['2_star'] as num).toInt(),
      oneStar: (json['1_star'] as num).toInt(),
    );

Map<String, dynamic> _$RatingDistributionModelToJson(
        RatingDistributionModel instance) =>
    <String, dynamic>{
      '5_star': instance.fiveStar,
      '4_star': instance.fourStar,
      '3_star': instance.threeStar,
      '2_star': instance.twoStar,
      '1_star': instance.oneStar,
    };

ProductReviewSummaryModel _$ProductReviewSummaryModelFromJson(
        Map<String, dynamic> json) =>
    ProductReviewSummaryModel(
      totalCount: (json['total_count'] as num).toInt(),
      withPhotosCount: (json['with_photos_count'] as num).toInt(),
      recentReviews: (json['recent_reviews'] as List<dynamic>?)
          ?.map((e) => ProductReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductReviewSummaryModelToJson(
        ProductReviewSummaryModel instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'with_photos_count': instance.withPhotosCount,
      'recent_reviews': instance.recentReviews?.map((e) => e.toJson()).toList(),
    };

ProductReviewModel _$ProductReviewModelFromJson(Map<String, dynamic> json) =>
    ProductReviewModel(
      reviewId: json['review_id'] as String,
      rating: (json['rating'] as num).toInt(),
      title: json['title'] as String?,
      comment: json['comment'] as String,
      buyer: ReviewBuyerModel.fromJson(json['buyer'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ReviewImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      helpfulCount: (json['helpful_count'] as num).toInt(),
      isHelpful: json['is_helpful'] as bool,
      sellerResponse: json['seller_response'] == null
          ? null
          : SellerResponseModel.fromJson(
              json['seller_response'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ProductReviewModelToJson(ProductReviewModel instance) =>
    <String, dynamic>{
      'review_id': instance.reviewId,
      'rating': instance.rating,
      'title': instance.title,
      'comment': instance.comment,
      'buyer': instance.buyer.toJson(),
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'helpful_count': instance.helpfulCount,
      'is_helpful': instance.isHelpful,
      'seller_response': instance.sellerResponse?.toJson(),
      'created_at': instance.createdAt,
    };

ReviewBuyerModel _$ReviewBuyerModelFromJson(Map<String, dynamic> json) =>
    ReviewBuyerModel(
      userId: json['user_id'] as String,
      name: json['name'] as String,
      profilePicture: json['profile_picture'] as String?,
      isVerifiedPurchase: json['is_verified_purchase'] as bool,
    );

Map<String, dynamic> _$ReviewBuyerModelToJson(ReviewBuyerModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
      'is_verified_purchase': instance.isVerifiedPurchase,
    };

ReviewImageModel _$ReviewImageModelFromJson(Map<String, dynamic> json) =>
    ReviewImageModel(
      imageId: json['image_id'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
    );

Map<String, dynamic> _$ReviewImageModelToJson(ReviewImageModel instance) =>
    <String, dynamic>{
      'image_id': instance.imageId,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
    };

SellerResponseModel _$SellerResponseModelFromJson(Map<String, dynamic> json) =>
    SellerResponseModel(
      comment: json['comment'] as String,
      respondedAt: json['responded_at'] as String,
    );

Map<String, dynamic> _$SellerResponseModelToJson(
        SellerResponseModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'responded_at': instance.respondedAt,
    };

ProductLabelsModel _$ProductLabelsModelFromJson(Map<String, dynamic> json) =>
    ProductLabelsModel(
      isOrganic: json['is_organic'] as bool,
      isCertified: json['is_certified'] as bool,
      isNew: json['is_new'] as bool,
      isFeatured: json['is_featured'] as bool,
      isBestSeller: json['is_best_seller'] as bool,
      isOnSale: json['is_on_sale'] as bool?,
    );

Map<String, dynamic> _$ProductLabelsModelToJson(ProductLabelsModel instance) =>
    <String, dynamic>{
      'is_organic': instance.isOrganic,
      'is_certified': instance.isCertified,
      'is_new': instance.isNew,
      'is_featured': instance.isFeatured,
      'is_best_seller': instance.isBestSeller,
      'is_on_sale': instance.isOnSale,
    };

ProductAvailabilityModel _$ProductAvailabilityModelFromJson(
        Map<String, dynamic> json) =>
    ProductAvailabilityModel(
      status: json['status'] as String,
      availableDate: json['available_date'] as String?,
      estimatedRestock: json['estimated_restock'] as String?,
      lowStockThreshold: (json['low_stock_threshold'] as num?)?.toInt(),
      isLowStock: json['is_low_stock'] as bool?,
    );

Map<String, dynamic> _$ProductAvailabilityModelToJson(
        ProductAvailabilityModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'available_date': instance.availableDate,
      'estimated_restock': instance.estimatedRestock,
      'low_stock_threshold': instance.lowStockThreshold,
      'is_low_stock': instance.isLowStock,
    };

ProductDeliveryOptionsModel _$ProductDeliveryOptionsModelFromJson(
        Map<String, dynamic> json) =>
    ProductDeliveryOptionsModel(
      selfPickup: json['self_pickup'] == null
          ? null
          : SelfPickupOptionModel.fromJson(
              json['self_pickup'] as Map<String, dynamic>),
      homeDelivery: json['home_delivery'] == null
          ? null
          : HomeDeliveryOptionModel.fromJson(
              json['home_delivery'] as Map<String, dynamic>),
      sameDayDelivery: json['same_day_delivery'] == null
          ? null
          : SameDayDeliveryOptionModel.fromJson(
              json['same_day_delivery'] as Map<String, dynamic>),
      expressDelivery: json['express_delivery'] == null
          ? null
          : ExpressDeliveryOptionModel.fromJson(
              json['express_delivery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductDeliveryOptionsModelToJson(
        ProductDeliveryOptionsModel instance) =>
    <String, dynamic>{
      'self_pickup': instance.selfPickup?.toJson(),
      'home_delivery': instance.homeDelivery?.toJson(),
      'same_day_delivery': instance.sameDayDelivery?.toJson(),
      'express_delivery': instance.expressDelivery?.toJson(),
    };

SelfPickupOptionModel _$SelfPickupOptionModelFromJson(
        Map<String, dynamic> json) =>
    SelfPickupOptionModel(
      available: json['available'] as bool,
      address: json['address'] as String?,
      instructions: json['instructions'] as String?,
    );

Map<String, dynamic> _$SelfPickupOptionModelToJson(
        SelfPickupOptionModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'address': instance.address,
      'instructions': instance.instructions,
    };

HomeDeliveryOptionModel _$HomeDeliveryOptionModelFromJson(
        Map<String, dynamic> json) =>
    HomeDeliveryOptionModel(
      available: json['available'] as bool,
      fee: (json['fee'] as num?)?.toDouble(),
      freeDeliveryThreshold:
          (json['free_delivery_threshold'] as num?)?.toDouble(),
      estimatedDelivery: json['estimated_delivery'] as String?,
      deliveryAreas: (json['delivery_areas'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HomeDeliveryOptionModelToJson(
        HomeDeliveryOptionModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'fee': instance.fee,
      'free_delivery_threshold': instance.freeDeliveryThreshold,
      'estimated_delivery': instance.estimatedDelivery,
      'delivery_areas': instance.deliveryAreas,
    };

SameDayDeliveryOptionModel _$SameDayDeliveryOptionModelFromJson(
        Map<String, dynamic> json) =>
    SameDayDeliveryOptionModel(
      available: json['available'] as bool,
      cutoffTime: json['cutoff_time'] as String?,
      additionalFee: (json['additional_fee'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SameDayDeliveryOptionModelToJson(
        SameDayDeliveryOptionModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'cutoff_time': instance.cutoffTime,
      'additional_fee': instance.additionalFee,
    };

ExpressDeliveryOptionModel _$ExpressDeliveryOptionModelFromJson(
        Map<String, dynamic> json) =>
    ExpressDeliveryOptionModel(
      available: json['available'] as bool,
      fee: (json['fee'] as num?)?.toDouble(),
      estimatedDelivery: json['estimated_delivery'] as String?,
      cutoffTime: json['cutoff_time'] as String?,
    );

Map<String, dynamic> _$ExpressDeliveryOptionModelToJson(
        ExpressDeliveryOptionModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'fee': instance.fee,
      'estimated_delivery': instance.estimatedDelivery,
      'cutoff_time': instance.cutoffTime,
    };

BulkPricingModel _$BulkPricingModelFromJson(Map<String, dynamic> json) =>
    BulkPricingModel(
      minQuantity: (json['min_quantity'] as num).toInt(),
      maxQuantity: (json['max_quantity'] as num?)?.toInt(),
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$BulkPricingModelToJson(BulkPricingModel instance) =>
    <String, dynamic>{
      'min_quantity': instance.minQuantity,
      'max_quantity': instance.maxQuantity,
      'price_per_unit': instance.pricePerUnit,
      'discount_percentage': instance.discountPercentage,
    };

RelatedProductModel _$RelatedProductModelFromJson(Map<String, dynamic> json) =>
    RelatedProductModel(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RelatedProductModelToJson(
        RelatedProductModel instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'price': instance.price,
      'image': instance.image,
      'rating': instance.rating,
    };

ProductStatsModel _$ProductStatsModelFromJson(Map<String, dynamic> json) =>
    ProductStatsModel(
      views: (json['views'] as num).toInt(),
      viewsToday: (json['views_today'] as num?)?.toInt(),
      favorites: (json['favorites'] as num).toInt(),
      inCarts: (json['in_carts'] as num?)?.toInt(),
      orders: (json['orders'] as num).toInt(),
      inquiries: (json['inquiries'] as num?)?.toInt(),
      shares: (json['shares'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductStatsModelToJson(ProductStatsModel instance) =>
    <String, dynamic>{
      'views': instance.views,
      'views_today': instance.viewsToday,
      'favorites': instance.favorites,
      'in_carts': instance.inCarts,
      'orders': instance.orders,
      'inquiries': instance.inquiries,
      'shares': instance.shares,
    };

ProductPoliciesModel _$ProductPoliciesModelFromJson(
        Map<String, dynamic> json) =>
    ProductPoliciesModel(
      returnPolicy: json['return_policy'] as String?,
      refundPolicy: json['refund_policy'] as String?,
      warranty: json['warranty'] as String?,
    );

Map<String, dynamic> _$ProductPoliciesModelToJson(
        ProductPoliciesModel instance) =>
    <String, dynamic>{
      'return_policy': instance.returnPolicy,
      'refund_policy': instance.refundPolicy,
      'warranty': instance.warranty,
    };
