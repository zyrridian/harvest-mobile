import 'package:harvest_app/data/models/product_detail_model.dart';

abstract class ProductDetailRemoteDataSource {
  Future<ProductDetailModel> getProductDetail(String productId);
  Future<void> addToFavorites(String productId);
  Future<void> removeFromFavorites(String productId);
  Future<void> trackProductView(String productId);
}

class ProductDetailRemoteDataSourceImpl
    implements ProductDetailRemoteDataSource {
  // TODO: Replace with actual API service
  // final ApiService apiService;
  // ProductDetailRemoteDataSourceImpl({required this.apiService});

  @override
  Future<ProductDetailModel> getProductDetail(String productId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: Uncomment when API is ready
    // final response = await apiService.get('/products/$productId');
    // return ProductDetailModel.fromJson(response.data['data']);

    // Mock response based on API spec
    final mockResponse = {
      "product_id": productId,
      "name": "Organic Fresh Tomatoes",
      "slug": "organic-fresh-tomatoes",
      "description":
          "Fresh organic tomatoes grown in our pesticide-free farm. Hand-picked at peak ripeness to ensure maximum flavor and nutrition.",
      "long_description":
          "Our organic tomatoes are grown using traditional farming methods without the use of synthetic pesticides or fertilizers. Each tomato is carefully tended to from seedling to harvest, ensuring the highest quality produce. Perfect for salads, cooking, or eating fresh.",
      "category": {
        "category_id": "cat_123",
        "name": "Vegetables",
        "slug": "vegetables"
      },
      "subcategory": {
        "subcategory_id": "subcat_456",
        "name": "Tomatoes",
        "slug": "tomatoes"
      },
      "price": 15000,
      "currency": "IDR",
      "unit": "kg",
      "discount": {
        "discount_id": "disc_789",
        "type": "percentage",
        "value": 10,
        "discounted_price": 13500,
        "savings": 1500,
        "valid_from": "2025-10-01T00:00:00Z",
        "valid_until": "2025-10-15T23:59:59Z",
        "reason": "Flash Sale"
      },
      "stock_quantity": 100,
      "minimum_order": 1,
      "maximum_order": 50,
      "unit_weight": 1.0,
      "images": [
        {
          "image_id": "img_001",
          "url":
              "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=800",
          "thumbnail_url":
              "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=200",
          "medium_url":
              "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400",
          "alt_text": "Fresh organic tomatoes",
          "is_primary": true,
          "order": 1
        },
        {
          "image_id": "img_002",
          "url":
              "https://images.unsplash.com/photo-1546470427-227b91e0151f?w=800",
          "thumbnail_url":
              "https://images.unsplash.com/photo-1546470427-227b91e0151f?w=200",
          "medium_url":
              "https://images.unsplash.com/photo-1546470427-227b91e0151f?w=400",
          "alt_text": "Tomato close-up",
          "is_primary": false,
          "order": 2
        },
        {
          "image_id": "img_003",
          "url":
              "https://images.unsplash.com/photo-1561136594-7f68413baa99?w=800",
          "thumbnail_url":
              "https://images.unsplash.com/photo-1561136594-7f68413baa99?w=200",
          "medium_url":
              "https://images.unsplash.com/photo-1561136594-7f68413baa99?w=400",
          "alt_text": "Tomatoes on vine",
          "is_primary": false,
          "order": 3
        }
      ],
      "videos": [
        {
          "video_id": "vid_001",
          "url": "https://example.com/videos/farm-tour.mp4",
          "thumbnail_url":
              "https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400",
          "duration": 45,
          "title": "Farm tour and harvest"
        }
      ],
      "seller": {
        "user_id": "usr_9876543210fedcba",
        "name": "Green Valley Farm",
        "profile_picture":
            "https://ui-avatars.com/api/?name=Green+Valley+Farm&background=4CAF50&color=fff",
        "rating": 4.9,
        "reviews_count": 125,
        "verified": true,
        "verification_badge": "certified_organic",
        "location": {
          "city": "Bandung",
          "province": "West Java",
          "detailed_address": "Jl. Raya Lembang No. 45",
          "latitude": -6.914744,
          "longitude": 107.609810,
          "distance": 5.2
        },
        "response_rate": 98,
        "response_time": "< 30 minutes",
        "total_products": 30,
        "joined_since": "2023-03-15T00:00:00Z",
        "followers_count": 456
      },
      "specifications": [
        {"key": "Harvest Date", "value": "2025-10-08"},
        {"key": "Variety", "value": "Cherry Tomatoes"},
        {"key": "Size", "value": "Medium (50-60g per piece)"},
        {"key": "Color", "value": "Red"},
        {"key": "Storage", "value": "Room temperature for 3-5 days"},
        {"key": "Origin", "value": "Lembang, Bandung"}
      ],
      "certifications": [
        {
          "certification_id": "cert_456",
          "name": "Organic Certification",
          "issuer": "Organic Indonesia",
          "certificate_number": "ORG-2024-001",
          "issue_date": "2024-01-15T00:00:00Z",
          "expiry_date": "2026-01-15T00:00:00Z",
          "verified": true,
          "badge_url": "https://example.com/badges/organic.png"
        }
      ],
      "rating": {
        "average": 4.8,
        "count": 45,
        "distribution": {
          "5_star": 30,
          "4_star": 10,
          "3_star": 3,
          "2_star": 1,
          "1_star": 1
        }
      },
      "reviews": {
        "total_count": 45,
        "with_photos_count": 23,
        "recent_reviews": [
          {
            "review_id": "rev_123",
            "rating": 5,
            "title": "Excellent quality!",
            "comment":
                "Very fresh and delicious tomatoes. Packaging was excellent and delivery was fast. Will definitely buy again!",
            "buyer": {
              "user_id": "usr_buyer_123",
              "name": "Ahmad S.",
              "profile_picture":
                  "https://ui-avatars.com/api/?name=Ahmad+S&background=2196F3&color=fff",
              "is_verified_purchase": true
            },
            "images": [
              {
                "image_id": "rev_img_001",
                "url":
                    "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400",
                "thumbnail_url":
                    "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=100"
              }
            ],
            "helpful_count": 12,
            "is_helpful": false,
            "seller_response": {
              "comment":
                  "Thank you for your wonderful feedback! We're glad you enjoyed our tomatoes.",
              "responded_at": "2025-10-06T09:00:00Z"
            },
            "created_at": "2025-10-05T14:30:00Z"
          },
          {
            "review_id": "rev_124",
            "rating": 4,
            "title": "Good quality",
            "comment":
                "Fresh and tasty. Slightly smaller than expected but still good value.",
            "buyer": {
              "user_id": "usr_buyer_124",
              "name": "Siti R.",
              "profile_picture":
                  "https://ui-avatars.com/api/?name=Siti+R&background=FF9800&color=fff",
              "is_verified_purchase": true
            },
            "images": null,
            "helpful_count": 5,
            "is_helpful": false,
            "seller_response": null,
            "created_at": "2025-10-03T10:15:00Z"
          }
        ]
      },
      "tags": ["organic", "fresh", "local", "pesticide-free", "handpicked"],
      "labels": {
        "is_organic": true,
        "is_certified": true,
        "is_new": false,
        "is_featured": false,
        "is_best_seller": true,
        "is_on_sale": true
      },
      "harvest_date": "2025-10-08T00:00:00Z",
      "availability": {
        "status": "in_stock",
        "available_date": null,
        "estimated_restock": null,
        "low_stock_threshold": 10,
        "is_low_stock": false
      },
      "delivery_options": {
        "self_pickup": {
          "available": true,
          "address": "Jl. Raya Lembang No. 45, Bandung",
          "instructions": "Pick up between 8 AM - 5 PM"
        },
        "home_delivery": {
          "available": true,
          "fee": 15000,
          "free_delivery_threshold": 100000,
          "estimated_delivery": "1-2 days",
          "delivery_areas": ["Bandung", "Cimahi", "Bandung Barat"]
        },
        "same_day_delivery": {
          "available": false,
          "cutoff_time": null,
          "additional_fee": 0
        },
        "express_delivery": {
          "available": true,
          "fee": 25000,
          "estimated_delivery": "4-8 hours",
          "cutoff_time": "14:00"
        }
      },
      "bulk_pricing": [
        {
          "min_quantity": 10,
          "max_quantity": 19,
          "price_per_unit": 14000,
          "discount_percentage": 6.67
        },
        {
          "min_quantity": 20,
          "max_quantity": null,
          "price_per_unit": 13000,
          "discount_percentage": 13.33
        }
      ],
      "related_products": [
        {
          "product_id": "prd_related_001",
          "name": "Organic Cucumbers",
          "price": 12000,
          "image":
              "https://images.unsplash.com/photo-1568584711271-ee99f16fea66?w=200",
          "rating": 4.7
        },
        {
          "product_id": "prd_related_002",
          "name": "Fresh Bell Peppers",
          "price": 18000,
          "image":
              "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=200",
          "rating": 4.6
        },
        {
          "product_id": "prd_related_003",
          "name": "Organic Carrots",
          "price": 10000,
          "image":
              "https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=200",
          "rating": 4.8
        }
      ],
      "frequently_bought_together": [
        {
          "product_id": "prd_fbt_001",
          "name": "Fresh Lettuce",
          "price": 8000,
          "image":
              "https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=200",
          "rating": 4.5
        },
        {
          "product_id": "prd_fbt_002",
          "name": "Onions",
          "price": 7000,
          "image":
              "https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=200",
          "rating": 4.4
        }
      ],
      "stats": {
        "views": 1250,
        "views_today": 45,
        "favorites": 45,
        "in_carts": 12,
        "orders": 89,
        "inquiries": 12,
        "shares": 23
      },
      "policies": {
        "return_policy": "7-day return policy for damaged products",
        "refund_policy": "Full refund within 24 hours of delivery",
        "warranty": null
      },
      "created_at": "2025-09-15T10:00:00Z",
      "updated_at": "2025-10-08T14:30:00Z",
      "published_at": "2025-09-15T12:00:00Z",
      "is_favorite": false,
      "is_in_cart": false,
      "is_in_wishlist": false
    };

    return ProductDetailModel.fromJson(mockResponse);
  }

  @override
  Future<void> addToFavorites(String productId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: Uncomment when API is ready
    // await apiService.post('/products/$productId/favorite');
  }

  @override
  Future<void> removeFromFavorites(String productId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: Uncomment when API is ready
    // await apiService.delete('/products/$productId/favorite');
  }

  @override
  Future<void> trackProductView(String productId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // TODO: Uncomment when API is ready
    // await apiService.post('/products/$productId/views');
  }
}
