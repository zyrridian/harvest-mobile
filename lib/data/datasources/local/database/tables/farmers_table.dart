import 'package:drift/drift.dart';

@DataClassName('FarmerData')
class Farmers extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().named('user_id')();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get profileImage => text().named('profile_image').nullable()();
  TextColumn get coverImage => text().named('cover_image').nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  RealColumn get rating => real()();
  IntColumn get totalReviews => integer().named('total_reviews')();
  IntColumn get totalProducts => integer().named('total_products')();
  TextColumn get specialties => text()(); // JSON encoded list
  BoolColumn get isVerified => boolean().named('is_verified')();
  BoolColumn get hasMapFeature => boolean().named('has_map_feature')();
  TextColumn get phoneNumber => text().named('phone_number').nullable()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get joinedDate => dateTime().named('joined_date')();
  BoolColumn get isOnline => boolean().named('is_online')();
  RealColumn get distance => real().nullable()();
  TextColumn get verificationBadge => text().named('verification_badge').nullable()();
  RealColumn get responseRate => real().named('response_rate').nullable()();
  IntColumn get followersCount => integer().named('followers_count').nullable()();
  
  DateTimeColumn get lastSyncedAt => dateTime().named('last_synced_at')();
  BoolColumn get isDirty =>
      boolean().named('is_dirty').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
