# API Endpoints Documentation

This document defines all REST API endpoints needed for the Harvest Mobile App backend (Next.js project).

**Base URL**: `/api/v1`

---

## Table of Contents

1. [Authentication](#authentication)
2. [User Profile](#user-profile)
3. [Products](#products)
4. [Farmers](#farmers)
5. [Categories](#categories)
6. [Cart](#cart)
7. [Orders](#orders)
8. [Addresses](#addresses)
9. [Reviews](#reviews)
10. [Search](#search)
11. [Messaging](#messaging)
12. [Notifications](#notifications)
13. [Community](#community)
14. [Utility](#utility)
15. [Harvest Schedules](#harvest-schedules) _(NEW)_
16. [Pre-Orders](#pre-orders) _(NEW)_
17. [Farmer Subscriptions](#farmer-subscriptions) _(NEW)_

---

## Authentication

### POST /auth/register

Register a new user account.

**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "securepassword123",
  "name": "John Doe",
  "phone_number": "+6281234567890" // optional
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Registration successful",
  "data": {
    "user": {
      "id": "usr_1234567890abcdef",
      "email": "user@example.com",
      "name": "John Doe",
      "phone_number": "+6281234567890",
      "avatar_url": null,
      "created_at": "2025-10-10T10:00:00Z",
      "updated_at": "2025-10-10T10:00:00Z"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

### POST /auth/login

Authenticate user and get access token.

**Request Body:**

```json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "user": {
      "id": "usr_1234567890abcdef",
      "email": "user@example.com",
      "name": "John Doe",
      "phone_number": "+6281234567890",
      "avatar_url": "https://cdn.farmmarket.com/avatars/usr_123.jpg",
      "created_at": "2025-10-10T10:00:00Z",
      "updated_at": "2025-10-10T10:00:00Z"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

### POST /auth/logout

Logout current user session.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Logged out successfully"
}
```

### POST /auth/refresh

Refresh access token using refresh token.

**Request Body:**

```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 3600
  }
}
```

### GET /auth/me

Get current authenticated user information.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "id": "usr_1234567890abcdef",
    "email": "user@example.com",
    "name": "John Doe",
    "phone_number": "+6281234567890",
    "avatar_url": "https://cdn.farmmarket.com/avatars/usr_123.jpg",
    "created_at": "2025-10-10T10:00:00Z",
    "updated_at": "2025-10-10T10:00:00Z"
  }
}
```

---

## User Profile

### GET /users/profile

Get user profile information.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "user_id": "usr_1234567890abcdef",
    "name": "John Doe",
    "email": "user@example.com",
    "phone_number": "+6281234567890",
    "avatar_url": "https://cdn.farmmarket.com/avatars/usr_123.jpg",
    "bio": "I love fresh organic produce!",
    "followers_count": 125,
    "joined_since": "2024-01-15T00:00:00Z"
  }
}
```

### PUT /users/profile

Update user profile information.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "name": "John Doe Updated",
  "phone_number": "+6281234567890",
  "bio": "Updated bio text"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Profile updated successfully",
  "data": {
    "user_id": "usr_1234567890abcdef",
    "name": "John Doe Updated",
    "email": "user@example.com",
    "phone_number": "+6281234567890",
    "bio": "Updated bio text",
    "updated_at": "2025-10-10T10:30:00Z"
  }
}
```

### PUT /users/avatar

Update user avatar image.

**Headers:**

```
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
```

**Request Body (Form Data):**

```
avatar: [image file]
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Avatar updated successfully",
  "data": {
    "avatar_url": "https://cdn.farmmarket.com/avatars/usr_123_new.jpg"
  }
}
```

---

## Products

### GET /products

Get list of products with filters and pagination.

**Query Parameters:**

- `page` (number, default: 1) - Page number
- `limit` (number, default: 20) - Items per page
- `category` (string) - Filter by category ID
- `seller_id` (string) - Filter by seller/farmer ID
- `is_organic` (boolean) - Filter organic products
- `min_price` (number) - Minimum price filter
- `max_price` (number) - Maximum price filter
- `sort_by` (string) - Sort by: `price`, `rating`, `newest`, `popular`
- `order` (string) - Sort order: `asc`, `desc`

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "prd_123",
      "name": "Organic Fresh Tomatoes",
      "description": "Fresh organic tomatoes from local farms",
      "category": "Vegetables",
      "price": 15000,
      "unit": "kg",
      "image_url": "https://cdn.farmmarket.com/products/prd_123_001.jpg",
      "images": ["https://cdn.farmmarket.com/products/prd_123_001.jpg"],
      "is_organic": true,
      "is_available": true,
      "stock": 120,
      "discount": 10,
      "rating": 4.8,
      "review_count": 45,
      "farmer_id": "usr_987",
      "farmer_name": "Green Valley Farm",
      "harvest_date": "2025-10-08T00:00:00Z",
      "tags": ["organic", "fresh", "local"],
      "created_at": "2025-09-01T00:00:00Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 10,
    "total_items": 200,
    "items_per_page": 20,
    "has_next": true,
    "has_previous": false
  }
}
```

### GET /products/:id

Get detailed information about a specific product.

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "product_id": "prd_123",
    "name": "Organic Fresh Tomatoes",
    "slug": "organic-fresh-tomatoes",
    "description": "Fresh organic tomatoes grown in our pesticide-free farm.",
    "long_description": "Our organic tomatoes are grown using traditional farming methods...",
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
        "url": "https://cdn.farmmarket.com/products/img_001.jpg",
        "thumbnail_url": "https://cdn.farmmarket.com/products/thumb_img_001.jpg",
        "medium_url": "https://cdn.farmmarket.com/products/medium_img_001.jpg",
        "alt_text": "Fresh organic tomatoes",
        "is_primary": true,
        "order": 1
      }
    ],
    "videos": [
      {
        "video_id": "vid_001",
        "url": "https://cdn.farmmarket.com/videos/vid_001.mp4",
        "thumbnail_url": "https://cdn.farmmarket.com/videos/thumb_vid_001.jpg",
        "duration": 45,
        "title": "Farm tour and harvest"
      }
    ],
    "seller": {
      "user_id": "usr_987",
      "name": "Green Valley Farm",
      "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg",
      "rating": 4.9,
      "reviews_count": 125,
      "verified": true,
      "verification_badge": "certified_organic",
      "location": {
        "city": "Bandung",
        "province": "West Java",
        "latitude": -6.914744,
        "longitude": 107.60981,
        "distance": 5.2
      },
      "response_rate": 98,
      "response_time": "< 30 minutes",
      "total_products": 30,
      "joined_since": "2023-03-15T00:00:00Z",
      "followers_count": 456
    },
    "specifications": [
      { "key": "Harvest Date", "value": "2025-10-08" },
      { "key": "Variety", "value": "Cherry Tomatoes" },
      { "key": "Size", "value": "Medium (50-60g per piece)" }
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
        "badge_url": "https://cdn.farmmarket.com/badges/organic.png"
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
    }
  }
}
```

### POST /products/:id/favorite

Add product to favorites.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Product added to favorites",
  "data": {
    "product_id": "prd_123",
    "is_favorited": true
  }
}
```

### DELETE /products/:id/favorite

Remove product from favorites.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Product removed from favorites",
  "data": {
    "product_id": "prd_123",
    "is_favorited": false
  }
}
```

### POST /products/:id/view

Track product view for analytics.

**Response (200):**

```json
{
  "status": "success",
  "message": "View tracked"
}
```

---

## Farmers

### GET /farmers

Get list of farmers/sellers with filters.

**Query Parameters:**

- `page` (number, default: 1) - Page number
- `limit` (number, default: 20) - Items per page
- `query` (string) - Search by name or description
- `specialties` (string) - Comma-separated specialties
- `has_map_feature` (boolean) - Filter farmers with map feature
- `max_distance` (number) - Maximum distance in km
- `min_rating` (number) - Minimum rating filter

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "farmer_001",
      "name": "Green Valley Farm",
      "description": "Organic farm specializing in vegetables",
      "profile_image": "https://cdn.farmmarket.com/farmers/farmer_001.jpg",
      "cover_image": "https://cdn.farmmarket.com/farmers/cover_001.jpg",
      "latitude": -6.914744,
      "longitude": 107.60981,
      "address": "Jl. Raya Lembang No. 45",
      "city": "Bandung",
      "state": "West Java",
      "rating": 4.9,
      "total_reviews": 125,
      "total_products": 30,
      "specialties": ["Vegetables", "Organic Farming"],
      "is_verified": true,
      "has_map_feature": true,
      "phone_number": "+6281234567890",
      "email": "contact@greenvalley.com",
      "joined_date": "2023-03-15T00:00:00Z",
      "is_online": true,
      "distance": 5.2
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 5,
    "total_items": 100,
    "items_per_page": 20
  }
}
```

### GET /farmers/:id

Get detailed farmer profile.

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "id": "farmer_001",
    "name": "Green Valley Farm",
    "description": "Organic farm specializing in vegetables and herbs...",
    "profile_image": "https://cdn.farmmarket.com/farmers/farmer_001.jpg",
    "cover_image": "https://cdn.farmmarket.com/farmers/cover_001.jpg",
    "latitude": -6.914744,
    "longitude": 107.60981,
    "address": "Jl. Raya Lembang No. 45",
    "city": "Bandung",
    "state": "West Java",
    "rating": 4.9,
    "total_reviews": 125,
    "total_products": 30,
    "specialties": ["Vegetables", "Organic Farming", "Herbs"],
    "is_verified": true,
    "verification_badge": "certified_organic",
    "has_map_feature": true,
    "phone_number": "+6281234567890",
    "email": "contact@greenvalley.com",
    "joined_date": "2023-03-15T00:00:00Z",
    "is_online": true,
    "distance": 5.2,
    "response_rate": 98,
    "response_time": "< 30 minutes",
    "followers_count": 456
  }
}
```

### GET /farmers/:id/products

Get products from a specific farmer.

**Query Parameters:**

- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "prd_001",
      "name": "Organic Tomatoes",
      "description": "Fresh organic tomatoes",
      "category": "Vegetables",
      "price": 15000,
      "unit": "kg",
      "image_url": "https://cdn.farmmarket.com/products/prd_001.jpg",
      "is_organic": true,
      "is_available": true,
      "stock": 50,
      "discount": 20,
      "rating": 4.8,
      "review_count": 45
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 3,
    "total_items": 30
  }
}
```

### GET /farmers/:id/reviews

Get reviews for a specific farmer.

**Query Parameters:**

- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "rev_001",
      "user_id": "user_001",
      "user_name": "John Doe",
      "user_avatar": null,
      "rating": 5.0,
      "comment": "Great quality products! Fresh and organic.",
      "images": [],
      "created_at": "2025-11-08T00:00:00Z",
      "is_verified_purchase": true,
      "helpful_count": 12,
      "is_helpful": false
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 13,
    "total_items": 125
  }
}
```

### GET /farmers/nearby

Get nearby farmers based on location.

**Query Parameters:**

- `latitude` (number, required) - User's latitude
- `longitude` (number, required) - User's longitude
- `radius` (number, default: 10) - Search radius in km
- `limit` (number, default: 20) - Max results

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "farmer_001",
      "name": "Green Valley Farm",
      "profile_image": "https://cdn.farmmarket.com/farmers/farmer_001.jpg",
      "latitude": -6.914744,
      "longitude": 107.609810,
      "city": "Bandung",
      "rating": 4.9,
      "distance": 2.3,
      "is_verified": true
  ]
}
```

---

## Categories

### GET /categories

Get all product categories.

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "vegetables",
      "name": "Vegetables",
      "slug": "vegetables",
      "description": "Fresh organic vegetables from local farmers",
      "emoji": "🥦",
      "gradient_colors": ["#D4E2D4", "#B8C6B8"],
      "product_count": 45,
      "display_order": 1,
      "is_active": true
    },
    {
      "id": "fruits",
      "name": "Fruits",
      "slug": "fruits",
      "description": "Seasonal fruits picked at peak ripeness",
      "emoji": "🍓",
      "gradient_colors": ["#FFE5D9", "#FFD1BC"],
      "product_count": 38,
      "display_order": 2,
      "is_active": true
    }
  ]
}
```

### GET /categories/:id

Get category details.

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "id": "vegetables",
    "name": "Vegetables",
    "slug": "vegetables",
    "description": "Fresh organic vegetables from local farmers",
    "emoji": "🥦",
    "gradient_colors": ["#D4E2D4", "#B8C6B8"],
    "product_count": 45,
    "display_order": 1,
    "is_active": true
  }
}
```

### GET /categories/:id/products

Get products in a specific category.

**Query Parameters:**

- `page` (number) - Page number
- `limit` (number) - Items per page
- `sort_by` (string) - Sort by: `price`, `rating`, `newest`

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "veg_001",
      "name": "Organic Spinach",
      "category_id": "vegetables",
      "category_name": "Vegetables",
      "seller_id": "farmer_001",
      "seller_name": "Green Valley Farm",
      "price": 3.99,
      "unit": "bunch",
      "image_url": "https://cdn.farmmarket.com/products/veg_001.jpg",
      "rating": 4.8,
      "review_count": 124,
      "is_organic": true,
      "stock_quantity": 45,
      "discount": "10% OFF"
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 5,
    "total_items": 45
  }
}
```

---

## Cart

### GET /cart

Get user's shopping cart.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "cart_id": "cart_1234567890",
    "items": [
      {
        "cart_item_id": "ci_001",
        "product": {
          "product_id": "prd_123",
          "name": "Organic Fresh Tomatoes",
          "price": 15000,
          "discount": {
            "discounted_price": 13500,
            "value": 10,
            "valid_until": "2025-10-15T23:59:59Z"
          },
          "image": "https://cdn.farmmarket.com/products/prd_123_001.jpg",
          "unit": "kg",
          "stock_quantity": 100,
          "minimum_order": 1,
          "maximum_order": 50,
          "seller": {
            "user_id": "usr_987",
            "name": "Green Valley Farm",
            "location": { "city": "Bandung" }
          },
          "availability": { "status": "in_stock" }
        },
        "quantity": 3,
        "unit_price": 15000,
        "discount_price": 13500,
        "subtotal": 40500,
        "notes": "Please select ripe ones",
        "is_selected": true,
        "is_available": true,
        "added_at": "2025-10-08T10:00:00Z",
        "updated_at": "2025-10-09T09:00:00Z"
      }
    ],
    "grouped_by_seller": [
      {
        "seller": {
          "user_id": "usr_987",
          "name": "Green Valley Farm",
          "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg",
          "location": { "city": "Bandung" }
        },
        "items": [],
        "subtotal": 64500,
        "delivery_fee": 15000,
        "free_delivery_threshold": 100000,
        "is_eligible_free_delivery": false,
        "amount_for_free_delivery": 35500,
        "total": 79500
      }
    ],
    "summary": {
      "total_items": 2,
      "total_quantity": 5,
      "subtotal": 64500,
      "total_discount": 4500,
      "total_delivery_fee": 15000,
      "service_fee": 2000,
      "grand_total": 81500
    },
    "unavailable_items": [],
    "recommendations": [
      {
        "product_id": "prd_789",
        "name": "Fresh Lettuce",
        "price": 8000,
        "image": "https://cdn.farmmarket.com/products/prd_789.jpg",
        "reason": "frequently_bought_together"
      }
    ],
    "updated_at": "2025-10-09T09:00:00Z"
  }
}
```

### POST /cart/items

Add item to cart.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "product_id": "prd_123",
  "quantity": 3,
  "notes": "Please select ripe ones"
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Product added to cart",
  "data": {
    "cart_item_id": "ci_new",
    "product_id": "prd_123",
    "quantity": 3,
    "subtotal": 45000,
    "cart_total_items": 3,
    "cart_grand_total": 120000
  }
}
```

### PUT /cart/items/:id

Update cart item quantity or notes.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "quantity": 5,
  "notes": "Updated notes"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Cart item updated",
  "data": {
    "cart_item_id": "ci_001",
    "quantity": 5,
    "subtotal": 75000,
    "cart_grand_total": 150000
  }
}
```

### DELETE /cart/items/:id

Remove item from cart.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Item removed from cart",
  "data": {
    "cart_total_items": 1,
    "cart_grand_total": 24000
  }
}
```

### PATCH /cart/items/:id/select

Toggle cart item selection for checkout.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "is_selected": true
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Item selection updated",
  "data": {
    "cart_item_id": "ci_001",
    "is_selected": true,
    "selected_items_total": 64500
  }
}
```

### DELETE /cart

Clear entire cart.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Cart cleared successfully"
}
```

---

## Orders

### GET /orders

Get user's orders list.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `role` (string) - User role: `buyer`, `seller`
- `status` (string) - Filter by status: `pending_payment`, `paid`, `processing`, `shipped`, `delivered`, `cancelled`
- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "orders": [
      {
        "order_id": "ord_1234567890abcdef",
        "order_number": "FM20251009001",
        "status": "shipped",
        "seller": {
          "user_id": "usr_987",
          "name": "Green Valley Farm",
          "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg"
        },
        "items_preview": [
          {
            "product_id": "prd_123",
            "name": "Organic Fresh Tomatoes",
            "image": "https://cdn.farmmarket.com/products/prd_123_001.jpg",
            "quantity": 3
          }
        ],
        "total_items": 2,
        "total_quantity": 5,
        "total_amount": 75050,
        "delivery": {
          "method": "home_delivery",
          "estimated_arrival": "2025-10-11",
          "tracking_number": "TRK123456789"
        },
        "created_at": "2025-10-09T11:30:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 45
    }
  }
}
```

### GET /orders/:id

Get detailed order information.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "order_id": "ord_1234567890abcdef",
    "order_number": "FM20251009001",
    "status": "shipped",
    "seller": {
      "user_id": "usr_987",
      "name": "Green Valley Farm",
      "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg"
    },
    "items": [
      {
        "order_item_id": "oi_001",
        "product": {
          "product_id": "prd_123",
          "name": "Organic Fresh Tomatoes",
          "image": "https://cdn.farmmarket.com/products/prd_123_001.jpg"
        },
        "quantity": 3,
        "unit_price": 15000,
        "discount": 1500,
        "subtotal": 40500
      }
    ],
    "delivery": {
      "method": "home_delivery",
      "address": {
        "address_id": "addr_123",
        "full_address": "Jl. Sudirman No. 123",
        "recipient_name": "Ahmad Zulfikar",
        "phone": "+6285678901234"
      },
      "date": "2025-10-11",
      "time_slot": "morning",
      "fee": 15000,
      "tracking_number": "TRK123456789",
      "estimated_arrival": "2025-10-11T10:00:00Z"
    },
    "pricing": {
      "subtotal": 64500,
      "delivery_fee": 15000,
      "service_fee": 2000,
      "total_discount": 4500,
      "total": 75050
    },
    "payment": {
      "method": "bank_transfer",
      "status": "paid",
      "paid_at": "2025-10-09T11:45:00Z"
    },
    "timeline": [
      {
        "status": "pending_payment",
        "timestamp": "2025-10-09T11:30:00Z"
      },
      {
        "status": "paid",
        "timestamp": "2025-10-09T11:45:00Z"
      },
      {
        "status": "processing",
        "timestamp": "2025-10-09T14:00:00Z"
      },
      {
        "status": "shipped",
        "timestamp": "2025-10-10T08:00:00Z"
      }
    ],
    "created_at": "2025-10-09T11:30:00Z",
    "updated_at": "2025-10-10T08:00:00Z"
  }
}
```

### POST /orders

Create new order from cart items.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "cart_item_ids": ["ci_001", "ci_002"],
  "delivery_address_id": "addr_123",
  "delivery_method": "home_delivery",
  "delivery_date": "2025-10-11",
  "delivery_time_slot": "morning",
  "payment_method": "bank_transfer",
  "notes": "Please deliver before 12 PM"
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Order created successfully",
  "data": {
    "orders": [
      {
        "order_id": "ord_new_1",
        "order_number": "FM20251009099",
        "status": "pending_payment",
        "total_amount": 75050
      }
    ],
    "payment_summary": {
      "total_orders": 1,
      "grand_total": 75050,
      "payment_method": "bank_transfer",
      "payment_instructions": {
        "bank_name": "Bank Mandiri",
        "account_number": "1234567890",
        "account_name": "FarmMarket Indonesia",
        "amount": 75050,
        "valid_until": "2025-10-09T23:59:59Z"
      }
    }
  }
}
```

### PATCH /orders/:id/cancel

Cancel an order.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "reason": "Changed my mind",
  "details": "Additional cancellation details"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Order cancelled successfully",
  "data": {
    "order_id": "ord_1234567890abcdef",
    "status": "cancelled",
    "refund": {
      "amount": 75050,
      "method": "original_payment_method",
      "estimated_days": 7
    }
  }
}
```

---

## Addresses

### GET /addresses

Get user's saved addresses.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "addresses": [
      {
        "address_id": "addr_1234567890",
        "label": "Home",
        "recipient_name": "Ahmad Zulfikar",
        "phone": "+6285678901234",
        "full_address": "Jl. Sudirman No. 123, RT 01/RW 05",
        "province": "West Java",
        "province_id": 32,
        "city": "Bandung",
        "city_id": 3273,
        "district": "Coblong",
        "district_id": 327305,
        "subdistrict": "Cipaganti",
        "postal_code": "40132",
        "latitude": -6.914744,
        "longitude": 107.60981,
        "notes": "Rumah cat hijau, pagar hitam",
        "is_primary": true,
        "is_verified": true,
        "created_at": "2025-09-01T10:00:00Z",
        "updated_at": "2025-09-01T10:00:00Z"
      }
    ],
    "total_count": 2
  }
}
```

### POST /addresses

Add new address.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "label": "Office",
  "recipient_name": "Ahmad Zulfikar",
  "phone": "+6285678901234",
  "full_address": "Jl. Asia Afrika No. 8",
  "province_id": 32,
  "city_id": 3273,
  "district_id": 327301,
  "postal_code": "40111",
  "latitude": -6.921586,
  "longitude": 107.607376,
  "notes": "Gedung lantai 5, sebelah lift",
  "is_primary": false
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Address added successfully",
  "data": {
    "address_id": "addr_new_123",
    "label": "Office",
    "recipient_name": "Ahmad Zulfikar",
    "phone": "+6285678901234",
    "full_address": "Jl. Asia Afrika No. 8",
    "province": "West Java",
    "province_id": 32,
    "city": "Bandung",
    "city_id": 3273,
    "district": "Sumur Bandung",
    "district_id": 327301,
    "postal_code": "40111",
    "latitude": -6.921586,
    "longitude": 107.607376,
    "notes": "Gedung lantai 5, sebelah lift",
    "is_primary": false,
    "is_verified": false,
    "created_at": "2025-10-10T10:00:00Z",
    "updated_at": "2025-10-10T10:00:00Z"
  }
}
```

### PUT /addresses/:id

Update existing address.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "label": "Office - Updated",
  "recipient_name": "Ahmad Zulfikar",
  "phone": "+6285678901234",
  "full_address": "Jl. Asia Afrika No. 8, Lantai 5",
  "notes": "Updated notes"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Address updated successfully",
  "data": {
    "address_id": "addr_123",
    "label": "Office - Updated",
    "updated_at": "2025-10-10T11:00:00Z"
  }
}
```

### DELETE /addresses/:id

Delete an address.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Address deleted successfully"
}
```

### PATCH /addresses/:id/primary

Set address as primary.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Primary address updated",
  "data": {
    "address_id": "addr_123",
    "is_primary": true
  }
}
```

### GET /addresses/provinces

Get list of provinces.

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": 32,
      "name": "West Java",
      "code": "JB"
    }
  ]
}
```

### GET /addresses/cities

Get cities by province.

**Query Parameters:**

- `province_id` (number, required) - Province ID

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": 3273,
      "province_id": 32,
      "name": "Bandung",
      "type": "Kota",
      "postal_code": "40100"
    }
  ]
}
```

### GET /addresses/districts

Get districts by city.

**Query Parameters:**

- `city_id` (number, required) - City ID

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": 327305,
      "city_id": 3273,
      "name": "Coblong"
    }
  ]
}
```

### POST /addresses/geocode

Convert coordinates to address.

**Request Body:**

```json
{
  "latitude": -6.914744,
  "longitude": 107.60981
}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "formatted_address": "Jl. Sudirman, Coblong, Bandung, West Java 40132",
    "province": "West Java",
    "city": "Bandung",
    "district": "Coblong",
    "postal_code": "40132"
  }
}
```

---

## Reviews

### GET /products/:productId/reviews

Get reviews for a product.

**Query Parameters:**

- `page` (number) - Page number
- `limit` (number) - Items per page
- `rating` (number) - Filter by rating (1-5)
- `with_photos` (boolean) - Only reviews with photos

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "reviews": [
      {
        "review_id": "rev_123",
        "rating": 5,
        "title": "Excellent quality!",
        "comment": "Very fresh and delicious tomatoes. Packaging was excellent.",
        "buyer": {
          "user_id": "usr_buyer_123",
          "name": "Ahmad S.",
          "profile_picture": "https://cdn.farmmarket.com/avatars/usr_buyer_123.jpg",
          "is_verified_purchase": true
        },
        "images": [
          {
            "image_id": "rev_img_001",
            "url": "https://cdn.farmmarket.com/reviews/rev_img_001.jpg",
            "thumbnail_url": "https://cdn.farmmarket.com/reviews/thumb_rev_img_001.jpg"
          }
        ],
        "helpful_count": 12,
        "is_helpful": false,
        "seller_response": {
          "comment": "Thank you for your wonderful feedback!",
          "responded_at": "2025-10-06T09:00:00Z"
        },
        "created_at": "2025-10-05T14:30:00Z"
      }
    ],
    "summary": {
      "average_rating": 4.8,
      "total_reviews": 45,
      "distribution": {
        "5_star": 30,
        "4_star": 10,
        "3_star": 3,
        "2_star": 1,
        "1_star": 1
      }
    },
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 45
    }
  }
}
```

### POST /products/:productId/reviews

Create a product review.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "order_id": "ord_123",
  "rating": 5,
  "title": "Excellent quality!",
  "comment": "Very fresh and delicious tomatoes.",
  "images": ["img_001", "img_002"]
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Review submitted successfully",
  "data": {
    "review_id": "rev_new_123",
    "rating": 5,
    "created_at": "2025-10-10T10:00:00Z"
  }
}
```

### PUT /reviews/:id

Update a review.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "rating": 4,
  "title": "Good quality",
  "comment": "Updated review comment"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Review updated successfully",
  "data": {
    "review_id": "rev_123",
    "updated_at": "2025-10-10T10:30:00Z"
  }
}
```

### DELETE /reviews/:id

Delete a review.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Review deleted successfully"
}
```

### POST /reviews/:id/helpful

Mark review as helpful.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Review marked as helpful",
  "data": {
    "review_id": "rev_123",
    "helpful_count": 13,
    "is_helpful": true
  }
}
```

### DELETE /reviews/:id/helpful

Remove helpful mark from review.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Helpful mark removed",
  "data": {
    "review_id": "rev_123",
    "helpful_count": 12,
    "is_helpful": false
  }
}
```

### POST /reviews/:id/response

Seller response to a review.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "comment": "Thank you for your wonderful feedback!"
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Response added successfully",
  "data": {
    "review_id": "rev_123",
    "response": {
      "comment": "Thank you for your wonderful feedback!",
      "responded_at": "2025-10-10T10:00:00Z"
    }
  }
}
```

---

## Search

### GET /search/products

Search for products.

**Query Parameters:**

- `q` (string, required) - Search query
- `sort_by` (string) - Sort by: `relevance`, `price`, `distance`, `newest`, `rating`
- `min_price` (number) - Minimum price
- `max_price` (number) - Maximum price
- `categories` (string) - Comma-separated category IDs
- `types` (string) - Comma-separated types: `organic`, `fresh`, `local`
- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "prd_123",
      "name": "Organic Fresh Tomatoes",
      "description": "Fresh organic tomatoes from local farms",
      "store_name": "Green Farm Market",
      "store_id": "usr_987",
      "distance": 1.2,
      "price": 15000,
      "unit": "kg",
      "rating": 4.8,
      "stock": 120,
      "tag": "Organic",
      "image_url": "https://cdn.farmmarket.com/products/prd_123.jpg",
      "category": "Vegetables",
      "types": ["Organic", "Fresh"],
      "created_at": "2025-09-01T00:00:00Z"
    }
  ],
  "meta": {
    "total": 150,
    "page": 1,
    "limit": 20,
    "query": "tomatoes"
  }
}
```

### GET /search/farmers

Search for farmers/sellers.

**Query Parameters:**

- `q` (string, required) - Search query
- `specialties` (string) - Filter by specialties
- `min_rating` (number) - Minimum rating
- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "farmer_001",
      "name": "Green Valley Farm",
      "description": "Organic farm specializing in vegetables",
      "profile_image": "https://cdn.farmmarket.com/farmers/farmer_001.jpg",
      "rating": 4.9,
      "city": "Bandung",
      "specialties": ["Vegetables", "Organic Farming"],
      "total_products": 30
    }
  ],
  "meta": {
    "total": 25,
    "page": 1,
    "limit": 20
  }
}
```

### GET /search/suggestions

Get search suggestions/autocomplete.

**Query Parameters:**

- `q` (string, required) - Search query
- `type` (string) - Type: `products`, `farmers`, `categories`
- `limit` (number, default: 10) - Max suggestions

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "type": "product",
      "text": "Organic Tomatoes",
      "id": "prd_123"
    },
    {
      "type": "category",
      "text": "Vegetables",
      "id": "vegetables"
    },
    {
      "type": "farmer",
      "text": "Green Valley Farm",
      "id": "farmer_001"
    }
  ]
}
```

### GET /search/history

Get user's search history.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `limit` (number, default: 10) - Max results

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "search_001",
      "query": "organic tomatoes",
      "result_count": 45,
      "searched_at": "2025-10-10T10:00:00Z"
    }
  ]
}
```

### DELETE /search/history/:id

Delete a search history item.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Search history item deleted"
}
```

### DELETE /search/history

Clear all search history.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Search history cleared"
}
```

---

## Messaging

### GET /conversations

Get user's conversation list.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `filter` (string) - Filter: `all`, `unread`, `order`, `general`
- `search` (string) - Search conversations
- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "conversations": [
      {
        "conversation_id": "conv_1234567890abcdef",
        "type": "order",
        "participant": {
          "user_id": "usr_987",
          "name": "Green Valley Farm",
          "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg",
          "user_type": "producer",
          "is_online": true,
          "last_seen": "2025-10-10T09:55:00Z",
          "verified": true,
          "response_rate": 98,
          "response_time": "< 30 minutes"
        },
        "order": {
          "order_id": "ord_123",
          "order_number": "FM20251009001",
          "status": "shipped",
          "total_amount": 75050,
          "items_count": 2
        },
        "last_message": {
          "message_id": "msg_789",
          "sender_id": "usr_987",
          "sender_name": "Green Valley Farm",
          "type": "text",
          "content": "Your order has been shipped!",
          "preview": "Your order has been shipped!",
          "timestamp": "2025-10-10T08:00:00Z",
          "is_read": false
        },
        "unread_count": 2,
        "muted": false,
        "pinned": false,
        "created_at": "2025-10-09T11:30:00Z",
        "updated_at": "2025-10-10T08:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_items": 25
    }
  }
}
```

### GET /conversations/:id

Get conversation details and messages.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `page` (number) - Page number for messages
- `limit` (number, default: 50) - Messages per page
- `before_message_id` (string) - Load messages before this ID

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "conversation_id": "conv_1234567890abcdef",
    "type": "order",
    "participant": {
      "user_id": "usr_987",
      "name": "Green Valley Farm",
      "profile_picture": "https://cdn.farmmarket.com/profiles/usr_987.jpg",
      "is_online": true,
      "last_seen": "2025-10-10T09:55:00Z"
    },
    "order": {
      "order_id": "ord_123",
      "order_number": "FM20251009001",
      "status": "shipped"
    },
    "messages": [
      {
        "message_id": "msg_001",
        "sender_id": "usr_987",
        "sender_name": "Green Valley Farm",
        "type": "text",
        "content": "Hello! Thank you for your order.",
        "timestamp": "2025-10-09T12:00:00Z",
        "is_read": true,
        "read_at": "2025-10-09T12:05:00Z",
        "is_edited": false,
        "reactions": []
      },
      {
        "message_id": "msg_002",
        "sender_id": "usr_123",
        "sender_name": "You",
        "type": "text",
        "content": "When will my order be shipped?",
        "timestamp": "2025-10-09T14:30:00Z",
        "is_read": true,
        "read_at": "2025-10-09T14:32:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "has_next": false,
      "has_previous": false
    }
  }
}
```

### POST /conversations

Start a new conversation.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "recipient_id": "usr_987",
  "type": "general",
  "order_id": "ord_123",
  "product_id": "prd_456",
  "initial_message": "Hi, I have a question about this product."
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Conversation started",
  "data": {
    "conversation_id": "conv_new_123",
    "message_id": "msg_new_001"
  }
}
```

### POST /conversations/:id/messages

Send a message in conversation.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "type": "text",
  "content": "Thank you for the update!",
  "reply_to_message_id": "msg_001"
}
```

**Response (201):**

```json
{
  "status": "success",
  "data": {
    "message_id": "msg_new_123",
    "conversation_id": "conv_1234567890abcdef",
    "sender_id": "usr_123",
    "type": "text",
    "content": "Thank you for the update!",
    "timestamp": "2025-10-10T10:00:00Z",
    "is_read": false
  }
}
```

### PUT /messages/:id

Edit a message.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "content": "Updated message content"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Message updated",
  "data": {
    "message_id": "msg_123",
    "content": "Updated message content",
    "is_edited": true,
    "edited_at": "2025-10-10T10:05:00Z"
  }
}
```

### DELETE /messages/:id

Delete a message.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `delete_for` (string) - `me` or `everyone`

**Response (200):**

```json
{
  "status": "success",
  "message": "Message deleted"
}
```

### PATCH /messages/:id/read

Mark message as read.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "message_id": "msg_123",
    "is_read": true,
    "read_at": "2025-10-10T10:00:00Z"
  }
}
```

### PATCH /conversations/:id/read

Mark all messages in conversation as read.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Conversation marked as read",
  "data": {
    "conversation_id": "conv_123",
    "marked_count": 5
  }
}
```

### POST /messages/:id/reaction

Add reaction to message.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "emoji": "👍"
}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "message_id": "msg_123",
    "emoji": "👍"
  }
}
```

### DELETE /conversations/:id

Delete a conversation.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Conversation deleted"
}
```

### PATCH /conversations/:id/mute

Mute/unmute conversation.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "muted": true,
  "duration": 86400
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Conversation muted"
}
```

### PATCH /conversations/:id/pin

Pin/unpin conversation.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "pinned": true
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Conversation pinned"
}
```

---

## Notifications

### GET /notifications

Get user's notifications.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `type` (string) - Filter by type: `all`, `order`, `message`, `promotion`, `price_alert`, `stock_alert`, `system`
- `status` (string) - Filter by status: `all`, `unread`, `read`
- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "notifications": [
      {
        "notification_id": "notif_1234567890",
        "type": "order",
        "title": "Order Shipped",
        "message": "Your order FM20251009001 has been shipped!",
        "icon": "📦",
        "image": "https://cdn.farmmarket.com/products/prd_123.jpg",
        "reference": {
          "type": "order",
          "id": "ord_1234567890abcdef"
        },
        "action": {
          "type": "navigate",
          "screen": "order_detail",
          "params": {
            "order_id": "ord_1234567890abcdef"
          }
        },
        "is_read": false,
        "priority": "high",
        "created_at": "2025-10-10T10:00:00Z"
      }
    ],
    "stats": {
      "total_unread": 4,
      "by_type": {
        "order": 2,
        "message": 1,
        "promotion": 0,
        "price_alert": 0,
        "stock_alert": 1,
        "system": 0
      }
    },
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_items": 45
    }
  }
}
```

### PATCH /notifications/:id/read

Mark notification as read.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Notification marked as read",
  "data": {
    "notification_id": "notif_123",
    "is_read": true,
    "read_at": "2025-10-10T10:00:00Z"
  }
}
```

### PATCH /notifications/read-all

Mark all notifications as read.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `type` (string) - Mark only specific type

**Response (200):**

```json
{
  "status": "success",
  "message": "All notifications marked as read",
  "data": {
    "marked_count": 15,
    "marked_at": "2025-10-10T10:00:00Z"
  }
}
```

### DELETE /notifications/:id

Delete a notification.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Notification deleted"
}
```

### DELETE /notifications/clear

Clear notifications.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**

- `type` (string) - Clear specific type only
- `older_than_days` (number) - Clear older than X days

**Response (200):**

```json
{
  "status": "success",
  "message": "Notifications cleared",
  "data": {
    "deleted_count": 20
  }
}
```

### GET /notifications/settings

Get notification settings.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "order_updates": true,
    "messages": true,
    "promotions": true,
    "price_alerts": true,
    "stock_alerts": true,
    "system_notifications": true,
    "push_enabled": true,
    "email_enabled": false,
    "sound_enabled": true,
    "vibration_enabled": true
  }
}
```

### PUT /notifications/settings

Update notification settings.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "order_updates": true,
  "messages": true,
  "promotions": false,
  "push_enabled": true,
  "sound_enabled": false
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Notification settings updated",
  "data": {
    "order_updates": true,
    "messages": true,
    "promotions": false,
    "push_enabled": true,
    "sound_enabled": false
  }
}
```

---

## Community

### GET /farmers/:farmerId/posts

Get farmer's community posts.

**Query Parameters:**

- `type` (string) - Filter by type: `all`, `general`, `harvest`, `tips`, `announcement`, `event`
- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "post_001",
      "farmer_id": "farmer_001",
      "farmer_name": "Green Valley Farm",
      "farmer_avatar": "https://cdn.farmmarket.com/farmers/farmer_001.jpg",
      "content": "🌾 Harvest season is here! Our organic tomatoes are ready...",
      "images": [
        "https://cdn.farmmarket.com/posts/post_001_img1.jpg",
        "https://cdn.farmmarket.com/posts/post_001_img2.jpg"
      ],
      "location": "Green Valley Farm, Bandung",
      "type": "harvest",
      "like_count": 45,
      "comment_count": 12,
      "is_liked": false,
      "tags": ["organic", "tomatoes", "harvest"],
      "created_at": "2025-10-10T08:00:00Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 3,
    "total_items": 25
  }
}
```

### POST /posts

Create a new community post (Farmers only).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "content": "🌱 Just planted a new batch of lettuce!",
  "images": ["img_001", "img_002"],
  "location": "Green Valley Farm, Bandung",
  "type": "general",
  "tags": ["planting", "lettuce", "sustainable"]
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Post created successfully",
  "data": {
    "id": "post_new_123",
    "created_at": "2025-10-10T10:00:00Z"
  }
}
```

### PUT /posts/:id

Update a post.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "content": "Updated post content",
  "tags": ["updated", "tags"]
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Post updated successfully"
}
```

### DELETE /posts/:id

Delete a post.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Post deleted successfully"
}
```

### POST /posts/:id/like

Like a post.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "post_id": "post_001",
    "is_liked": true,
    "like_count": 46
  }
}
```

### DELETE /posts/:id/like

Unlike a post.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "post_id": "post_001",
    "is_liked": false,
    "like_count": 45
  }
}
```

### GET /posts/:id/comments

Get post comments.

**Query Parameters:**

- `page` (number) - Page number
- `limit` (number) - Items per page

**Response (200):**

```json
{
  "status": "success",
  "data": [
    {
      "id": "comment_001",
      "post_id": "post_001",
      "user_id": "user_001",
      "user_name": "Sarah Johnson",
      "user_avatar": null,
      "content": "This looks amazing! Can't wait to visit 🌿",
      "like_count": 5,
      "is_liked": false,
      "created_at": "2025-10-10T09:00:00Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 2,
    "total_items": 12
  }
}
```

### POST /posts/:id/comments

Add a comment to post.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "content": "Great post! Looking forward to the harvest."
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Comment added",
  "data": {
    "id": "comment_new_123",
    "created_at": "2025-10-10T10:00:00Z"
  }
}
```

### DELETE /comments/:id

Delete a comment.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Comment deleted"
}
```

### POST /comments/:id/like

Like a comment.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "comment_id": "comment_001",
    "is_liked": true,
    "like_count": 6
  }
}
```

---

## Utility

### POST /upload/image

Upload an image file.

**Headers:**

```
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
```

**Request Body (FormData):**

```
file: [image file]
type: "profile" | "product" | "post" | "message" | "review"
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "file_id": "img_12345",
    "url": "https://cdn.farmmarket.com/uploads/img_12345.jpg",
    "thumbnail_url": "https://cdn.farmmarket.com/uploads/img_12345_thumb.jpg",
    "size": 245678,
    "mime_type": "image/jpeg",
    "uploaded_at": "2025-10-10T10:00:00Z"
  }
}
```

### POST /upload/video

Upload a video file.

**Headers:**

```
Authorization: Bearer {access_token}
Content-Type: multipart/form-data
```

**Request Body (FormData):**

```
file: [video file]
type: "product" | "post"
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "file_id": "vid_12345",
    "url": "https://cdn.farmmarket.com/uploads/vid_12345.mp4",
    "thumbnail_url": "https://cdn.farmmarket.com/uploads/vid_12345_thumb.jpg",
    "size": 5242880,
    "duration": 45,
    "mime_type": "video/mp4",
    "uploaded_at": "2025-10-10T10:00:00Z"
  }
}
```

### GET /upload/progress/:uploadId

Get upload progress for large files.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "upload_id": "upload_123",
    "progress": 75,
    "status": "uploading",
    "bytes_uploaded": 3932160,
    "total_bytes": 5242880
  }
}
```

### POST /share

Share content (product, farmer, post).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "content_type": "product",
  "content_id": "prod_001",
  "platform": "whatsapp"
}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "share_url": "https://farmmarket.com/share/product/prod_001",
    "share_text": "Check out this Fresh Organic Tomatoes on Farm Market!",
    "share_image": "https://cdn.farmmarket.com/products/prod_001_main.jpg"
  }
}
```

### GET /settings/app

Get app settings.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "theme": "light",
    "language": "en",
    "currency": "USD",
    "distance_unit": "km",
    "enable_notifications": true,
    "enable_location": true,
    "auto_update": true,
    "data_saver": false
  }
}
```

### PUT /settings/app

Update app settings.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "theme": "dark",
  "language": "id",
  "data_saver": true
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "App settings updated"
}
```

### GET /settings/privacy

Get privacy and security settings.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "profile_visibility": "public",
    "show_online_status": true,
    "show_last_seen": true,
    "allow_messages_from": "everyone",
    "block_list": [],
    "two_factor_enabled": false
  }
}
```

### PUT /settings/privacy

Update privacy and security settings.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "profile_visibility": "friends_only",
  "show_online_status": false,
  "allow_messages_from": "contacts"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Privacy settings updated"
}
```

---

## Harvest Schedules

Endpoints for managing farmer harvest schedules. This enables the pre-order system for perishable products.

### GET /harvest-schedules

Get all upcoming harvest schedules with optional filtering.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status: `scheduled`, `harvesting`, `ready`, `completed`, `cancelled` |
| farmer_id | int | No | Filter by specific farmer |
| product_id | int | No | Filter by specific product |
| within_days | int | No | Show harvests within X days (default: 14) |
| latitude | float | No | User latitude for distance calculation |
| longitude | float | No | User longitude for distance calculation |
| radius_km | int | No | Filter farmers within radius (requires lat/lng) |
| can_preorder | boolean | No | Only show schedules accepting pre-orders |
| page | int | No | Page number (default: 1) |
| limit | int | No | Items per page (default: 10, max: 50) |

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "harvest_schedules": [
      {
        "id": 1,
        "farmer": {
          "id": 1,
          "name": "Pak Budi",
          "profile_image": "https://example.com/farmers/1.jpg",
          "location": "Bandung Selatan",
          "rating": 4.8,
          "latitude": -6.9541,
          "longitude": 107.6354,
          "distance_km": 3.5
        },
        "product": {
          "id": 101,
          "name": "Tomat Organik Segar",
          "image": "https://example.com/products/101.jpg",
          "category": "Sayuran"
        },
        "expected_harvest_date": "2024-01-20T06:00:00Z",
        "expected_quantity_kg": 150.0,
        "available_for_preorder_kg": 120.0,
        "preordered_quantity_kg": 45.5,
        "preorder_percentage": 37.9,
        "price_per_kg": 18000,
        "preorder_price_per_kg": 16000,
        "min_preorder_kg": 1.0,
        "max_preorder_kg": 20.0,
        "deposit_percentage": 30,
        "status": "scheduled",
        "is_organic": true,
        "estimated_freshness_days": 7,
        "delivery_options": ["pickup", "delivery", "meetup"],
        "pickup_location": {
          "address": "Jl. Raya Ciwidey No. 45",
          "latitude": -7.0421,
          "longitude": 107.4902
        },
        "notes": "Panen pagi hari untuk kesegaran maksimal",
        "created_at": "2024-01-10T08:00:00Z",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 5,
      "total_items": 48,
      "items_per_page": 10
    }
  }
}
```

### GET /harvest-schedules/:id

Get detailed information about a specific harvest schedule.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "id": 1,
    "farmer": {
      "id": 1,
      "name": "Pak Budi",
      "profile_image": "https://example.com/farmers/1.jpg",
      "location": "Bandung Selatan",
      "rating": 4.8,
      "total_reviews": 156,
      "subscriber_count": 234,
      "phone": "+6281234567890",
      "is_subscribed": true,
      "latitude": -6.9541,
      "longitude": 107.6354,
      "distance_km": 3.5
    },
    "product": {
      "id": 101,
      "name": "Tomat Organik Segar",
      "description": "Tomat organik berkualitas tinggi dari kebun kami",
      "images": [
        "https://example.com/products/101-1.jpg",
        "https://example.com/products/101-2.jpg"
      ],
      "category": "Sayuran",
      "is_organic": true
    },
    "expected_harvest_date": "2024-01-20T06:00:00Z",
    "harvest_window_hours": 4,
    "expected_quantity_kg": 150.0,
    "available_for_preorder_kg": 120.0,
    "preordered_quantity_kg": 45.5,
    "preorder_count": 12,
    "preorder_percentage": 37.9,
    "price_per_kg": 18000,
    "preorder_price_per_kg": 16000,
    "savings_percentage": 11.1,
    "min_preorder_kg": 1.0,
    "max_preorder_kg": 20.0,
    "deposit_percentage": 30,
    "status": "scheduled",
    "estimated_freshness_days": 7,
    "storage_tips": "Simpan di suhu ruangan, hindari sinar matahari langsung",
    "delivery_options": [
      {
        "method": "pickup",
        "description": "Ambil langsung di kebun",
        "additional_cost": 0,
        "available_slots": ["06:00-08:00", "16:00-18:00"]
      },
      {
        "method": "delivery",
        "description": "Kirim ke alamat Anda",
        "additional_cost": 15000,
        "max_distance_km": 25
      },
      {
        "method": "meetup",
        "description": "Bertemu di titik janjian",
        "additional_cost": 5000,
        "locations": ["Pasar Ciwidey", "Alun-alun Soreang"]
      }
    ],
    "pickup_location": {
      "address": "Jl. Raya Ciwidey No. 45, Bandung",
      "latitude": -7.0421,
      "longitude": 107.4902,
      "instructions": "Belok kiri setelah warung makan, masuk gang 50m"
    },
    "preorder_benefits": [
      "Harga lebih murah 11%",
      "Prioritas pengambilan",
      "Garansi kesegaran",
      "Free ongkir untuk order > 10kg"
    ],
    "notes": "Panen pagi hari untuk kesegaran maksimal. Pembeli pre-order dapat hadir menyaksikan proses panen.",
    "weather_forecast": {
      "condition": "sunny",
      "harvest_likely": true
    },
    "created_at": "2024-01-10T08:00:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

### GET /farmers/:farmerId/harvest-schedules

Get all harvest schedules for a specific farmer.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status |
| within_days | int | No | Show harvests within X days |
| page | int | No | Page number (default: 1) |
| limit | int | No | Items per page (default: 10) |

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "farmer": {
      "id": 1,
      "name": "Pak Budi",
      "profile_image": "https://example.com/farmers/1.jpg",
      "total_scheduled_harvests": 5,
      "total_preorder_value": 2500000
    },
    "harvest_schedules": [
      {
        "id": 1,
        "product": {
          "id": 101,
          "name": "Tomat Organik Segar",
          "image": "https://example.com/products/101.jpg"
        },
        "expected_harvest_date": "2024-01-20T06:00:00Z",
        "available_for_preorder_kg": 120.0,
        "preorder_percentage": 37.9,
        "preorder_price_per_kg": 16000,
        "status": "scheduled"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 1,
      "total_items": 5,
      "items_per_page": 10
    }
  }
}
```

### POST /harvest-schedules

Create a new harvest schedule (Farmer only).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "product_id": 101,
  "expected_harvest_date": "2024-01-20T06:00:00Z",
  "harvest_window_hours": 4,
  "expected_quantity_kg": 150.0,
  "available_for_preorder_kg": 120.0,
  "price_per_kg": 18000,
  "preorder_price_per_kg": 16000,
  "min_preorder_kg": 1.0,
  "max_preorder_kg": 20.0,
  "deposit_percentage": 30,
  "is_organic": true,
  "estimated_freshness_days": 7,
  "storage_tips": "Simpan di suhu ruangan",
  "delivery_options": ["pickup", "delivery", "meetup"],
  "pickup_location": {
    "address": "Jl. Raya Ciwidey No. 45",
    "latitude": -7.0421,
    "longitude": 107.4902,
    "instructions": "Belok kiri setelah warung makan"
  },
  "notes": "Panen pagi hari untuk kesegaran maksimal"
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Harvest schedule created successfully",
  "data": {
    "id": 1,
    "product_id": 101,
    "expected_harvest_date": "2024-01-20T06:00:00Z",
    "status": "scheduled",
    "created_at": "2024-01-10T08:00:00Z"
  }
}
```

### PUT /harvest-schedules/:id

Update a harvest schedule (Farmer only).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "expected_harvest_date": "2024-01-21T06:00:00Z",
  "expected_quantity_kg": 160.0,
  "available_for_preorder_kg": 100.0,
  "notes": "Tanggal panen diubah karena cuaca"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Harvest schedule updated successfully",
  "data": {
    "id": 1,
    "updated_at": "2024-01-16T08:00:00Z"
  }
}
```

### PATCH /harvest-schedules/:id/status

Update harvest schedule status (Farmer only).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "status": "harvesting",
  "actual_harvest_date": "2024-01-20T05:30:00Z",
  "actual_quantity_kg": 145.0,
  "quality_notes": "Kualitas sangat baik, sedikit lebih kecil dari estimasi"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Harvest status updated to harvesting",
  "data": {
    "id": 1,
    "status": "harvesting",
    "notifications_sent": 12
  }
}
```

### DELETE /harvest-schedules/:id

Cancel/delete a harvest schedule (Farmer only). All pre-orders will be notified and refunded.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "cancellation_reason": "Cuaca buruk menyebabkan kerusakan tanaman",
  "refund_deposits": true
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Harvest schedule cancelled",
  "data": {
    "preorders_affected": 12,
    "deposits_refunded": 485000,
    "notifications_sent": 12
  }
}
```

---

## Pre-Orders

Endpoints for managing pre-orders on upcoming harvests.

### GET /pre-orders

Get user's pre-orders.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter by status: `pending`, `confirmed`, `ready_for_pickup`, `shipped`, `completed`, `cancelled`, `refunded` |
| harvest_schedule_id | int | No | Filter by specific harvest |
| farmer_id | int | No | Filter by farmer |
| page | int | No | Page number (default: 1) |
| limit | int | No | Items per page (default: 10) |

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "pre_orders": [
      {
        "id": 1,
        "harvest_schedule": {
          "id": 1,
          "product": {
            "id": 101,
            "name": "Tomat Organik Segar",
            "image": "https://example.com/products/101.jpg"
          },
          "expected_harvest_date": "2024-01-20T06:00:00Z",
          "status": "scheduled"
        },
        "farmer": {
          "id": 1,
          "name": "Pak Budi",
          "profile_image": "https://example.com/farmers/1.jpg",
          "phone": "+6281234567890"
        },
        "quantity_kg": 5.0,
        "price_per_kg": 16000,
        "subtotal": 80000,
        "deposit_amount": 24000,
        "remaining_amount": 56000,
        "delivery_method": "pickup",
        "delivery_cost": 0,
        "total_amount": 80000,
        "status": "confirmed",
        "deposit_paid_at": "2024-01-15T10:30:00Z",
        "estimated_pickup_time": "2024-01-20T06:00:00Z",
        "pickup_location": {
          "address": "Jl. Raya Ciwidey No. 45",
          "latitude": -7.0421,
          "longitude": 107.4902
        },
        "special_instructions": "Tolong pisahkan yang matang dan setengah matang",
        "created_at": "2024-01-15T10:00:00Z",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    ],
    "summary": {
      "total_preorders": 3,
      "pending_deposits": 50000,
      "confirmed_value": 180000,
      "upcoming_pickups": 2
    },
    "pagination": {
      "current_page": 1,
      "total_pages": 1,
      "total_items": 3,
      "items_per_page": 10
    }
  }
}
```

### GET /pre-orders/:id

Get detailed information about a specific pre-order.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "id": 1,
    "harvest_schedule": {
      "id": 1,
      "product": {
        "id": 101,
        "name": "Tomat Organik Segar",
        "description": "Tomat organik segar dari kebun Pak Budi",
        "images": [
          "https://example.com/products/101-1.jpg",
          "https://example.com/products/101-2.jpg"
        ],
        "is_organic": true
      },
      "expected_harvest_date": "2024-01-20T06:00:00Z",
      "status": "scheduled",
      "notes": "Panen pagi hari"
    },
    "farmer": {
      "id": 1,
      "name": "Pak Budi",
      "profile_image": "https://example.com/farmers/1.jpg",
      "phone": "+6281234567890",
      "rating": 4.8
    },
    "quantity_kg": 5.0,
    "price_per_kg": 16000,
    "subtotal": 80000,
    "deposit_percentage": 30,
    "deposit_amount": 24000,
    "deposit_paid": true,
    "deposit_paid_at": "2024-01-15T10:30:00Z",
    "deposit_payment_method": "bank_transfer",
    "remaining_amount": 56000,
    "delivery_method": "pickup",
    "delivery_cost": 0,
    "total_amount": 80000,
    "status": "confirmed",
    "status_history": [
      {
        "status": "pending",
        "timestamp": "2024-01-15T10:00:00Z",
        "note": "Pre-order created"
      },
      {
        "status": "confirmed",
        "timestamp": "2024-01-15T10:30:00Z",
        "note": "Deposit received"
      }
    ],
    "pickup_location": {
      "address": "Jl. Raya Ciwidey No. 45, Bandung",
      "latitude": -7.0421,
      "longitude": 107.4902,
      "instructions": "Belok kiri setelah warung makan"
    },
    "estimated_pickup_time": "2024-01-20T06:00:00Z",
    "pickup_slot": "06:00-08:00",
    "special_instructions": "Tolong pisahkan yang matang dan setengah matang",
    "refund_policy": {
      "full_refund_before_days": 3,
      "partial_refund_percentage": 50,
      "no_refund_after": "2024-01-19T00:00:00Z"
    },
    "created_at": "2024-01-15T10:00:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

### POST /pre-orders

Create a new pre-order.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "harvest_schedule_id": 1,
  "quantity_kg": 5.0,
  "delivery_method": "pickup",
  "pickup_slot": "06:00-08:00",
  "delivery_address_id": null,
  "special_instructions": "Tolong pisahkan yang matang dan setengah matang",
  "payment_method": "bank_transfer"
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Pre-order created successfully",
  "data": {
    "id": 1,
    "harvest_schedule_id": 1,
    "quantity_kg": 5.0,
    "price_per_kg": 16000,
    "subtotal": 80000,
    "deposit_amount": 24000,
    "deposit_due_by": "2024-01-16T10:00:00Z",
    "remaining_amount": 56000,
    "total_amount": 80000,
    "status": "pending",
    "payment_details": {
      "method": "bank_transfer",
      "bank_name": "BCA",
      "account_number": "1234567890",
      "account_name": "PT Harvest Indonesia",
      "amount": 24000,
      "reference": "PO-001-20240115"
    },
    "created_at": "2024-01-15T10:00:00Z"
  }
}
```

### PUT /pre-orders/:id

Update a pre-order (only before harvest).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "quantity_kg": 7.0,
  "delivery_method": "delivery",
  "delivery_address_id": 1,
  "special_instructions": "Updated instructions"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Pre-order updated successfully",
  "data": {
    "id": 1,
    "quantity_kg": 7.0,
    "subtotal": 112000,
    "deposit_difference": 9600,
    "new_deposit_amount": 33600,
    "updated_at": "2024-01-15T12:00:00Z"
  }
}
```

### PATCH /pre-orders/:id/cancel

Cancel a pre-order.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "cancellation_reason": "Perubahan rencana"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Pre-order cancelled",
  "data": {
    "id": 1,
    "status": "cancelled",
    "refund_amount": 24000,
    "refund_percentage": 100,
    "refund_method": "original_payment",
    "refund_eta": "3-5 business days",
    "cancelled_at": "2024-01-16T08:00:00Z"
  }
}
```

### PATCH /pre-orders/:id/confirm-deposit

Confirm deposit payment (after transfer).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "payment_proof_image": "https://example.com/proofs/123.jpg",
  "transfer_reference": "TRF123456789",
  "transfer_date": "2024-01-15",
  "sender_name": "John Doe"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Deposit confirmation received, awaiting verification",
  "data": {
    "id": 1,
    "status": "pending_verification",
    "estimated_verification_time": "1-2 hours"
  }
}
```

### PATCH /pre-orders/:id/complete-payment

Pay remaining balance after harvest.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "payment_method": "cash",
  "paid_amount": 56000
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Payment completed",
  "data": {
    "id": 1,
    "status": "completed",
    "total_paid": 80000,
    "receipt_url": "https://example.com/receipts/PO-001.pdf",
    "completed_at": "2024-01-20T07:30:00Z"
  }
}
```

### GET /farmers/:farmerId/pre-orders

Get pre-orders for a farmer's harvests (Farmer only).

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| harvest_schedule_id | int | No | Filter by specific harvest |
| status | string | No | Filter by status |
| page | int | No | Page number |
| limit | int | No | Items per page |

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "pre_orders": [
      {
        "id": 1,
        "customer": {
          "id": 100,
          "name": "John Doe",
          "phone": "+6281234567890",
          "is_subscriber": true
        },
        "harvest_schedule_id": 1,
        "product_name": "Tomat Organik Segar",
        "quantity_kg": 5.0,
        "total_amount": 80000,
        "deposit_paid": true,
        "remaining_amount": 56000,
        "delivery_method": "pickup",
        "status": "confirmed",
        "created_at": "2024-01-15T10:00:00Z"
      }
    ],
    "summary": {
      "total_preorders": 12,
      "total_quantity_kg": 67.5,
      "total_value": 1080000,
      "deposits_received": 324000
    }
  }
}
```

### PATCH /pre-orders/:id/mark-ready (Farmer)

Mark pre-order as ready for pickup/delivery.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "actual_quantity_kg": 5.0,
  "quality_rating": "excellent",
  "ready_time": "2024-01-20T06:30:00Z",
  "notes": "Sudah dikemas dan siap diambil"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Pre-order marked as ready",
  "data": {
    "id": 1,
    "status": "ready_for_pickup",
    "customer_notified": true
  }
}
```

---

## Farmer Subscriptions

Endpoints for managing user subscriptions to farmers for harvest notifications.

### GET /subscriptions

Get user's farmer subscriptions.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| page | int | No | Page number (default: 1) |
| limit | int | No | Items per page (default: 20) |

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "subscriptions": [
      {
        "id": 1,
        "farmer": {
          "id": 1,
          "name": "Pak Budi",
          "profile_image": "https://example.com/farmers/1.jpg",
          "location": "Bandung Selatan",
          "rating": 4.8,
          "distance_km": 3.5,
          "upcoming_harvests": 3,
          "next_harvest_date": "2024-01-20T06:00:00Z"
        },
        "notification_settings": {
          "new_harvest": true,
          "harvest_ready": true,
          "price_changes": false,
          "new_products": true
        },
        "notify_radius_km": 10,
        "subscribed_at": "2024-01-01T08:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 1,
      "total_items": 5,
      "items_per_page": 20
    }
  }
}
```

### POST /subscriptions

Subscribe to a farmer.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "farmer_id": 1,
  "notification_settings": {
    "new_harvest": true,
    "harvest_ready": true,
    "price_changes": false,
    "new_products": true
  },
  "notify_radius_km": 10
}
```

**Response (201):**

```json
{
  "status": "success",
  "message": "Successfully subscribed to farmer",
  "data": {
    "id": 1,
    "farmer_id": 1,
    "subscribed_at": "2024-01-15T10:00:00Z"
  }
}
```

### PUT /subscriptions/:farmerId

Update subscription settings for a farmer.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "notification_settings": {
    "new_harvest": true,
    "harvest_ready": true,
    "price_changes": true,
    "new_products": false
  },
  "notify_radius_km": 15
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Subscription updated",
  "data": {
    "farmer_id": 1,
    "updated_at": "2024-01-15T12:00:00Z"
  }
}
```

### DELETE /subscriptions/:farmerId

Unsubscribe from a farmer.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Successfully unsubscribed from farmer"
}
```

### GET /subscriptions/nearby-alerts

Get harvest alerts from subscribed farmers within user's radius.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| latitude | float | Yes | User's current latitude |
| longitude | float | Yes | User's current longitude |
| within_days | int | No | Show alerts within X days (default: 7) |

**Response (200):**

```json
{
  "status": "success",
  "data": {
    "alerts": [
      {
        "id": 1,
        "type": "upcoming_harvest",
        "farmer": {
          "id": 1,
          "name": "Pak Budi",
          "profile_image": "https://example.com/farmers/1.jpg",
          "distance_km": 3.5
        },
        "harvest_schedule": {
          "id": 1,
          "product_name": "Tomat Organik Segar",
          "product_image": "https://example.com/products/101.jpg",
          "expected_harvest_date": "2024-01-20T06:00:00Z",
          "days_until_harvest": 5,
          "preorder_price_per_kg": 16000,
          "available_for_preorder_kg": 74.5
        },
        "message": "Pak Budi akan panen Tomat Organik dalam 5 hari!",
        "can_preorder": true,
        "priority": "high",
        "created_at": "2024-01-15T06:00:00Z"
      }
    ],
    "summary": {
      "total_alerts": 3,
      "harvests_this_week": 2,
      "preorder_opportunities": 3
    }
  }
}
```

### PUT /settings/location-preferences

Update user's location preferences for farmer discovery.

**Headers:**

```
Authorization: Bearer {access_token}
```

**Request Body:**

```json
{
  "default_latitude": -6.9175,
  "default_longitude": 107.6191,
  "default_radius_km": 15,
  "auto_detect_location": true,
  "location_update_frequency": "on_app_open"
}
```

**Response (200):**

```json
{
  "status": "success",
  "message": "Location preferences updated"
}
```

---

## Notes for Implementation

### Authentication

- Use JWT tokens with access token (15 min expiry) and refresh token (7 days)
- Implement token refresh flow on 401 responses
- Store refresh token securely (httpOnly cookie or secure storage)

### Pagination

- Default: page=1, limit=10
- Maximum limit: 100 items per page
- Always include pagination metadata in list responses

### File Uploads

- Maximum image size: 5MB
- Maximum video size: 50MB
- Supported image formats: JPEG, PNG, WebP
- Supported video formats: MP4, MOV
- Generate thumbnails for images (300x300) and videos (first frame)

### Error Handling

All endpoints should return consistent error responses:

```json
{
  "status": "error",
  "message": "Error description",
  "errors": {
    "field_name": ["Validation error message"]
  }
}
```

### Rate Limiting

- Authentication endpoints: 5 requests per minute
- Search endpoints: 30 requests per minute
- Upload endpoints: 10 requests per minute
- Other endpoints: 60 requests per minute

### Database Indexes

Ensure indexes on:

- User: email, phone_number
- Product: farmer_id, category_id, is_active, created_at
- Order: user_id, status, created_at
- Cart: user_id
- Message: conversation_id, created_at
- Notification: user_id, is_read, created_at

### Security

- Validate all user inputs
- Sanitize HTML/script tags in user-generated content
- Implement CORS properly
- Use HTTPS only
- Hash passwords with bcrypt (10+ rounds)
- Implement CSRF protection
- Rate limit all endpoints
- Log security events

### Harvest & Pre-Order Specific Notes

- Pre-order deposits should be held in escrow until harvest completion
- Implement automatic refund flow if harvest is cancelled
- Send push notifications for:
  - New harvest scheduled by subscribed farmers within radius
  - Harvest status changes (harvesting, ready)
  - Pre-order status updates
  - Deposit payment reminders
- Calculate distance using Haversine formula for accuracy
- Cache farmer locations and update on significant changes only
