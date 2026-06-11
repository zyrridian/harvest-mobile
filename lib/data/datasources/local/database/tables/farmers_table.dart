import 'package:drift/drift.dart';

@DataClassName('FarmerData')
class Farmers extends Table {
  TextColumn get id => text()();
  TextColumn get farmerId => text().named('farmer_id')();
  TextColumn get farmerProfile => text().named('farmer_profile')(); // JSON encoded FarmerProfile
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get whatWeSell => text().named('what_we_sell')();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get address => text()();
  TextColumn get imageUrl => text().named('image_url').nullable()();
  BoolColumn get isActive => boolean().named('is_active')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  RealColumn get distance => real().nullable()();
  
  DateTimeColumn get lastSyncedAt => dateTime().named('last_synced_at')();
  BoolColumn get isDirty =>
      boolean().named('is_dirty').withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
