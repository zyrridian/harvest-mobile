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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
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
  static const VerificationMeta _profileImageMeta =
      const VerificationMeta('profileImage');
  @override
  late final GeneratedColumn<String> profileImage = GeneratedColumn<String>(
      'profile_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverImageMeta =
      const VerificationMeta('coverImage');
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
      'cover_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
      'rating', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalReviewsMeta =
      const VerificationMeta('totalReviews');
  @override
  late final GeneratedColumn<int> totalReviews = GeneratedColumn<int>(
      'total_reviews', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalProductsMeta =
      const VerificationMeta('totalProducts');
  @override
  late final GeneratedColumn<int> totalProducts = GeneratedColumn<int>(
      'total_products', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _specialtiesMeta =
      const VerificationMeta('specialties');
  @override
  late final GeneratedColumn<String> specialties = GeneratedColumn<String>(
      'specialties', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isVerifiedMeta =
      const VerificationMeta('isVerified');
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
      'is_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_verified" IN (0, 1))'));
  static const VerificationMeta _hasMapFeatureMeta =
      const VerificationMeta('hasMapFeature');
  @override
  late final GeneratedColumn<bool> hasMapFeature = GeneratedColumn<bool>(
      'has_map_feature', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_map_feature" IN (0, 1))'));
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _joinedDateMeta =
      const VerificationMeta('joinedDate');
  @override
  late final GeneratedColumn<DateTime> joinedDate = GeneratedColumn<DateTime>(
      'joined_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isOnlineMeta =
      const VerificationMeta('isOnline');
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
      'is_online', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_online" IN (0, 1))'));
  static const VerificationMeta _distanceMeta =
      const VerificationMeta('distance');
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
      'distance', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _verificationBadgeMeta =
      const VerificationMeta('verificationBadge');
  @override
  late final GeneratedColumn<String> verificationBadge =
      GeneratedColumn<String>('verification_badge', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _responseRateMeta =
      const VerificationMeta('responseRate');
  @override
  late final GeneratedColumn<double> responseRate = GeneratedColumn<double>(
      'response_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _followersCountMeta =
      const VerificationMeta('followersCount');
  @override
  late final GeneratedColumn<int> followersCount = GeneratedColumn<int>(
      'followers_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
        userId,
        name,
        description,
        profileImage,
        coverImage,
        latitude,
        longitude,
        address,
        city,
        state,
        rating,
        totalReviews,
        totalProducts,
        specialties,
        isVerified,
        hasMapFeature,
        phoneNumber,
        email,
        joinedDate,
        isOnline,
        distance,
        verificationBadge,
        responseRate,
        followersCount,
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
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
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
    if (data.containsKey('profile_image')) {
      context.handle(
          _profileImageMeta,
          profileImage.isAcceptableOrUnknown(
              data['profile_image']!, _profileImageMeta));
    }
    if (data.containsKey('cover_image')) {
      context.handle(
          _coverImageMeta,
          coverImage.isAcceptableOrUnknown(
              data['cover_image']!, _coverImageMeta));
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
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('total_reviews')) {
      context.handle(
          _totalReviewsMeta,
          totalReviews.isAcceptableOrUnknown(
              data['total_reviews']!, _totalReviewsMeta));
    } else if (isInserting) {
      context.missing(_totalReviewsMeta);
    }
    if (data.containsKey('total_products')) {
      context.handle(
          _totalProductsMeta,
          totalProducts.isAcceptableOrUnknown(
              data['total_products']!, _totalProductsMeta));
    } else if (isInserting) {
      context.missing(_totalProductsMeta);
    }
    if (data.containsKey('specialties')) {
      context.handle(
          _specialtiesMeta,
          specialties.isAcceptableOrUnknown(
              data['specialties']!, _specialtiesMeta));
    } else if (isInserting) {
      context.missing(_specialtiesMeta);
    }
    if (data.containsKey('is_verified')) {
      context.handle(
          _isVerifiedMeta,
          isVerified.isAcceptableOrUnknown(
              data['is_verified']!, _isVerifiedMeta));
    } else if (isInserting) {
      context.missing(_isVerifiedMeta);
    }
    if (data.containsKey('has_map_feature')) {
      context.handle(
          _hasMapFeatureMeta,
          hasMapFeature.isAcceptableOrUnknown(
              data['has_map_feature']!, _hasMapFeatureMeta));
    } else if (isInserting) {
      context.missing(_hasMapFeatureMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('joined_date')) {
      context.handle(
          _joinedDateMeta,
          joinedDate.isAcceptableOrUnknown(
              data['joined_date']!, _joinedDateMeta));
    } else if (isInserting) {
      context.missing(_joinedDateMeta);
    }
    if (data.containsKey('is_online')) {
      context.handle(_isOnlineMeta,
          isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta));
    } else if (isInserting) {
      context.missing(_isOnlineMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    }
    if (data.containsKey('verification_badge')) {
      context.handle(
          _verificationBadgeMeta,
          verificationBadge.isAcceptableOrUnknown(
              data['verification_badge']!, _verificationBadgeMeta));
    }
    if (data.containsKey('response_rate')) {
      context.handle(
          _responseRateMeta,
          responseRate.isAcceptableOrUnknown(
              data['response_rate']!, _responseRateMeta));
    }
    if (data.containsKey('followers_count')) {
      context.handle(
          _followersCountMeta,
          followersCount.isAcceptableOrUnknown(
              data['followers_count']!, _followersCountMeta));
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
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      profileImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_image']),
      coverImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_image']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state']),
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rating'])!,
      totalReviews: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_reviews'])!,
      totalProducts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_products'])!,
      specialties: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specialties'])!,
      isVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_verified'])!,
      hasMapFeature: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_map_feature'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      joinedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_date'])!,
      isOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_online'])!,
      distance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance']),
      verificationBadge: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}verification_badge']),
      responseRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}response_rate']),
      followersCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}followers_count']),
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
  final String userId;
  final String name;
  final String description;
  final String? profileImage;
  final String? coverImage;
  final double latitude;
  final double longitude;
  final String address;
  final String? city;
  final String? state;
  final double rating;
  final int totalReviews;
  final int totalProducts;
  final String specialties;
  final bool isVerified;
  final bool hasMapFeature;
  final String? phoneNumber;
  final String? email;
  final DateTime joinedDate;
  final bool isOnline;
  final double? distance;
  final String? verificationBadge;
  final double? responseRate;
  final int? followersCount;
  final DateTime lastSyncedAt;
  final bool isDirty;
  const FarmerData(
      {required this.id,
      required this.userId,
      required this.name,
      required this.description,
      this.profileImage,
      this.coverImage,
      required this.latitude,
      required this.longitude,
      required this.address,
      this.city,
      this.state,
      required this.rating,
      required this.totalReviews,
      required this.totalProducts,
      required this.specialties,
      required this.isVerified,
      required this.hasMapFeature,
      this.phoneNumber,
      this.email,
      required this.joinedDate,
      required this.isOnline,
      this.distance,
      this.verificationBadge,
      this.responseRate,
      this.followersCount,
      required this.lastSyncedAt,
      required this.isDirty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || profileImage != null) {
      map['profile_image'] = Variable<String>(profileImage);
    }
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    map['rating'] = Variable<double>(rating);
    map['total_reviews'] = Variable<int>(totalReviews);
    map['total_products'] = Variable<int>(totalProducts);
    map['specialties'] = Variable<String>(specialties);
    map['is_verified'] = Variable<bool>(isVerified);
    map['has_map_feature'] = Variable<bool>(hasMapFeature);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['joined_date'] = Variable<DateTime>(joinedDate);
    map['is_online'] = Variable<bool>(isOnline);
    if (!nullToAbsent || distance != null) {
      map['distance'] = Variable<double>(distance);
    }
    if (!nullToAbsent || verificationBadge != null) {
      map['verification_badge'] = Variable<String>(verificationBadge);
    }
    if (!nullToAbsent || responseRate != null) {
      map['response_rate'] = Variable<double>(responseRate);
    }
    if (!nullToAbsent || followersCount != null) {
      map['followers_count'] = Variable<int>(followersCount);
    }
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    map['is_dirty'] = Variable<bool>(isDirty);
    return map;
  }

  FarmersCompanion toCompanion(bool nullToAbsent) {
    return FarmersCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      description: Value(description),
      profileImage: profileImage == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImage),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      latitude: Value(latitude),
      longitude: Value(longitude),
      address: Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state:
          state == null && nullToAbsent ? const Value.absent() : Value(state),
      rating: Value(rating),
      totalReviews: Value(totalReviews),
      totalProducts: Value(totalProducts),
      specialties: Value(specialties),
      isVerified: Value(isVerified),
      hasMapFeature: Value(hasMapFeature),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      joinedDate: Value(joinedDate),
      isOnline: Value(isOnline),
      distance: distance == null && nullToAbsent
          ? const Value.absent()
          : Value(distance),
      verificationBadge: verificationBadge == null && nullToAbsent
          ? const Value.absent()
          : Value(verificationBadge),
      responseRate: responseRate == null && nullToAbsent
          ? const Value.absent()
          : Value(responseRate),
      followersCount: followersCount == null && nullToAbsent
          ? const Value.absent()
          : Value(followersCount),
      lastSyncedAt: Value(lastSyncedAt),
      isDirty: Value(isDirty),
    );
  }

  factory FarmerData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmerData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      profileImage: serializer.fromJson<String?>(json['profileImage']),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      address: serializer.fromJson<String>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      rating: serializer.fromJson<double>(json['rating']),
      totalReviews: serializer.fromJson<int>(json['totalReviews']),
      totalProducts: serializer.fromJson<int>(json['totalProducts']),
      specialties: serializer.fromJson<String>(json['specialties']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      hasMapFeature: serializer.fromJson<bool>(json['hasMapFeature']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      email: serializer.fromJson<String?>(json['email']),
      joinedDate: serializer.fromJson<DateTime>(json['joinedDate']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      distance: serializer.fromJson<double?>(json['distance']),
      verificationBadge:
          serializer.fromJson<String?>(json['verificationBadge']),
      responseRate: serializer.fromJson<double?>(json['responseRate']),
      followersCount: serializer.fromJson<int?>(json['followersCount']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'profileImage': serializer.toJson<String?>(profileImage),
      'coverImage': serializer.toJson<String?>(coverImage),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'address': serializer.toJson<String>(address),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'rating': serializer.toJson<double>(rating),
      'totalReviews': serializer.toJson<int>(totalReviews),
      'totalProducts': serializer.toJson<int>(totalProducts),
      'specialties': serializer.toJson<String>(specialties),
      'isVerified': serializer.toJson<bool>(isVerified),
      'hasMapFeature': serializer.toJson<bool>(hasMapFeature),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'email': serializer.toJson<String?>(email),
      'joinedDate': serializer.toJson<DateTime>(joinedDate),
      'isOnline': serializer.toJson<bool>(isOnline),
      'distance': serializer.toJson<double?>(distance),
      'verificationBadge': serializer.toJson<String?>(verificationBadge),
      'responseRate': serializer.toJson<double?>(responseRate),
      'followersCount': serializer.toJson<int?>(followersCount),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
      'isDirty': serializer.toJson<bool>(isDirty),
    };
  }

  FarmerData copyWith(
          {String? id,
          String? userId,
          String? name,
          String? description,
          Value<String?> profileImage = const Value.absent(),
          Value<String?> coverImage = const Value.absent(),
          double? latitude,
          double? longitude,
          String? address,
          Value<String?> city = const Value.absent(),
          Value<String?> state = const Value.absent(),
          double? rating,
          int? totalReviews,
          int? totalProducts,
          String? specialties,
          bool? isVerified,
          bool? hasMapFeature,
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> email = const Value.absent(),
          DateTime? joinedDate,
          bool? isOnline,
          Value<double?> distance = const Value.absent(),
          Value<String?> verificationBadge = const Value.absent(),
          Value<double?> responseRate = const Value.absent(),
          Value<int?> followersCount = const Value.absent(),
          DateTime? lastSyncedAt,
          bool? isDirty}) =>
      FarmerData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        description: description ?? this.description,
        profileImage:
            profileImage.present ? profileImage.value : this.profileImage,
        coverImage: coverImage.present ? coverImage.value : this.coverImage,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        address: address ?? this.address,
        city: city.present ? city.value : this.city,
        state: state.present ? state.value : this.state,
        rating: rating ?? this.rating,
        totalReviews: totalReviews ?? this.totalReviews,
        totalProducts: totalProducts ?? this.totalProducts,
        specialties: specialties ?? this.specialties,
        isVerified: isVerified ?? this.isVerified,
        hasMapFeature: hasMapFeature ?? this.hasMapFeature,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        email: email.present ? email.value : this.email,
        joinedDate: joinedDate ?? this.joinedDate,
        isOnline: isOnline ?? this.isOnline,
        distance: distance.present ? distance.value : this.distance,
        verificationBadge: verificationBadge.present
            ? verificationBadge.value
            : this.verificationBadge,
        responseRate:
            responseRate.present ? responseRate.value : this.responseRate,
        followersCount:
            followersCount.present ? followersCount.value : this.followersCount,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
        isDirty: isDirty ?? this.isDirty,
      );
  FarmerData copyWithCompanion(FarmersCompanion data) {
    return FarmerData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      profileImage: data.profileImage.present
          ? data.profileImage.value
          : this.profileImage,
      coverImage:
          data.coverImage.present ? data.coverImage.value : this.coverImage,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      rating: data.rating.present ? data.rating.value : this.rating,
      totalReviews: data.totalReviews.present
          ? data.totalReviews.value
          : this.totalReviews,
      totalProducts: data.totalProducts.present
          ? data.totalProducts.value
          : this.totalProducts,
      specialties:
          data.specialties.present ? data.specialties.value : this.specialties,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      hasMapFeature: data.hasMapFeature.present
          ? data.hasMapFeature.value
          : this.hasMapFeature,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      email: data.email.present ? data.email.value : this.email,
      joinedDate:
          data.joinedDate.present ? data.joinedDate.value : this.joinedDate,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      distance: data.distance.present ? data.distance.value : this.distance,
      verificationBadge: data.verificationBadge.present
          ? data.verificationBadge.value
          : this.verificationBadge,
      responseRate: data.responseRate.present
          ? data.responseRate.value
          : this.responseRate,
      followersCount: data.followersCount.present
          ? data.followersCount.value
          : this.followersCount,
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
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('profileImage: $profileImage, ')
          ..write('coverImage: $coverImage, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('rating: $rating, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('totalProducts: $totalProducts, ')
          ..write('specialties: $specialties, ')
          ..write('isVerified: $isVerified, ')
          ..write('hasMapFeature: $hasMapFeature, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('joinedDate: $joinedDate, ')
          ..write('isOnline: $isOnline, ')
          ..write('distance: $distance, ')
          ..write('verificationBadge: $verificationBadge, ')
          ..write('responseRate: $responseRate, ')
          ..write('followersCount: $followersCount, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('isDirty: $isDirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        name,
        description,
        profileImage,
        coverImage,
        latitude,
        longitude,
        address,
        city,
        state,
        rating,
        totalReviews,
        totalProducts,
        specialties,
        isVerified,
        hasMapFeature,
        phoneNumber,
        email,
        joinedDate,
        isOnline,
        distance,
        verificationBadge,
        responseRate,
        followersCount,
        lastSyncedAt,
        isDirty
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmerData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.description == this.description &&
          other.profileImage == this.profileImage &&
          other.coverImage == this.coverImage &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.address == this.address &&
          other.city == this.city &&
          other.state == this.state &&
          other.rating == this.rating &&
          other.totalReviews == this.totalReviews &&
          other.totalProducts == this.totalProducts &&
          other.specialties == this.specialties &&
          other.isVerified == this.isVerified &&
          other.hasMapFeature == this.hasMapFeature &&
          other.phoneNumber == this.phoneNumber &&
          other.email == this.email &&
          other.joinedDate == this.joinedDate &&
          other.isOnline == this.isOnline &&
          other.distance == this.distance &&
          other.verificationBadge == this.verificationBadge &&
          other.responseRate == this.responseRate &&
          other.followersCount == this.followersCount &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.isDirty == this.isDirty);
}

class FarmersCompanion extends UpdateCompanion<FarmerData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> profileImage;
  final Value<String?> coverImage;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> address;
  final Value<String?> city;
  final Value<String?> state;
  final Value<double> rating;
  final Value<int> totalReviews;
  final Value<int> totalProducts;
  final Value<String> specialties;
  final Value<bool> isVerified;
  final Value<bool> hasMapFeature;
  final Value<String?> phoneNumber;
  final Value<String?> email;
  final Value<DateTime> joinedDate;
  final Value<bool> isOnline;
  final Value<double?> distance;
  final Value<String?> verificationBadge;
  final Value<double?> responseRate;
  final Value<int?> followersCount;
  final Value<DateTime> lastSyncedAt;
  final Value<bool> isDirty;
  final Value<int> rowid;
  const FarmersCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.profileImage = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.rating = const Value.absent(),
    this.totalReviews = const Value.absent(),
    this.totalProducts = const Value.absent(),
    this.specialties = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.hasMapFeature = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    this.joinedDate = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.distance = const Value.absent(),
    this.verificationBadge = const Value.absent(),
    this.responseRate = const Value.absent(),
    this.followersCount = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmersCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String description,
    this.profileImage = const Value.absent(),
    this.coverImage = const Value.absent(),
    required double latitude,
    required double longitude,
    required String address,
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    required double rating,
    required int totalReviews,
    required int totalProducts,
    required String specialties,
    required bool isVerified,
    required bool hasMapFeature,
    this.phoneNumber = const Value.absent(),
    this.email = const Value.absent(),
    required DateTime joinedDate,
    required bool isOnline,
    this.distance = const Value.absent(),
    this.verificationBadge = const Value.absent(),
    this.responseRate = const Value.absent(),
    this.followersCount = const Value.absent(),
    required DateTime lastSyncedAt,
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        description = Value(description),
        latitude = Value(latitude),
        longitude = Value(longitude),
        address = Value(address),
        rating = Value(rating),
        totalReviews = Value(totalReviews),
        totalProducts = Value(totalProducts),
        specialties = Value(specialties),
        isVerified = Value(isVerified),
        hasMapFeature = Value(hasMapFeature),
        joinedDate = Value(joinedDate),
        isOnline = Value(isOnline),
        lastSyncedAt = Value(lastSyncedAt);
  static Insertable<FarmerData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? profileImage,
    Expression<String>? coverImage,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? state,
    Expression<double>? rating,
    Expression<int>? totalReviews,
    Expression<int>? totalProducts,
    Expression<String>? specialties,
    Expression<bool>? isVerified,
    Expression<bool>? hasMapFeature,
    Expression<String>? phoneNumber,
    Expression<String>? email,
    Expression<DateTime>? joinedDate,
    Expression<bool>? isOnline,
    Expression<double>? distance,
    Expression<String>? verificationBadge,
    Expression<double>? responseRate,
    Expression<int>? followersCount,
    Expression<DateTime>? lastSyncedAt,
    Expression<bool>? isDirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (profileImage != null) 'profile_image': profileImage,
      if (coverImage != null) 'cover_image': coverImage,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (rating != null) 'rating': rating,
      if (totalReviews != null) 'total_reviews': totalReviews,
      if (totalProducts != null) 'total_products': totalProducts,
      if (specialties != null) 'specialties': specialties,
      if (isVerified != null) 'is_verified': isVerified,
      if (hasMapFeature != null) 'has_map_feature': hasMapFeature,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (joinedDate != null) 'joined_date': joinedDate,
      if (isOnline != null) 'is_online': isOnline,
      if (distance != null) 'distance': distance,
      if (verificationBadge != null) 'verification_badge': verificationBadge,
      if (responseRate != null) 'response_rate': responseRate,
      if (followersCount != null) 'followers_count': followersCount,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (isDirty != null) 'is_dirty': isDirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmersCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String>? description,
      Value<String?>? profileImage,
      Value<String?>? coverImage,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String>? address,
      Value<String?>? city,
      Value<String?>? state,
      Value<double>? rating,
      Value<int>? totalReviews,
      Value<int>? totalProducts,
      Value<String>? specialties,
      Value<bool>? isVerified,
      Value<bool>? hasMapFeature,
      Value<String?>? phoneNumber,
      Value<String?>? email,
      Value<DateTime>? joinedDate,
      Value<bool>? isOnline,
      Value<double?>? distance,
      Value<String?>? verificationBadge,
      Value<double?>? responseRate,
      Value<int?>? followersCount,
      Value<DateTime>? lastSyncedAt,
      Value<bool>? isDirty,
      Value<int>? rowid}) {
    return FarmersCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalProducts: totalProducts ?? this.totalProducts,
      specialties: specialties ?? this.specialties,
      isVerified: isVerified ?? this.isVerified,
      hasMapFeature: hasMapFeature ?? this.hasMapFeature,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      joinedDate: joinedDate ?? this.joinedDate,
      isOnline: isOnline ?? this.isOnline,
      distance: distance ?? this.distance,
      verificationBadge: verificationBadge ?? this.verificationBadge,
      responseRate: responseRate ?? this.responseRate,
      followersCount: followersCount ?? this.followersCount,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (profileImage.present) {
      map['profile_image'] = Variable<String>(profileImage.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
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
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (totalReviews.present) {
      map['total_reviews'] = Variable<int>(totalReviews.value);
    }
    if (totalProducts.present) {
      map['total_products'] = Variable<int>(totalProducts.value);
    }
    if (specialties.present) {
      map['specialties'] = Variable<String>(specialties.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (hasMapFeature.present) {
      map['has_map_feature'] = Variable<bool>(hasMapFeature.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (joinedDate.present) {
      map['joined_date'] = Variable<DateTime>(joinedDate.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (verificationBadge.present) {
      map['verification_badge'] = Variable<String>(verificationBadge.value);
    }
    if (responseRate.present) {
      map['response_rate'] = Variable<double>(responseRate.value);
    }
    if (followersCount.present) {
      map['followers_count'] = Variable<int>(followersCount.value);
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
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('profileImage: $profileImage, ')
          ..write('coverImage: $coverImage, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('rating: $rating, ')
          ..write('totalReviews: $totalReviews, ')
          ..write('totalProducts: $totalProducts, ')
          ..write('specialties: $specialties, ')
          ..write('isVerified: $isVerified, ')
          ..write('hasMapFeature: $hasMapFeature, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('email: $email, ')
          ..write('joinedDate: $joinedDate, ')
          ..write('isOnline: $isOnline, ')
          ..write('distance: $distance, ')
          ..write('verificationBadge: $verificationBadge, ')
          ..write('responseRate: $responseRate, ')
          ..write('followersCount: $followersCount, ')
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
  required String userId,
  required String name,
  required String description,
  Value<String?> profileImage,
  Value<String?> coverImage,
  required double latitude,
  required double longitude,
  required String address,
  Value<String?> city,
  Value<String?> state,
  required double rating,
  required int totalReviews,
  required int totalProducts,
  required String specialties,
  required bool isVerified,
  required bool hasMapFeature,
  Value<String?> phoneNumber,
  Value<String?> email,
  required DateTime joinedDate,
  required bool isOnline,
  Value<double?> distance,
  Value<String?> verificationBadge,
  Value<double?> responseRate,
  Value<int?> followersCount,
  required DateTime lastSyncedAt,
  Value<bool> isDirty,
  Value<int> rowid,
});
typedef $$FarmersTableUpdateCompanionBuilder = FarmersCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String> description,
  Value<String?> profileImage,
  Value<String?> coverImage,
  Value<double> latitude,
  Value<double> longitude,
  Value<String> address,
  Value<String?> city,
  Value<String?> state,
  Value<double> rating,
  Value<int> totalReviews,
  Value<int> totalProducts,
  Value<String> specialties,
  Value<bool> isVerified,
  Value<bool> hasMapFeature,
  Value<String?> phoneNumber,
  Value<String?> email,
  Value<DateTime> joinedDate,
  Value<bool> isOnline,
  Value<double?> distance,
  Value<String?> verificationBadge,
  Value<double?> responseRate,
  Value<int?> followersCount,
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

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalReviews => $composableBuilder(
      column: $table.totalReviews, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalProducts => $composableBuilder(
      column: $table.totalProducts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialties => $composableBuilder(
      column: $table.specialties, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasMapFeature => $composableBuilder(
      column: $table.hasMapFeature, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinedDate => $composableBuilder(
      column: $table.joinedDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verificationBadge => $composableBuilder(
      column: $table.verificationBadge,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get responseRate => $composableBuilder(
      column: $table.responseRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get followersCount => $composableBuilder(
      column: $table.followersCount,
      builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileImage => $composableBuilder(
      column: $table.profileImage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalReviews => $composableBuilder(
      column: $table.totalReviews,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalProducts => $composableBuilder(
      column: $table.totalProducts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialties => $composableBuilder(
      column: $table.specialties, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasMapFeature => $composableBuilder(
      column: $table.hasMapFeature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinedDate => $composableBuilder(
      column: $table.joinedDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verificationBadge => $composableBuilder(
      column: $table.verificationBadge,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get responseRate => $composableBuilder(
      column: $table.responseRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get followersCount => $composableBuilder(
      column: $table.followersCount,
      builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get profileImage => $composableBuilder(
      column: $table.profileImage, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get totalReviews => $composableBuilder(
      column: $table.totalReviews, builder: (column) => column);

  GeneratedColumn<int> get totalProducts => $composableBuilder(
      column: $table.totalProducts, builder: (column) => column);

  GeneratedColumn<String> get specialties => $composableBuilder(
      column: $table.specialties, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => column);

  GeneratedColumn<bool> get hasMapFeature => $composableBuilder(
      column: $table.hasMapFeature, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedDate => $composableBuilder(
      column: $table.joinedDate, builder: (column) => column);

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<String> get verificationBadge => $composableBuilder(
      column: $table.verificationBadge, builder: (column) => column);

  GeneratedColumn<double> get responseRate => $composableBuilder(
      column: $table.responseRate, builder: (column) => column);

  GeneratedColumn<int> get followersCount => $composableBuilder(
      column: $table.followersCount, builder: (column) => column);

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
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String?> profileImage = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> state = const Value.absent(),
            Value<double> rating = const Value.absent(),
            Value<int> totalReviews = const Value.absent(),
            Value<int> totalProducts = const Value.absent(),
            Value<String> specialties = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<bool> hasMapFeature = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<DateTime> joinedDate = const Value.absent(),
            Value<bool> isOnline = const Value.absent(),
            Value<double?> distance = const Value.absent(),
            Value<String?> verificationBadge = const Value.absent(),
            Value<double?> responseRate = const Value.absent(),
            Value<int?> followersCount = const Value.absent(),
            Value<DateTime> lastSyncedAt = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmersCompanion(
            id: id,
            userId: userId,
            name: name,
            description: description,
            profileImage: profileImage,
            coverImage: coverImage,
            latitude: latitude,
            longitude: longitude,
            address: address,
            city: city,
            state: state,
            rating: rating,
            totalReviews: totalReviews,
            totalProducts: totalProducts,
            specialties: specialties,
            isVerified: isVerified,
            hasMapFeature: hasMapFeature,
            phoneNumber: phoneNumber,
            email: email,
            joinedDate: joinedDate,
            isOnline: isOnline,
            distance: distance,
            verificationBadge: verificationBadge,
            responseRate: responseRate,
            followersCount: followersCount,
            lastSyncedAt: lastSyncedAt,
            isDirty: isDirty,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String name,
            required String description,
            Value<String?> profileImage = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            required double latitude,
            required double longitude,
            required String address,
            Value<String?> city = const Value.absent(),
            Value<String?> state = const Value.absent(),
            required double rating,
            required int totalReviews,
            required int totalProducts,
            required String specialties,
            required bool isVerified,
            required bool hasMapFeature,
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> email = const Value.absent(),
            required DateTime joinedDate,
            required bool isOnline,
            Value<double?> distance = const Value.absent(),
            Value<String?> verificationBadge = const Value.absent(),
            Value<double?> responseRate = const Value.absent(),
            Value<int?> followersCount = const Value.absent(),
            required DateTime lastSyncedAt,
            Value<bool> isDirty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmersCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            description: description,
            profileImage: profileImage,
            coverImage: coverImage,
            latitude: latitude,
            longitude: longitude,
            address: address,
            city: city,
            state: state,
            rating: rating,
            totalReviews: totalReviews,
            totalProducts: totalProducts,
            specialties: specialties,
            isVerified: isVerified,
            hasMapFeature: hasMapFeature,
            phoneNumber: phoneNumber,
            email: email,
            joinedDate: joinedDate,
            isOnline: isOnline,
            distance: distance,
            verificationBadge: verificationBadge,
            responseRate: responseRate,
            followersCount: followersCount,
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
