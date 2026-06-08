# API Database Schemas Documentation

This document defines all database schemas needed for the Harvest Mobile App backend (Next.js project).

## Table of Contents

1. [Users & Authentication](#users--authentication)
2. [Products](#products)
3. [Farmers/Sellers](#farmerssellers)
4. [Orders](#orders)
5. [Cart](#cart)
6. [Addresses](#addresses)
7. [Categories](#categories)
8. [Reviews](#reviews)
9. [Messaging](#messaging)
10. [Notifications](#notifications)
11. [Community Posts](#community-posts)
12. [Utility & Media](#utility--media)

---

## Users & Authentication

### Table: `users`

```sql
CREATE TABLE users (
  id VARCHAR(255) PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  phone_number VARCHAR(50),
  avatar_url TEXT,
  user_type ENUM('consumer', 'producer', 'admin') DEFAULT 'consumer',
  is_verified BOOLEAN DEFAULT false,
  is_online BOOLEAN DEFAULT false,
  last_seen TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_email (email),
  INDEX idx_user_type (user_type)
);
```

### Table: `refresh_tokens`

```sql
CREATE TABLE refresh_tokens (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  token TEXT NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_expires_at (expires_at)
);
```

### Table: `user_profiles`

```sql
CREATE TABLE user_profiles (
  user_id VARCHAR(255) PRIMARY KEY,
  bio TEXT,
  followers_count INT DEFAULT 0,
  response_rate DECIMAL(5,2) DEFAULT 0,
  response_time VARCHAR(50),
  joined_since TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## Products

### Table: `products`

```sql
CREATE TABLE products (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE,
  description TEXT,
  long_description TEXT,
  category_id VARCHAR(255),
  subcategory_id VARCHAR(255),
  seller_id VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  currency VARCHAR(10) DEFAULT 'IDR',
  unit VARCHAR(50) NOT NULL,
  unit_weight DECIMAL(10,2) DEFAULT 1.0,
  stock_quantity INT NOT NULL DEFAULT 0,
  minimum_order INT DEFAULT 1,
  maximum_order INT DEFAULT 999,
  is_organic BOOLEAN DEFAULT false,
  is_available BOOLEAN DEFAULT true,
  rating DECIMAL(3,2) DEFAULT 0,
  review_count INT DEFAULT 0,
  harvest_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
  FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE SET NULL,
  INDEX idx_seller_id (seller_id),
  INDEX idx_category_id (category_id),
  INDEX idx_is_available (is_available),
  FULLTEXT idx_search (name, description)
);
```

### Table: `product_images`

```sql
CREATE TABLE product_images (
  id VARCHAR(255) PRIMARY KEY,
  product_id VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  thumbnail_url TEXT,
  medium_url TEXT,
  alt_text VARCHAR(255),
  is_primary BOOLEAN DEFAULT false,
  display_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_id (product_id)
);
```

### Table: `product_videos`

```sql
CREATE TABLE product_videos (
  id VARCHAR(255) PRIMARY KEY,
  product_id VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  thumbnail_url TEXT,
  duration INT,
  title VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_id (product_id)
);
```

### Table: `product_specifications`

```sql
CREATE TABLE product_specifications (
  id VARCHAR(255) PRIMARY KEY,
  product_id VARCHAR(255) NOT NULL,
  spec_key VARCHAR(255) NOT NULL,
  spec_value TEXT NOT NULL,
  display_order INT DEFAULT 0,

  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_id (product_id)
);
```

### Table: `product_tags`

```sql
CREATE TABLE product_tags (
  product_id VARCHAR(255) NOT NULL,
  tag VARCHAR(100) NOT NULL,

  PRIMARY KEY (product_id, tag),
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_tag (tag)
);
```

### Table: `product_certifications`

```sql
CREATE TABLE product_certifications (
  id VARCHAR(255) PRIMARY KEY,
  product_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  issuer VARCHAR(255),
  certificate_number VARCHAR(255),
  issue_date DATE,
  expiry_date DATE,
  verified BOOLEAN DEFAULT false,
  badge_url TEXT,

  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_id (product_id)
);
```

### Table: `product_discounts`

```sql
CREATE TABLE product_discounts (
  id VARCHAR(255) PRIMARY KEY,
  product_id VARCHAR(255) NOT NULL,
  type ENUM('percentage', 'fixed_amount') NOT NULL,
  value DECIMAL(10,2) NOT NULL,
  discounted_price DECIMAL(10,2),
  valid_from TIMESTAMP,
  valid_until TIMESTAMP,
  reason VARCHAR(255),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_product_id (product_id),
  INDEX idx_valid_dates (valid_from, valid_until)
);
```

---

## Farmers/Sellers

### Table: `farmers`

```sql
CREATE TABLE farmers (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  profile_image TEXT,
  cover_image TEXT,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  address TEXT,
  city VARCHAR(255),
  state VARCHAR(255),
  rating DECIMAL(3,2) DEFAULT 0,
  total_reviews INT DEFAULT 0,
  total_products INT DEFAULT 0,
  is_verified BOOLEAN DEFAULT false,
  verification_badge VARCHAR(100),
  has_map_feature BOOLEAN DEFAULT false,
  phone_number VARCHAR(50),
  email VARCHAR(255),
  joined_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_location (latitude, longitude),
  INDEX idx_verified (is_verified)
);
```

### Table: `farmer_specialties`

```sql
CREATE TABLE farmer_specialties (
  farmer_id VARCHAR(255) NOT NULL,
  specialty VARCHAR(100) NOT NULL,

  PRIMARY KEY (farmer_id, specialty),
  FOREIGN KEY (farmer_id) REFERENCES farmers(id) ON DELETE CASCADE,
  INDEX idx_specialty (specialty)
);
```

---

## Orders

### Table: `orders`

```sql
CREATE TABLE orders (
  id VARCHAR(255) PRIMARY KEY,
  order_number VARCHAR(100) UNIQUE NOT NULL,
  buyer_id VARCHAR(255) NOT NULL,
  seller_id VARCHAR(255) NOT NULL,
  status ENUM('pending_payment', 'paid', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending_payment',
  subtotal DECIMAL(10,2) NOT NULL,
  delivery_fee DECIMAL(10,2) DEFAULT 0,
  service_fee DECIMAL(10,2) DEFAULT 0,
  total_discount DECIMAL(10,2) DEFAULT 0,
  total_amount DECIMAL(10,2) NOT NULL,
  payment_method VARCHAR(100),
  payment_status VARCHAR(50),
  delivery_method VARCHAR(100),
  delivery_address_id VARCHAR(255),
  delivery_date DATE,
  delivery_time_slot VARCHAR(50),
  tracking_number VARCHAR(255),
  estimated_arrival TIMESTAMP,
  notes TEXT,
  cancelled_reason TEXT,
  cancelled_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (buyer_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (delivery_address_id) REFERENCES addresses(id) ON DELETE SET NULL,
  INDEX idx_buyer_id (buyer_id),
  INDEX idx_seller_id (seller_id),
  INDEX idx_status (status),
  INDEX idx_order_number (order_number),
  INDEX idx_created_at (created_at)
);
```

### Table: `order_items`

```sql
CREATE TABLE order_items (
  id VARCHAR(255) PRIMARY KEY,
  order_id VARCHAR(255) NOT NULL,
  product_id VARCHAR(255) NOT NULL,
  product_name VARCHAR(255) NOT NULL,
  product_image TEXT,
  quantity INT NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  discount DECIMAL(10,2) DEFAULT 0,
  subtotal DECIMAL(10,2) NOT NULL,

  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
  INDEX idx_order_id (order_id),
  INDEX idx_product_id (product_id)
);
```

---

## Cart

### Table: `carts`

```sql
CREATE TABLE carts (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Table: `cart_items`

```sql
CREATE TABLE cart_items (
  id VARCHAR(255) PRIMARY KEY,
  cart_id VARCHAR(255) NOT NULL,
  product_id VARCHAR(255) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  discount_price DECIMAL(10,2),
  subtotal DECIMAL(10,2) NOT NULL,
  notes TEXT,
  is_selected BOOLEAN DEFAULT true,
  is_available BOOLEAN DEFAULT true,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_cart_id (cart_id),
  INDEX idx_product_id (product_id),
  UNIQUE KEY unique_cart_product (cart_id, product_id)
);
```

---

## Addresses

### Table: `addresses`

```sql
CREATE TABLE addresses (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  label VARCHAR(100) NOT NULL,
  recipient_name VARCHAR(255) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  full_address TEXT NOT NULL,
  province VARCHAR(255) NOT NULL,
  province_id INT NOT NULL,
  city VARCHAR(255) NOT NULL,
  city_id INT NOT NULL,
  district VARCHAR(255) NOT NULL,
  district_id INT NOT NULL,
  subdistrict VARCHAR(255),
  postal_code VARCHAR(20) NOT NULL,
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  notes TEXT,
  is_primary BOOLEAN DEFAULT false,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_location (latitude, longitude)
);
```

### Table: `provinces`

```sql
CREATE TABLE provinces (
  id INT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(10),

  INDEX idx_name (name)
);
```

### Table: `cities`

```sql
CREATE TABLE cities (
  id INT PRIMARY KEY,
  province_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  type VARCHAR(50),
  postal_code VARCHAR(20),

  FOREIGN KEY (province_id) REFERENCES provinces(id) ON DELETE CASCADE,
  INDEX idx_province_id (province_id),
  INDEX idx_name (name)
);
```

### Table: `districts`

```sql
CREATE TABLE districts (
  id INT PRIMARY KEY,
  city_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,

  FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE,
  INDEX idx_city_id (city_id),
  INDEX idx_name (name)
);
```

---

## Categories

### Table: `categories`

```sql
CREATE TABLE categories (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE,
  description TEXT,
  emoji VARCHAR(10),
  gradient_colors JSON,
  product_count INT DEFAULT 0,
  display_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  INDEX idx_slug (slug),
  INDEX idx_display_order (display_order)
);
```

### Table: `subcategories`

```sql
CREATE TABLE subcategories (
  id VARCHAR(255) PRIMARY KEY,
  category_id VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE,
  description TEXT,
  product_count INT DEFAULT 0,
  display_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT true,

  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
  INDEX idx_category_id (category_id),
  INDEX idx_slug (slug)
);
```

---

## Reviews

### Table: `reviews`

```sql
CREATE TABLE reviews (
  id VARCHAR(255) PRIMARY KEY,
  product_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  order_id VARCHAR(255),
  rating DECIMAL(2,1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
  title VARCHAR(255),
  comment TEXT,
  is_verified_purchase BOOLEAN DEFAULT false,
  helpful_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  INDEX idx_product_id (product_id),
  INDEX idx_user_id (user_id),
  INDEX idx_rating (rating)
);
```

### Table: `review_images`

```sql
CREATE TABLE review_images (
  id VARCHAR(255) PRIMARY KEY,
  review_id VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  thumbnail_url TEXT,
  display_order INT DEFAULT 0,

  FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
  INDEX idx_review_id (review_id)
);
```

### Table: `review_helpful`

```sql
CREATE TABLE review_helpful (
  review_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (review_id, user_id),
  FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Table: `seller_responses`

```sql
CREATE TABLE seller_responses (
  id VARCHAR(255) PRIMARY KEY,
  review_id VARCHAR(255) UNIQUE NOT NULL,
  comment TEXT NOT NULL,
  responded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE
);
```

---

## Messaging

### Table: `conversations`

```sql
CREATE TABLE conversations (
  id VARCHAR(255) PRIMARY KEY,
  type ENUM('general', 'order', 'product') DEFAULT 'general',
  participant_1_id VARCHAR(255) NOT NULL,
  participant_2_id VARCHAR(255) NOT NULL,
  order_id VARCHAR(255),
  product_id VARCHAR(255),
  is_muted_p1 BOOLEAN DEFAULT false,
  is_muted_p2 BOOLEAN DEFAULT false,
  is_pinned_p1 BOOLEAN DEFAULT false,
  is_pinned_p2 BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (participant_1_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (participant_2_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL,
  INDEX idx_participant_1 (participant_1_id),
  INDEX idx_participant_2 (participant_2_id),
  INDEX idx_order_id (order_id),
  INDEX idx_product_id (product_id),
  UNIQUE KEY unique_participants_order (participant_1_id, participant_2_id, order_id)
);
```

### Table: `messages`

```sql
CREATE TABLE messages (
  id VARCHAR(255) PRIMARY KEY,
  conversation_id VARCHAR(255) NOT NULL,
  sender_id VARCHAR(255) NOT NULL,
  type ENUM('text', 'image', 'product', 'order', 'voice', 'system') DEFAULT 'text',
  content TEXT,
  reply_to_message_id VARCHAR(255),
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMP,
  is_edited BOOLEAN DEFAULT false,
  edited_at TIMESTAMP,
  deleted_for_sender BOOLEAN DEFAULT false,
  deleted_for_recipient BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (reply_to_message_id) REFERENCES messages(id) ON DELETE SET NULL,
  INDEX idx_conversation_id (conversation_id),
  INDEX idx_sender_id (sender_id),
  INDEX idx_created_at (created_at)
);
```

### Table: `message_images`

```sql
CREATE TABLE message_images (
  id VARCHAR(255) PRIMARY KEY,
  message_id VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  thumbnail_url TEXT,
  width INT,
  height INT,

  FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
  INDEX idx_message_id (message_id)
);
```

### Table: `message_reactions`

```sql
CREATE TABLE message_reactions (
  message_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  emoji VARCHAR(10) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (message_id, user_id),
  FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Table: `blocked_users`

```sql
CREATE TABLE blocked_users (
  blocker_id VARCHAR(255) NOT NULL,
  blocked_id VARCHAR(255) NOT NULL,
  blocked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (blocker_id, blocked_id),
  FOREIGN KEY (blocker_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (blocked_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## Notifications

### Table: `notifications`

```sql
CREATE TABLE notifications (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  type ENUM('order', 'message', 'promotion', 'price_alert', 'stock_alert', 'system') NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  icon VARCHAR(10),
  image TEXT,
  reference_type VARCHAR(50),
  reference_id VARCHAR(255),
  action_type VARCHAR(50),
  action_screen VARCHAR(100),
  action_params JSON,
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMP,
  priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_type (type),
  INDEX idx_is_read (is_read),
  INDEX idx_created_at (created_at)
);
```

### Table: `notification_settings`

```sql
CREATE TABLE notification_settings (
  user_id VARCHAR(255) PRIMARY KEY,
  order_updates BOOLEAN DEFAULT true,
  messages BOOLEAN DEFAULT true,
  promotions BOOLEAN DEFAULT true,
  price_alerts BOOLEAN DEFAULT true,
  stock_alerts BOOLEAN DEFAULT true,
  system_notifications BOOLEAN DEFAULT true,
  push_enabled BOOLEAN DEFAULT true,
  email_enabled BOOLEAN DEFAULT false,
  sound_enabled BOOLEAN DEFAULT true,
  vibration_enabled BOOLEAN DEFAULT true,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## Community Posts

### Table: `community_posts`

```sql
CREATE TABLE community_posts (
  id VARCHAR(255) PRIMARY KEY,
  farmer_id VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  location VARCHAR(255),
  type ENUM('general', 'harvest', 'tips', 'announcement', 'event') DEFAULT 'general',
  like_count INT DEFAULT 0,
  comment_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (farmer_id) REFERENCES farmers(id) ON DELETE CASCADE,
  INDEX idx_farmer_id (farmer_id),
  INDEX idx_type (type),
  INDEX idx_created_at (created_at)
);
```

### Table: `post_images`

```sql
CREATE TABLE post_images (
  id VARCHAR(255) PRIMARY KEY,
  post_id VARCHAR(255) NOT NULL,
  url TEXT NOT NULL,
  display_order INT DEFAULT 0,

  FOREIGN KEY (post_id) REFERENCES community_posts(id) ON DELETE CASCADE,
  INDEX idx_post_id (post_id)
);
```

### Table: `post_tags`

```sql
CREATE TABLE post_tags (
  post_id VARCHAR(255) NOT NULL,
  tag VARCHAR(100) NOT NULL,

  PRIMARY KEY (post_id, tag),
  FOREIGN KEY (post_id) REFERENCES community_posts(id) ON DELETE CASCADE,
  INDEX idx_tag (tag)
);
```

### Table: `post_likes`

```sql
CREATE TABLE post_likes (
  post_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (post_id, user_id),
  FOREIGN KEY (post_id) REFERENCES community_posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Table: `post_comments`

```sql
CREATE TABLE post_comments (
  id VARCHAR(255) PRIMARY KEY,
  post_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  like_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (post_id) REFERENCES community_posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_post_id (post_id),
  INDEX idx_user_id (user_id)
);
```

### Table: `comment_likes`

```sql
CREATE TABLE comment_likes (
  comment_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (comment_id, user_id),
  FOREIGN KEY (comment_id) REFERENCES post_comments(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

---

## Utility & Media

### Table: `uploaded_images`

```sql
CREATE TABLE uploaded_images (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  url TEXT NOT NULL,
  thumbnail_url TEXT,
  medium_url TEXT,
  size INT,
  width INT,
  height INT,
  format VARCHAR(10),
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_type (type)
);
```

### Table: `uploaded_videos`

```sql
CREATE TABLE uploaded_videos (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  type VARCHAR(50) NOT NULL,
  url TEXT NOT NULL,
  hls_url TEXT,
  thumbnail_url TEXT,
  duration INT,
  size INT,
  format VARCHAR(10),
  resolution VARCHAR(20),
  upload_status ENUM('uploading', 'processing', 'completed', 'failed') DEFAULT 'uploading',
  progress INT DEFAULT 0,
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_type (type),
  INDEX idx_status (upload_status)
);
```

### Table: `share_links`

```sql
CREATE TABLE share_links (
  id VARCHAR(255) PRIMARY KEY,
  short_code VARCHAR(20) UNIQUE NOT NULL,
  type VARCHAR(50) NOT NULL,
  reference_id VARCHAR(255) NOT NULL,
  share_url TEXT NOT NULL,
  short_url TEXT NOT NULL,
  deep_link TEXT,
  qr_code_url TEXT,
  click_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  INDEX idx_short_code (short_code),
  INDEX idx_type (type),
  INDEX idx_reference_id (reference_id)
);
```

### Table: `app_settings`

```sql
CREATE TABLE app_settings (
  user_id VARCHAR(255) PRIMARY KEY,
  theme VARCHAR(20) DEFAULT 'light',
  language VARCHAR(10) DEFAULT 'en',
  currency VARCHAR(10) DEFAULT 'IDR',
  notifications_enabled BOOLEAN DEFAULT true,
  sound_enabled BOOLEAN DEFAULT true,
  vibration_enabled BOOLEAN DEFAULT true,
  show_online_status BOOLEAN DEFAULT true,
  show_last_seen BOOLEAN DEFAULT true,
  text_size VARCHAR(20) DEFAULT 'medium',
  data_saver BOOLEAN DEFAULT false,
  auto_play_videos BOOLEAN DEFAULT true,
  search_history_enabled BOOLEAN DEFAULT true,
  location_services_enabled BOOLEAN DEFAULT true,
  biometric_enabled BOOLEAN DEFAULT false,
  synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Table: `security_settings`

```sql
CREATE TABLE security_settings (
  user_id VARCHAR(255) PRIMARY KEY,
  two_factor_enabled BOOLEAN DEFAULT false,
  two_factor_method VARCHAR(20),
  biometric_enabled BOOLEAN DEFAULT false,
  session_timeout INT DEFAULT 30,
  login_alerts BOOLEAN DEFAULT true,
  password_changed_at TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Table: `favorites`

```sql
CREATE TABLE favorites (
  user_id VARCHAR(255) NOT NULL,
  product_id VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (user_id, product_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_product_id (product_id)
);
```

### Table: `product_views`

```sql
CREATE TABLE product_views (
  id VARCHAR(255) PRIMARY KEY,
  product_id VARCHAR(255) NOT NULL,
  user_id VARCHAR(255),
  ip_address VARCHAR(45),
  user_agent TEXT,
  viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_product_id (product_id),
  INDEX idx_user_id (user_id),
  INDEX idx_viewed_at (viewed_at)
);
```

### Table: `search_history`

```sql
CREATE TABLE search_history (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) NOT NULL,
  query TEXT NOT NULL,
  result_count INT DEFAULT 0,
  searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user_id (user_id),
  INDEX idx_searched_at (searched_at)
);
```

---

## Additional Indexes and Optimizations

```sql
-- Composite indexes for common queries
CREATE INDEX idx_products_seller_available ON products(seller_id, is_available);
CREATE INDEX idx_products_category_available ON products(category_id, is_available);
CREATE INDEX idx_orders_buyer_status ON orders(buyer_id, status);
CREATE INDEX idx_orders_seller_status ON orders(seller_id, status);
CREATE INDEX idx_messages_conversation_created ON messages(conversation_id, created_at DESC);
CREATE INDEX idx_notifications_user_unread ON notifications(user_id, is_read, created_at DESC);

-- Full-text search indexes
CREATE FULLTEXT INDEX idx_products_fulltext ON products(name, description, long_description);
CREATE FULLTEXT INDEX idx_farmers_fulltext ON farmers(name, description);
```

---

## Notes

1. **ID Generation**: Use UUIDs or nanoid for all primary keys
2. **Timestamps**: All timestamps should be stored in UTC
3. **Currency**: Store prices as integers (cents/smallest unit) for accuracy, or use DECIMAL(10,2)
4. **Soft Deletes**: Consider adding `deleted_at` columns for important tables
5. **Pagination**: Implement cursor-based pagination for large datasets
6. **Caching**: Use Redis for frequently accessed data (products, categories, user sessions)
7. **File Storage**: Use cloud storage (S3, Cloudinary) for images and videos
8. **Search**: Consider using Elasticsearch or Algolia for advanced product search
9. **Real-time**: Use WebSockets or Server-Sent Events for messaging and notifications
10. **Security**: Implement rate limiting, input validation, and proper authentication
