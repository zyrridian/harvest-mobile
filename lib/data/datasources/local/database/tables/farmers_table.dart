import 'package:drift/drift.dart';

@DataClassName('FarmerData')
class Farmers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get profileImage => text().named('profile_image')();
  TextColumn get coverImage => text().named('cover_image')();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text()();
  TextColumn get city => text()();
  TextColumn get state => text()();
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
  DateTimeColumn get lastSyncedAt => dateTime().named('last_synced_at')();
  BoolColumn get isDirty =>
      boolean().named('is_dirty').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
