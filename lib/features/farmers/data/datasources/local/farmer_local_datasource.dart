import 'dart:convert';
import 'package:drift/drift.dart';
import '../../models/farmer_model.dart';
import '../../../../../core/database/app_database.dart';

abstract class FarmerLocalDataSource {
  /// Get all farmers from local database
  Future<List<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  });

  /// Get a single farmer by ID
  Future<FarmerModel?> getFarmerById(String id);

  /// Get nearby farmers from local database
  Future<List<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  });

  /// Save/Update a single farmer
  Future<void> saveFarmer(FarmerModel farmer);

  /// Save/Update multiple farmers
  Future<void> saveFarmers(List<FarmerModel> farmers);

  /// Delete a farmer
  Future<void> deleteFarmer(String id);

  /// Clear all farmers
  Future<void> clearAllFarmers();

  /// Get farmers that need syncing (dirty flag)
  Future<List<FarmerModel>> getDirtyFarmers();

  /// Mark farmer as synced
  Future<void> markAsSynced(String id);

  /// Get last sync time
  Future<DateTime?> getLastSyncTime();

  /// Update last sync time
  Future<void> updateLastSyncTime(DateTime time);
}

class FarmerLocalDataSourceImpl implements FarmerLocalDataSource {
  final AppDatabase database;

  FarmerLocalDataSourceImpl(this.database);

  @override
  Future<List<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) async {
    var selectQuery = database.select(database.farmers);

    // Apply filters
    if (query != null && query.isNotEmpty) {
      selectQuery = selectQuery
        ..where((tbl) =>
            tbl.name.contains(query) | tbl.description.contains(query));
    }

    if (maxDistance != null) {
      selectQuery = selectQuery
        ..where((tbl) => tbl.distance.isSmallerOrEqualValue(maxDistance));
    }

    final farmerDataList = await selectQuery.get();

    // Filter by specialties
    var farmers = farmerDataList.map(_toModel).toList();

    if (specialties != null && specialties.isNotEmpty) {
      farmers = farmers.where((farmer) {
        return specialties
            .any((specialty) => farmer.specialties.contains(specialty));
      }).toList();
    }

    return farmers;
  }

  @override
  Future<FarmerModel?> getFarmerById(String id) async {
    final farmerData = await (database.select(database.farmers)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    return farmerData != null ? _toModel(farmerData) : null;
  }

  @override
  Future<List<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    final allFarmers = await database.select(database.farmers).get();

    // Filter by radius and sort by distance
    final nearbyFarmers = allFarmers
        .where((farmer) {
          if (farmer.distance == null) return false;
          return farmer.distance! <= radius;
        })
        .map(_toModel)
        .toList();

    nearbyFarmers.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

    return nearbyFarmers;
  }

  @override
  Future<void> saveFarmer(FarmerModel farmer) async {
    await database.into(database.farmers).insertOnConflictUpdate(
          _toCompanion(farmer),
        );
  }

  @override
  Future<void> saveFarmers(List<FarmerModel> farmers) async {
    await database.batch((batch) {
      batch.insertAllOnConflictUpdate(
        database.farmers,
        farmers.map((farmer) => _toCompanion(farmer)),
      );
    });
  }

  @override
  Future<void> deleteFarmer(String id) async {
    await (database.delete(database.farmers)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<void> clearAllFarmers() async {
    await database.delete(database.farmers).go();
  }

  @override
  Future<List<FarmerModel>> getDirtyFarmers() async {
    final dirtyFarmers = await (database.select(database.farmers)
          ..where((tbl) => tbl.isDirty.equals(true)))
        .get();

    return dirtyFarmers.map(_toModel).toList();
  }

  @override
  Future<void> markAsSynced(String id) async {
    await (database.update(database.farmers)..where((tbl) => tbl.id.equals(id)))
        .write(const FarmersCompanion(
      isDirty: Value(false),
      lastSyncedAt: Value.absentIfNull(null),
    ));
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    // You can store this in a separate settings table or shared preferences
    // For now, we'll get the latest lastSyncedAt from farmers
    final result = await (database.select(database.farmers)
          ..orderBy([(t) => OrderingTerm.desc(t.lastSyncedAt)])
          ..limit(1))
        .getSingleOrNull();

    return result?.lastSyncedAt;
  }

  @override
  Future<void> updateLastSyncTime(DateTime time) async {
    // This would typically update a settings table
    // For now, it's a no-op since we track per-farmer sync times
  }

  FarmersCompanion _toCompanion(FarmerModel farmer) {
    return FarmersCompanion(
      id: Value(farmer.id),
      userId: Value(farmer.userId),
      name: Value(farmer.name),
      description: Value(farmer.description),
      profileImage: Value(farmer.profileImage),
      coverImage: Value(farmer.coverImage),
      latitude: Value(farmer.latitude),
      longitude: Value(farmer.longitude),
      address: Value(farmer.address),
      city: Value(farmer.city),
      state: Value(farmer.state),
      rating: Value(farmer.rating),
      totalReviews: Value(farmer.totalReviews),
      totalProducts: Value(farmer.totalProducts),
      specialties: Value(jsonEncode(farmer.specialties)),
      isVerified: Value(farmer.isVerified),
      hasMapFeature: Value(farmer.hasMapFeature),
      phoneNumber: Value(farmer.phoneNumber),
      email: Value(farmer.email),
      joinedDate: Value(DateTime.parse(farmer.joinedDate)),
      isOnline: Value(farmer.isOnline),
      distance: Value(farmer.distance),
      verificationBadge: Value(farmer.verificationBadge),
      responseRate: Value(farmer.responseRate),
      followersCount: Value(farmer.followersCount),
      lastSyncedAt: Value(DateTime.now()),
      isDirty: const Value(false),
    );
  }

  /// Helper method to convert FarmerData to FarmerModel
  FarmerModel _toModel(FarmerData data) {
    return FarmerModel(
      id: data.id,
      userId: data.userId,
      name: data.name,
      description: data.description,
      profileImage: data.profileImage,
      coverImage: data.coverImage,
      latitude: data.latitude,
      longitude: data.longitude,
      address: data.address,
      city: data.city,
      state: data.state,
      rating: data.rating,
      totalReviews: data.totalReviews,
      totalProducts: data.totalProducts,
      specialties: List<String>.from(jsonDecode(data.specialties)),
      isVerified: data.isVerified,
      hasMapFeature: data.hasMapFeature,
      phoneNumber: data.phoneNumber,
      email: data.email,
      joinedDate: data.joinedDate.toIso8601String(),
      isOnline: data.isOnline,
      distance: data.distance,
      verificationBadge: data.verificationBadge,
      responseRate: data.responseRate,
      followersCount: data.followersCount,
    );
  }
}
