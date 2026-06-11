// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FarmersTable extends Farmers with TableInfo<$FarmersTable, FarmerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmerIdMeta =
      const VerificationMeta('farmerId');
  @override
  late final GeneratedColumn<String> farmerId = GeneratedColumn<String>(
      'farmer_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmerProfileMeta =
      const VerificationMeta('farmerProfile');
  @override
  late final GeneratedColumn<String> farmerProfile = GeneratedColumn<String>(
      'farmer_profile', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _whatWeSellMeta =
      const VerificationMeta('whatWeSell');
  @override
  late final GeneratedColumn<String> whatWeSell = GeneratedColumn<String>(
      'what_we_sell', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _distanceMeta =
      const VerificationMeta('distance');
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
      'distance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmerId,
        farmerProfile,
        name,
        description,
        whatWeSell,
        latitude,
        longitude,
        address,
        imageUrl,
        isActive,
        createdAt,
        distance,
        lastSyncedAt,
        isDirty
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farmers';
  @override
  VerificationContext validateIntegrity(Insertable<FarmerData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farmer_id')) {
      context.handle(_farmerIdMeta,
          farmerId.isAcceptableOrUnknown(data['farmer_id']!, _farmerIdMeta));
    } else if (isInserting) {
      context.missing(_farmerIdMeta);
    }
    if (data.containsKey('farmer_profile')) {
      context.handle(
          _farmerProfileMeta,
          farmerProfile.isAcceptableOrUnknown(
              data['farmer_profile']!, _farmerProfileMeta));
    } else if (isInserting) {
      context.missing(_farmerProfileMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('what_we_sell')) {
      context.handle(
          _whatWeSellMeta,
          whatWeSell.isAcceptableOrUnknown(
              data['what_we_sell']!, _whatWeSellMeta));
    } else if (isInserting) {
      context.missing(_whatWeSellMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmerData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farmer_id'])!,
      farmerProfile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farmer_profile'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      whatWeSell: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}what_we_sell'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      distance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance']),
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
    );
  }

  @override
  $FarmersTable createAlias(String alias) {
    return $FarmersTable(attachedDatabase, alias);
  }
}

class FarmerData extends DataClass implements Insertable<FarmerData> {
  final String id;
  final String farmerId;
  final String farmerProfile;
  final String name;
  final String description;
  final String whatWeSell;
  final double latitude;
  final double longitude;
  final String address;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final double? distance;
  final DateTime lastSyncedAt;
  final bool isDirty;
  const FarmerData(
      {required this.id,
      required this.farmerId,
      required this.farmerProfile,
      required this.name,
      required this.description,
      required this.whatWeSell,
      required this.latitude,
      required this.longitude,
      required this.address,
      this.imageUrl,
      required this.isActive,
      required this.createdAt,
      this.distance,
      required this.lastSyncedAt,
      required this.isDirty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farmer_id'] = Variable<String>(farmerId);
    map['farmer_profile'] = Variable<String>(farmerProfile);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['what_we_sell'] = Variable<String>(whatWeSell);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || distance != null) {
      map['distance'] = Variable<double>(distance);
    }
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    map['is_dirty'] = Variable<bool>(isDirty);
    return map;
  }

  FarmersCompanion toCompanion(bool nullToAbsent) {
    return FarmersCompanion(
      id: Value(id),
      farmerId: Value(farmerId),
      farmerProfile: Value(farmerProfile),
      name: Value(name),
      description: Value(description),
      whatWeSell: Value(whatWeSell),
      latitude: Value(latitude),
      longitude: Value(longitude),
      address: Value(address),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      distance: distance == null && nullToAbsent
          ? const Value.absent()
          : Value(distance),
      lastSyncedAt: Value(lastSyncedAt),
      isDirty: Value(isDirty),
    );
  }

  factory FarmerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmerData(
      id: serializer.fromJson<String>(json['id']),
      farmerId: serializer.fromJson<String>(json['farmerId']),
      farmerProfile: serializer.fromJson<String>(json['farmerProfile']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      whatWeSell: serializer.fromJson<String>(json['whatWeSell']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      address: serializer.fromJson<String>(json['address']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      distance: serializer.fromJson<double?>(json['distance']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmerId': serializer.toJson<String>(farmerId),
      'farmerProfile': serializer.toJson<String>(farmerProfile),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'whatWeSell': serializer.toJson<String>(whatWeSell),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'address': serializer.toJson<String>(address),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'distance': serializer.toJson<double?>(distance),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
      'isDirty': serializer.toJson<bool>(isDirty),
    };
  }

  FarmerData copyWith(
          {String? id,
          String? farmerId,
          String? farmerProfile,
          String? name,
          String? description,
          String? whatWeSell,
          double? latitude,
          double? longitude,
          String? address,
          Value<String?> imageUrl = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          Value<double?> distance = const Value.absent(),
          DateTime? lastSyncedAt,
          bool? isDirty}) =>
      FarmerData(
        id: id ?? this.id,
        farmerId: farmerId ?? this.farmerId,
        farmerProfile: farmerProfile ?? this.farmerProfile,
        name: name ?? this.name,
        description: description ?? this.description,
        whatWeSell: whatWeSell ?? this.whatWeSell,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        distance: distance.present ? distance.value : this.distance,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        isDirty: isDirty ?? this.isDirty,
      );
  FarmerData copyWithCompanion(FarmersCompanion data) {
    return FarmerData(
      id: data.id.present ? data.id.value : this.id,
      farmerId: data.farmerId.present ? data.farmerId.value : this.farmerId,
      farmerProfile: data.farmerProfile.present
          ? data.farmerProfile.value
          : this.farmerProfile,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      whatWeSell:
          data.whatWeSell.present ? data.whatWeSell.value : this.whatWeSell,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      address: data.address.present ? data.address.value : this.address,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      distance: data.distance.present ? data.distance.value : this.distance,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmerData(')
          ..write('id: $id, ')
          ..write('farmerId: $farmerId, ')
          ..write('farmerProfile: $farmerProfile, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('whatWeSell: $whatWeSell, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('distance: $distance, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('isDirty: $isDirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      farmerId,
      farmerProfile,
      name,
      description,
      whatWeSell,
      latitude,
      longitude,
      address,
      imageUrl,
      isActive,
      createdAt,
      distance,
      lastSyncedAt,
      isDirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmerData &&
          other.id == this.id &&
          other.farmerId == this.farmerId &&
          other.farmerProfile == this.farmerProfile &&
          other.name == this.name &&
          other.description == this.description &&
          other.whatWeSell == this.whatWeSell &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.address == this.address &&
          other.imageUrl == this.imageUrl &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.distance == this.distance &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.isDirty == this.isDirty);
}

class FarmersCompanion extends UpdateCompanion<FarmerData> {
  final Value<String> id;
  final Value<String> farmerId;
  final Value<String> farmerProfile;
  final Value<String> name;
  final Value<String> description;
  final Value<String> whatWeSell;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> address;
  final Value<String?> imageUrl;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<double?> distance;
  final Value<DateTime> lastSyncedAt;
  final Value<bool> isDirty;
  final Value<int> rowid;
  const FarmersCompanion({
    this.id = const Value.absent(),
    this.farmerId = const Value.absent(),
    this.farmerProfile = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.whatWeSell = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.distance = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmersCompanion.insert({
    required String id,
    required String farmerId,
    required String farmerProfile,
    required String name,
    required String description,
    required String whatWeSell,
    required double latitude,
    required double longitude,
    required String address,
    this.imageUrl = const Value.absent(),
    required bool isActive,
    required DateTime createdAt,
    this.distance = const Value.absent(),
    required DateTime lastSyncedAt,
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmerId = Value(farmerId),
        farmerProfile = Value(farmerProfile),
        name = Value(name),
        description = Value(description),
        whatWeSell = Value(whatWeSell),
        latitude = Value(latitude),
        longitude = Value(longitude),
        address = Value(address),
        isActive = Value(isActive),
        createdAt = Value(createdAt),
        lastSyncedAt = Value(lastSyncedAt);
  static Insertable<FarmerData> custom({
    Expression<String>? id,
    Expression<String>? farmerId,
    Expression<String>? farmerProfile,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? whatWeSell,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? address,
    Expression<String>? imageUrl,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<double>? distance,
    Expression<DateTime>? lastSyncedAt,
    Expression<bool>? isDirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmerId != null) 'farmer_id': farmerId,
      if (farmerProfile != null) 'farmer_profile': farmerProfile,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (whatWeSell != null) 'what_we_sell': whatWeSell,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (distance != null) 'distance': distance,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (isDirty != null) 'is_dirty': isDirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmersCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmerId,
      Value<String>? farmerProfile,
      Value<String>? name,
      Value<String>? description,
      Value<String>? whatWeSell,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String>? address,
      Value<String?>? imageUrl,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<double?>? distance,
      Value<DateTime>? lastSyncedAt,
      Value<bool>? isDirty,
      Value<int>? rowid}) {
    return FarmersCompanion(
      id: id ?? this.id,
      farmerId: farmerId ?? this.farmerId,
      farmerProfile: farmerProfile ?? this.farmerProfile,
      name: name ?? this.name,
      description: description ?? this.description,
      whatWeSell: whatWeSell ?? this.whatWeSell,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      distance: distance ?? this.distance,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isDirty: isDirty ?? this.isDirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmerId.present) {
      map['farmer_id'] = Variable<String>(farmerId.value);
    }
    if (farmerProfile.present) {
      map['farmer_profile'] = Variable<String>(farmerProfile.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (whatWeSell.present) {
      map['what_we_sell'] = Variable<String>(whatWeSell.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmersCompanion(')
          ..write('id: $id, ')
          ..write('farmerId: $farmerId, ')
          ..write('farmerProfile: $farmerProfile, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('whatWeSell: $whatWeSell, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('distance: $distance, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FarmersTable farmers = $FarmersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [farmers];
}

typedef $$FarmersTableCreateCompanionBuilder = FarmersCompanion Function({
  required String id,
  required String farmerId,
  required String farmerProfile,
  required String name,
  required String description,
  required String whatWeSell,
  required double latitude,
  required double longitude,
  required String address,
  Value<String?> imageUrl,
  required bool isActive,
  required DateTime createdAt,
  Value<double?> distance,
  required DateTime lastSyncedAt,
  Value<bool> isDirty,
  Value<int> rowid,
});
typedef $$FarmersTableUpdateCompanionBuilder = FarmersCompanion Function({
  Value<String> id,
  Value<String> farmerId,
  Value<String> farmerProfile,
  Value<String> name,
  Value<String> description,
  Value<String> whatWeSell,
  Value<double> latitude,
  Value<double> longitude,
  Value<String> address,
  Value<String?> imageUrl,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<double?> distance,
  Value<DateTime> lastSyncedAt,
  Value<bool> isDirty,
  Value<int> rowid,
});

class $$FarmersTableFilterComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmerId => $composableBuilder(
      column: $table.farmerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmerProfile => $composableBuilder(
      column: $table.farmerProfile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatWeSell => $composableBuilder(
      column: $table.whatWeSell, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));
}

class $$FarmersTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmerId => $composableBuilder(
      column: $table.farmerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmerProfile => $composableBuilder(
      column: $table.farmerProfile,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatWeSell => $composableBuilder(
      column: $table.whatWeSell, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));
}

class $$FarmersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmersTable> {
  $$FarmersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmerId =>
      $composableBuilder(column: $table.farmerId, builder: (column) => column);

  GeneratedColumn<String> get farmerProfile => $composableBuilder(
      column: $table.farmerProfile, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get whatWeSell => $composableBuilder(
      column: $table.whatWeSell, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);
}

class $$FarmersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FarmersTable,
    FarmerData,
    $$FarmersTableFilterComposer,
    $$FarmersTableOrderingComposer,
    $$FarmersTableAnnotationComposer,
    $$FarmersTableCreateCompanionBuilder,
    $$FarmersTableUpdateCompanionBuilder,
    (FarmerData, BaseReferences<_$AppDatabase, $FarmersTable, FarmerData>),
    FarmerData,
    PrefetchHooks Function()> {
  $$FarmersTableTableManager(_$AppDatabase db, $FarmersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmerId = const Value.absent(),
            Value<String> farmerProfile = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> whatWeSell = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<double?> distance = const Value.absent(),
            Value<DateTime> lastSyncedAt = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmersCompanion(
            id: id,
            farmerId: farmerId,
            farmerProfile: farmerProfile,
            name: name,
            description: description,
            whatWeSell: whatWeSell,
            latitude: latitude,
            longitude: longitude,
            address: address,
            imageUrl: imageUrl,
            isActive: isActive,
            createdAt: createdAt,
            distance: distance,
            lastSyncedAt: lastSyncedAt,
            isDirty: isDirty,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmerId,
            required String farmerProfile,
            required String name,
            required String description,
            required String whatWeSell,
            required double latitude,
            required double longitude,
            required String address,
            Value<String?> imageUrl = const Value.absent(),
            required bool isActive,
            required DateTime createdAt,
            Value<double?> distance = const Value.absent(),
            required DateTime lastSyncedAt,
            Value<bool> isDirty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmersCompanion.insert(
            id: id,
            farmerId: farmerId,
            farmerProfile: farmerProfile,
            name: name,
            description: description,
            whatWeSell: whatWeSell,
            latitude: latitude,
            longitude: longitude,
            address: address,
            imageUrl: imageUrl,
            isActive: isActive,
            createdAt: createdAt,
            distance: distance,
            lastSyncedAt: lastSyncedAt,
            isDirty: isDirty,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FarmersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FarmersTable,
    FarmerData,
    $$FarmersTableFilterComposer,
    $$FarmersTableOrderingComposer,
    $$FarmersTableAnnotationComposer,
    $$FarmersTableCreateCompanionBuilder,
    $$FarmersTableUpdateCompanionBuilder,
    (FarmerData, BaseReferences<_$AppDatabase, $FarmersTable, FarmerData>),
    FarmerData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FarmersTableTableManager get farmers =>
      $$FarmersTableTableManager(_db, _db.farmers);
}
