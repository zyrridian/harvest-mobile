// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExploreModel _$ExploreModelFromJson(Map<String, dynamic> json) {
  return _ExploreModel.fromJson(json);
}

/// @nodoc
mixin _$ExploreModel {
  @JsonKey(name: 'live_streams')
  List<ExploreLiveStreamModel> get liveStreams =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'in_season')
  List<ExploreInSeasonModel> get inSeason => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_buys')
  List<ExploreGroupBuyModel> get groupBuys =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'nearby_farmers')
  List<ExploreNearbyFarmerModel> get nearbyFarmers =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'active_preorders')
  List<ExplorePreOrderModel> get activePreorders =>
      throw _privateConstructorUsedError;
  List<ExploreExperienceModel> get experiences =>
      throw _privateConstructorUsedError;

  /// Serializes this ExploreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreModelCopyWith<ExploreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreModelCopyWith<$Res> {
  factory $ExploreModelCopyWith(
          ExploreModel value, $Res Function(ExploreModel) then) =
      _$ExploreModelCopyWithImpl<$Res, ExploreModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'live_streams') List<ExploreLiveStreamModel> liveStreams,
      @JsonKey(name: 'in_season') List<ExploreInSeasonModel> inSeason,
      @JsonKey(name: 'group_buys') List<ExploreGroupBuyModel> groupBuys,
      @JsonKey(name: 'nearby_farmers')
      List<ExploreNearbyFarmerModel> nearbyFarmers,
      @JsonKey(name: 'active_preorders')
      List<ExplorePreOrderModel> activePreorders,
      List<ExploreExperienceModel> experiences});
}

/// @nodoc
class _$ExploreModelCopyWithImpl<$Res, $Val extends ExploreModel>
    implements $ExploreModelCopyWith<$Res> {
  _$ExploreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liveStreams = null,
    Object? inSeason = null,
    Object? groupBuys = null,
    Object? nearbyFarmers = null,
    Object? activePreorders = null,
    Object? experiences = null,
  }) {
    return _then(_value.copyWith(
      liveStreams: null == liveStreams
          ? _value.liveStreams
          : liveStreams // ignore: cast_nullable_to_non_nullable
              as List<ExploreLiveStreamModel>,
      inSeason: null == inSeason
          ? _value.inSeason
          : inSeason // ignore: cast_nullable_to_non_nullable
              as List<ExploreInSeasonModel>,
      groupBuys: null == groupBuys
          ? _value.groupBuys
          : groupBuys // ignore: cast_nullable_to_non_nullable
              as List<ExploreGroupBuyModel>,
      nearbyFarmers: null == nearbyFarmers
          ? _value.nearbyFarmers
          : nearbyFarmers // ignore: cast_nullable_to_non_nullable
              as List<ExploreNearbyFarmerModel>,
      activePreorders: null == activePreorders
          ? _value.activePreorders
          : activePreorders // ignore: cast_nullable_to_non_nullable
              as List<ExplorePreOrderModel>,
      experiences: null == experiences
          ? _value.experiences
          : experiences // ignore: cast_nullable_to_non_nullable
              as List<ExploreExperienceModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreModelImplCopyWith<$Res>
    implements $ExploreModelCopyWith<$Res> {
  factory _$$ExploreModelImplCopyWith(
          _$ExploreModelImpl value, $Res Function(_$ExploreModelImpl) then) =
      __$$ExploreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'live_streams') List<ExploreLiveStreamModel> liveStreams,
      @JsonKey(name: 'in_season') List<ExploreInSeasonModel> inSeason,
      @JsonKey(name: 'group_buys') List<ExploreGroupBuyModel> groupBuys,
      @JsonKey(name: 'nearby_farmers')
      List<ExploreNearbyFarmerModel> nearbyFarmers,
      @JsonKey(name: 'active_preorders')
      List<ExplorePreOrderModel> activePreorders,
      List<ExploreExperienceModel> experiences});
}

/// @nodoc
class __$$ExploreModelImplCopyWithImpl<$Res>
    extends _$ExploreModelCopyWithImpl<$Res, _$ExploreModelImpl>
    implements _$$ExploreModelImplCopyWith<$Res> {
  __$$ExploreModelImplCopyWithImpl(
      _$ExploreModelImpl _value, $Res Function(_$ExploreModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liveStreams = null,
    Object? inSeason = null,
    Object? groupBuys = null,
    Object? nearbyFarmers = null,
    Object? activePreorders = null,
    Object? experiences = null,
  }) {
    return _then(_$ExploreModelImpl(
      liveStreams: null == liveStreams
          ? _value._liveStreams
          : liveStreams // ignore: cast_nullable_to_non_nullable
              as List<ExploreLiveStreamModel>,
      inSeason: null == inSeason
          ? _value._inSeason
          : inSeason // ignore: cast_nullable_to_non_nullable
              as List<ExploreInSeasonModel>,
      groupBuys: null == groupBuys
          ? _value._groupBuys
          : groupBuys // ignore: cast_nullable_to_non_nullable
              as List<ExploreGroupBuyModel>,
      nearbyFarmers: null == nearbyFarmers
          ? _value._nearbyFarmers
          : nearbyFarmers // ignore: cast_nullable_to_non_nullable
              as List<ExploreNearbyFarmerModel>,
      activePreorders: null == activePreorders
          ? _value._activePreorders
          : activePreorders // ignore: cast_nullable_to_non_nullable
              as List<ExplorePreOrderModel>,
      experiences: null == experiences
          ? _value._experiences
          : experiences // ignore: cast_nullable_to_non_nullable
              as List<ExploreExperienceModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreModelImpl extends _ExploreModel {
  const _$ExploreModelImpl(
      {@JsonKey(name: 'live_streams')
      final List<ExploreLiveStreamModel> liveStreams = const [],
      @JsonKey(name: 'in_season')
      final List<ExploreInSeasonModel> inSeason = const [],
      @JsonKey(name: 'group_buys')
      final List<ExploreGroupBuyModel> groupBuys = const [],
      @JsonKey(name: 'nearby_farmers')
      final List<ExploreNearbyFarmerModel> nearbyFarmers = const [],
      @JsonKey(name: 'active_preorders')
      final List<ExplorePreOrderModel> activePreorders = const [],
      final List<ExploreExperienceModel> experiences = const []})
      : _liveStreams = liveStreams,
        _inSeason = inSeason,
        _groupBuys = groupBuys,
        _nearbyFarmers = nearbyFarmers,
        _activePreorders = activePreorders,
        _experiences = experiences,
        super._();

  factory _$ExploreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreModelImplFromJson(json);

  final List<ExploreLiveStreamModel> _liveStreams;
  @override
  @JsonKey(name: 'live_streams')
  List<ExploreLiveStreamModel> get liveStreams {
    if (_liveStreams is EqualUnmodifiableListView) return _liveStreams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_liveStreams);
  }

  final List<ExploreInSeasonModel> _inSeason;
  @override
  @JsonKey(name: 'in_season')
  List<ExploreInSeasonModel> get inSeason {
    if (_inSeason is EqualUnmodifiableListView) return _inSeason;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inSeason);
  }

  final List<ExploreGroupBuyModel> _groupBuys;
  @override
  @JsonKey(name: 'group_buys')
  List<ExploreGroupBuyModel> get groupBuys {
    if (_groupBuys is EqualUnmodifiableListView) return _groupBuys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupBuys);
  }

  final List<ExploreNearbyFarmerModel> _nearbyFarmers;
  @override
  @JsonKey(name: 'nearby_farmers')
  List<ExploreNearbyFarmerModel> get nearbyFarmers {
    if (_nearbyFarmers is EqualUnmodifiableListView) return _nearbyFarmers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nearbyFarmers);
  }

  final List<ExplorePreOrderModel> _activePreorders;
  @override
  @JsonKey(name: 'active_preorders')
  List<ExplorePreOrderModel> get activePreorders {
    if (_activePreorders is EqualUnmodifiableListView) return _activePreorders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activePreorders);
  }

  final List<ExploreExperienceModel> _experiences;
  @override
  @JsonKey()
  List<ExploreExperienceModel> get experiences {
    if (_experiences is EqualUnmodifiableListView) return _experiences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_experiences);
  }

  @override
  String toString() {
    return 'ExploreModel(liveStreams: $liveStreams, inSeason: $inSeason, groupBuys: $groupBuys, nearbyFarmers: $nearbyFarmers, activePreorders: $activePreorders, experiences: $experiences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreModelImpl &&
            const DeepCollectionEquality()
                .equals(other._liveStreams, _liveStreams) &&
            const DeepCollectionEquality().equals(other._inSeason, _inSeason) &&
            const DeepCollectionEquality()
                .equals(other._groupBuys, _groupBuys) &&
            const DeepCollectionEquality()
                .equals(other._nearbyFarmers, _nearbyFarmers) &&
            const DeepCollectionEquality()
                .equals(other._activePreorders, _activePreorders) &&
            const DeepCollectionEquality()
                .equals(other._experiences, _experiences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_liveStreams),
      const DeepCollectionEquality().hash(_inSeason),
      const DeepCollectionEquality().hash(_groupBuys),
      const DeepCollectionEquality().hash(_nearbyFarmers),
      const DeepCollectionEquality().hash(_activePreorders),
      const DeepCollectionEquality().hash(_experiences));

  /// Create a copy of ExploreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreModelImplCopyWith<_$ExploreModelImpl> get copyWith =>
      __$$ExploreModelImplCopyWithImpl<_$ExploreModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreModelImplToJson(
      this,
    );
  }
}

abstract class _ExploreModel extends ExploreModel {
  const factory _ExploreModel(
      {@JsonKey(name: 'live_streams')
      final List<ExploreLiveStreamModel> liveStreams,
      @JsonKey(name: 'in_season') final List<ExploreInSeasonModel> inSeason,
      @JsonKey(name: 'group_buys') final List<ExploreGroupBuyModel> groupBuys,
      @JsonKey(name: 'nearby_farmers')
      final List<ExploreNearbyFarmerModel> nearbyFarmers,
      @JsonKey(name: 'active_preorders')
      final List<ExplorePreOrderModel> activePreorders,
      final List<ExploreExperienceModel> experiences}) = _$ExploreModelImpl;
  const _ExploreModel._() : super._();

  factory _ExploreModel.fromJson(Map<String, dynamic> json) =
      _$ExploreModelImpl.fromJson;

  @override
  @JsonKey(name: 'live_streams')
  List<ExploreLiveStreamModel> get liveStreams;
  @override
  @JsonKey(name: 'in_season')
  List<ExploreInSeasonModel> get inSeason;
  @override
  @JsonKey(name: 'group_buys')
  List<ExploreGroupBuyModel> get groupBuys;
  @override
  @JsonKey(name: 'nearby_farmers')
  List<ExploreNearbyFarmerModel> get nearbyFarmers;
  @override
  @JsonKey(name: 'active_preorders')
  List<ExplorePreOrderModel> get activePreorders;
  @override
  List<ExploreExperienceModel> get experiences;

  /// Create a copy of ExploreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreModelImplCopyWith<_$ExploreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExploreLiveStreamModel _$ExploreLiveStreamModelFromJson(
    Map<String, dynamic> json) {
  return _ExploreLiveStreamModel.fromJson(json);
}

/// @nodoc
mixin _$ExploreLiveStreamModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'farmer_name')
  String get farmerName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get thumbnail => throw _privateConstructorUsedError;
  int get viewers => throw _privateConstructorUsedError;
  @JsonKey(name: 'stream_url')
  String get streamUrl => throw _privateConstructorUsedError;

  /// Serializes this ExploreLiveStreamModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreLiveStreamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreLiveStreamModelCopyWith<ExploreLiveStreamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreLiveStreamModelCopyWith<$Res> {
  factory $ExploreLiveStreamModelCopyWith(ExploreLiveStreamModel value,
          $Res Function(ExploreLiveStreamModel) then) =
      _$ExploreLiveStreamModelCopyWithImpl<$Res, ExploreLiveStreamModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'farmer_name') String farmerName,
      String title,
      String thumbnail,
      int viewers,
      @JsonKey(name: 'stream_url') String streamUrl});
}

/// @nodoc
class _$ExploreLiveStreamModelCopyWithImpl<$Res,
        $Val extends ExploreLiveStreamModel>
    implements $ExploreLiveStreamModelCopyWith<$Res> {
  _$ExploreLiveStreamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreLiveStreamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmerName = null,
    Object? title = null,
    Object? thumbnail = null,
    Object? viewers = null,
    Object? streamUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      farmerName: null == farmerName
          ? _value.farmerName
          : farmerName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      viewers: null == viewers
          ? _value.viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as int,
      streamUrl: null == streamUrl
          ? _value.streamUrl
          : streamUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreLiveStreamModelImplCopyWith<$Res>
    implements $ExploreLiveStreamModelCopyWith<$Res> {
  factory _$$ExploreLiveStreamModelImplCopyWith(
          _$ExploreLiveStreamModelImpl value,
          $Res Function(_$ExploreLiveStreamModelImpl) then) =
      __$$ExploreLiveStreamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'farmer_name') String farmerName,
      String title,
      String thumbnail,
      int viewers,
      @JsonKey(name: 'stream_url') String streamUrl});
}

/// @nodoc
class __$$ExploreLiveStreamModelImplCopyWithImpl<$Res>
    extends _$ExploreLiveStreamModelCopyWithImpl<$Res,
        _$ExploreLiveStreamModelImpl>
    implements _$$ExploreLiveStreamModelImplCopyWith<$Res> {
  __$$ExploreLiveStreamModelImplCopyWithImpl(
      _$ExploreLiveStreamModelImpl _value,
      $Res Function(_$ExploreLiveStreamModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreLiveStreamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? farmerName = null,
    Object? title = null,
    Object? thumbnail = null,
    Object? viewers = null,
    Object? streamUrl = null,
  }) {
    return _then(_$ExploreLiveStreamModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      farmerName: null == farmerName
          ? _value.farmerName
          : farmerName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnail: null == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String,
      viewers: null == viewers
          ? _value.viewers
          : viewers // ignore: cast_nullable_to_non_nullable
              as int,
      streamUrl: null == streamUrl
          ? _value.streamUrl
          : streamUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreLiveStreamModelImpl extends _ExploreLiveStreamModel {
  const _$ExploreLiveStreamModelImpl(
      {required this.id,
      @JsonKey(name: 'farmer_name') required this.farmerName,
      required this.title,
      required this.thumbnail,
      required this.viewers,
      @JsonKey(name: 'stream_url') required this.streamUrl})
      : super._();

  factory _$ExploreLiveStreamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreLiveStreamModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  @override
  final String title;
  @override
  final String thumbnail;
  @override
  final int viewers;
  @override
  @JsonKey(name: 'stream_url')
  final String streamUrl;

  @override
  String toString() {
    return 'ExploreLiveStreamModel(id: $id, farmerName: $farmerName, title: $title, thumbnail: $thumbnail, viewers: $viewers, streamUrl: $streamUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreLiveStreamModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.farmerName, farmerName) ||
                other.farmerName == farmerName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.viewers, viewers) || other.viewers == viewers) &&
            (identical(other.streamUrl, streamUrl) ||
                other.streamUrl == streamUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, farmerName, title, thumbnail, viewers, streamUrl);

  /// Create a copy of ExploreLiveStreamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreLiveStreamModelImplCopyWith<_$ExploreLiveStreamModelImpl>
      get copyWith => __$$ExploreLiveStreamModelImplCopyWithImpl<
          _$ExploreLiveStreamModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreLiveStreamModelImplToJson(
      this,
    );
  }
}

abstract class _ExploreLiveStreamModel extends ExploreLiveStreamModel {
  const factory _ExploreLiveStreamModel(
          {required final String id,
          @JsonKey(name: 'farmer_name') required final String farmerName,
          required final String title,
          required final String thumbnail,
          required final int viewers,
          @JsonKey(name: 'stream_url') required final String streamUrl}) =
      _$ExploreLiveStreamModelImpl;
  const _ExploreLiveStreamModel._() : super._();

  factory _ExploreLiveStreamModel.fromJson(Map<String, dynamic> json) =
      _$ExploreLiveStreamModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'farmer_name')
  String get farmerName;
  @override
  String get title;
  @override
  String get thumbnail;
  @override
  int get viewers;
  @override
  @JsonKey(name: 'stream_url')
  String get streamUrl;

  /// Create a copy of ExploreLiveStreamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreLiveStreamModelImplCopyWith<_$ExploreLiveStreamModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExploreInSeasonModel _$ExploreInSeasonModelFromJson(Map<String, dynamic> json) {
  return _ExploreInSeasonModel.fromJson(json);
}

/// @nodoc
mixin _$ExploreInSeasonModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'farms_count')
  int get farmsCount => throw _privateConstructorUsedError;

  /// Serializes this ExploreInSeasonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreInSeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreInSeasonModelCopyWith<ExploreInSeasonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreInSeasonModelCopyWith<$Res> {
  factory $ExploreInSeasonModelCopyWith(ExploreInSeasonModel value,
          $Res Function(ExploreInSeasonModel) then) =
      _$ExploreInSeasonModelCopyWithImpl<$Res, ExploreInSeasonModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String image,
      @JsonKey(name: 'farms_count') int farmsCount});
}

/// @nodoc
class _$ExploreInSeasonModelCopyWithImpl<$Res,
        $Val extends ExploreInSeasonModel>
    implements $ExploreInSeasonModelCopyWith<$Res> {
  _$ExploreInSeasonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreInSeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? image = null,
    Object? farmsCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      farmsCount: null == farmsCount
          ? _value.farmsCount
          : farmsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreInSeasonModelImplCopyWith<$Res>
    implements $ExploreInSeasonModelCopyWith<$Res> {
  factory _$$ExploreInSeasonModelImplCopyWith(_$ExploreInSeasonModelImpl value,
          $Res Function(_$ExploreInSeasonModelImpl) then) =
      __$$ExploreInSeasonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String image,
      @JsonKey(name: 'farms_count') int farmsCount});
}

/// @nodoc
class __$$ExploreInSeasonModelImplCopyWithImpl<$Res>
    extends _$ExploreInSeasonModelCopyWithImpl<$Res, _$ExploreInSeasonModelImpl>
    implements _$$ExploreInSeasonModelImplCopyWith<$Res> {
  __$$ExploreInSeasonModelImplCopyWithImpl(_$ExploreInSeasonModelImpl _value,
      $Res Function(_$ExploreInSeasonModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreInSeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? image = null,
    Object? farmsCount = null,
  }) {
    return _then(_$ExploreInSeasonModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      farmsCount: null == farmsCount
          ? _value.farmsCount
          : farmsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreInSeasonModelImpl extends _ExploreInSeasonModel {
  const _$ExploreInSeasonModelImpl(
      {required this.id,
      required this.title,
      required this.image,
      @JsonKey(name: 'farms_count') required this.farmsCount})
      : super._();

  factory _$ExploreInSeasonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreInSeasonModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String image;
  @override
  @JsonKey(name: 'farms_count')
  final int farmsCount;

  @override
  String toString() {
    return 'ExploreInSeasonModel(id: $id, title: $title, image: $image, farmsCount: $farmsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreInSeasonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.farmsCount, farmsCount) ||
                other.farmsCount == farmsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, image, farmsCount);

  /// Create a copy of ExploreInSeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreInSeasonModelImplCopyWith<_$ExploreInSeasonModelImpl>
      get copyWith =>
          __$$ExploreInSeasonModelImplCopyWithImpl<_$ExploreInSeasonModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreInSeasonModelImplToJson(
      this,
    );
  }
}

abstract class _ExploreInSeasonModel extends ExploreInSeasonModel {
  const factory _ExploreInSeasonModel(
          {required final String id,
          required final String title,
          required final String image,
          @JsonKey(name: 'farms_count') required final int farmsCount}) =
      _$ExploreInSeasonModelImpl;
  const _ExploreInSeasonModel._() : super._();

  factory _ExploreInSeasonModel.fromJson(Map<String, dynamic> json) =
      _$ExploreInSeasonModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get image;
  @override
  @JsonKey(name: 'farms_count')
  int get farmsCount;

  /// Create a copy of ExploreInSeasonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreInSeasonModelImplCopyWith<_$ExploreInSeasonModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExploreGroupBuyModel _$ExploreGroupBuyModelFromJson(Map<String, dynamic> json) {
  return _ExploreGroupBuyModel.fromJson(json);
}

/// @nodoc
mixin _$ExploreGroupBuyModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'farm_name')
  String get farmName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_price')
  double get originalPrice => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'joined_count')
  int get joinedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_count')
  int get targetCount => throw _privateConstructorUsedError;

  /// Serializes this ExploreGroupBuyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreGroupBuyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreGroupBuyModelCopyWith<ExploreGroupBuyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreGroupBuyModelCopyWith<$Res> {
  factory $ExploreGroupBuyModelCopyWith(ExploreGroupBuyModel value,
          $Res Function(ExploreGroupBuyModel) then) =
      _$ExploreGroupBuyModelCopyWithImpl<$Res, ExploreGroupBuyModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'farm_name') String farmName,
      double price,
      @JsonKey(name: 'original_price') double originalPrice,
      String image,
      @JsonKey(name: 'joined_count') int joinedCount,
      @JsonKey(name: 'target_count') int targetCount});
}

/// @nodoc
class _$ExploreGroupBuyModelCopyWithImpl<$Res,
        $Val extends ExploreGroupBuyModel>
    implements $ExploreGroupBuyModelCopyWith<$Res> {
  _$ExploreGroupBuyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreGroupBuyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? farmName = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? image = null,
    Object? joinedCount = null,
    Object? targetCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      farmName: null == farmName
          ? _value.farmName
          : farmName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      joinedCount: null == joinedCount
          ? _value.joinedCount
          : joinedCount // ignore: cast_nullable_to_non_nullable
              as int,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreGroupBuyModelImplCopyWith<$Res>
    implements $ExploreGroupBuyModelCopyWith<$Res> {
  factory _$$ExploreGroupBuyModelImplCopyWith(_$ExploreGroupBuyModelImpl value,
          $Res Function(_$ExploreGroupBuyModelImpl) then) =
      __$$ExploreGroupBuyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'farm_name') String farmName,
      double price,
      @JsonKey(name: 'original_price') double originalPrice,
      String image,
      @JsonKey(name: 'joined_count') int joinedCount,
      @JsonKey(name: 'target_count') int targetCount});
}

/// @nodoc
class __$$ExploreGroupBuyModelImplCopyWithImpl<$Res>
    extends _$ExploreGroupBuyModelCopyWithImpl<$Res, _$ExploreGroupBuyModelImpl>
    implements _$$ExploreGroupBuyModelImplCopyWith<$Res> {
  __$$ExploreGroupBuyModelImplCopyWithImpl(_$ExploreGroupBuyModelImpl _value,
      $Res Function(_$ExploreGroupBuyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreGroupBuyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? farmName = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? image = null,
    Object? joinedCount = null,
    Object? targetCount = null,
  }) {
    return _then(_$ExploreGroupBuyModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      farmName: null == farmName
          ? _value.farmName
          : farmName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      joinedCount: null == joinedCount
          ? _value.joinedCount
          : joinedCount // ignore: cast_nullable_to_non_nullable
              as int,
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreGroupBuyModelImpl extends _ExploreGroupBuyModel {
  const _$ExploreGroupBuyModelImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'farm_name') required this.farmName,
      required this.price,
      @JsonKey(name: 'original_price') required this.originalPrice,
      required this.image,
      @JsonKey(name: 'joined_count') required this.joinedCount,
      @JsonKey(name: 'target_count') required this.targetCount})
      : super._();

  factory _$ExploreGroupBuyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreGroupBuyModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'farm_name')
  final String farmName;
  @override
  final double price;
  @override
  @JsonKey(name: 'original_price')
  final double originalPrice;
  @override
  final String image;
  @override
  @JsonKey(name: 'joined_count')
  final int joinedCount;
  @override
  @JsonKey(name: 'target_count')
  final int targetCount;

  @override
  String toString() {
    return 'ExploreGroupBuyModel(id: $id, title: $title, farmName: $farmName, price: $price, originalPrice: $originalPrice, image: $image, joinedCount: $joinedCount, targetCount: $targetCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreGroupBuyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.farmName, farmName) ||
                other.farmName == farmName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.joinedCount, joinedCount) ||
                other.joinedCount == joinedCount) &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, farmName, price,
      originalPrice, image, joinedCount, targetCount);

  /// Create a copy of ExploreGroupBuyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreGroupBuyModelImplCopyWith<_$ExploreGroupBuyModelImpl>
      get copyWith =>
          __$$ExploreGroupBuyModelImplCopyWithImpl<_$ExploreGroupBuyModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreGroupBuyModelImplToJson(
      this,
    );
  }
}

abstract class _ExploreGroupBuyModel extends ExploreGroupBuyModel {
  const factory _ExploreGroupBuyModel(
          {required final String id,
          required final String title,
          @JsonKey(name: 'farm_name') required final String farmName,
          required final double price,
          @JsonKey(name: 'original_price') required final double originalPrice,
          required final String image,
          @JsonKey(name: 'joined_count') required final int joinedCount,
          @JsonKey(name: 'target_count') required final int targetCount}) =
      _$ExploreGroupBuyModelImpl;
  const _ExploreGroupBuyModel._() : super._();

  factory _ExploreGroupBuyModel.fromJson(Map<String, dynamic> json) =
      _$ExploreGroupBuyModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'farm_name')
  String get farmName;
  @override
  double get price;
  @override
  @JsonKey(name: 'original_price')
  double get originalPrice;
  @override
  String get image;
  @override
  @JsonKey(name: 'joined_count')
  int get joinedCount;
  @override
  @JsonKey(name: 'target_count')
  int get targetCount;

  /// Create a copy of ExploreGroupBuyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreGroupBuyModelImplCopyWith<_$ExploreGroupBuyModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExploreNearbyFarmerModel _$ExploreNearbyFarmerModelFromJson(
    Map<String, dynamic> json) {
  return _ExploreNearbyFarmerModel.fromJson(json);
}

/// @nodoc
mixin _$ExploreNearbyFarmerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image')
  String get coverImage => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double get distanceKm => throw _privateConstructorUsedError;
  List<String> get specialties => throw _privateConstructorUsedError;

  /// Serializes this ExploreNearbyFarmerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreNearbyFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreNearbyFarmerModelCopyWith<ExploreNearbyFarmerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreNearbyFarmerModelCopyWith<$Res> {
  factory $ExploreNearbyFarmerModelCopyWith(ExploreNearbyFarmerModel value,
          $Res Function(ExploreNearbyFarmerModel) then) =
      _$ExploreNearbyFarmerModelCopyWithImpl<$Res, ExploreNearbyFarmerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'cover_image') String coverImage,
      double rating,
      @JsonKey(name: 'distance_km') double distanceKm,
      List<String> specialties});
}

/// @nodoc
class _$ExploreNearbyFarmerModelCopyWithImpl<$Res,
        $Val extends ExploreNearbyFarmerModel>
    implements $ExploreNearbyFarmerModelCopyWith<$Res> {
  _$ExploreNearbyFarmerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreNearbyFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? coverImage = null,
    Object? rating = null,
    Object? distanceKm = null,
    Object? specialties = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coverImage: null == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      specialties: null == specialties
          ? _value.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreNearbyFarmerModelImplCopyWith<$Res>
    implements $ExploreNearbyFarmerModelCopyWith<$Res> {
  factory _$$ExploreNearbyFarmerModelImplCopyWith(
          _$ExploreNearbyFarmerModelImpl value,
          $Res Function(_$ExploreNearbyFarmerModelImpl) then) =
      __$$ExploreNearbyFarmerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'cover_image') String coverImage,
      double rating,
      @JsonKey(name: 'distance_km') double distanceKm,
      List<String> specialties});
}

/// @nodoc
class __$$ExploreNearbyFarmerModelImplCopyWithImpl<$Res>
    extends _$ExploreNearbyFarmerModelCopyWithImpl<$Res,
        _$ExploreNearbyFarmerModelImpl>
    implements _$$ExploreNearbyFarmerModelImplCopyWith<$Res> {
  __$$ExploreNearbyFarmerModelImplCopyWithImpl(
      _$ExploreNearbyFarmerModelImpl _value,
      $Res Function(_$ExploreNearbyFarmerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreNearbyFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? coverImage = null,
    Object? rating = null,
    Object? distanceKm = null,
    Object? specialties = null,
  }) {
    return _then(_$ExploreNearbyFarmerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coverImage: null == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      specialties: null == specialties
          ? _value._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreNearbyFarmerModelImpl extends _ExploreNearbyFarmerModel {
  const _$ExploreNearbyFarmerModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'cover_image') required this.coverImage,
      required this.rating,
      @JsonKey(name: 'distance_km') required this.distanceKm,
      final List<String> specialties = const []})
      : _specialties = specialties,
        super._();

  factory _$ExploreNearbyFarmerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreNearbyFarmerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'cover_image')
  final String coverImage;
  @override
  final double rating;
  @override
  @JsonKey(name: 'distance_km')
  final double distanceKm;
  final List<String> _specialties;
  @override
  @JsonKey()
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  @override
  String toString() {
    return 'ExploreNearbyFarmerModel(id: $id, name: $name, coverImage: $coverImage, rating: $rating, distanceKm: $distanceKm, specialties: $specialties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreNearbyFarmerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, coverImage, rating,
      distanceKm, const DeepCollectionEquality().hash(_specialties));

  /// Create a copy of ExploreNearbyFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreNearbyFarmerModelImplCopyWith<_$ExploreNearbyFarmerModelImpl>
      get copyWith => __$$ExploreNearbyFarmerModelImplCopyWithImpl<
          _$ExploreNearbyFarmerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreNearbyFarmerModelImplToJson(
      this,
    );
  }
}

abstract class _ExploreNearbyFarmerModel extends ExploreNearbyFarmerModel {
  const factory _ExploreNearbyFarmerModel(
      {required final String id,
      required final String name,
      @JsonKey(name: 'cover_image') required final String coverImage,
      required final double rating,
      @JsonKey(name: 'distance_km') required final double distanceKm,
      final List<String> specialties}) = _$ExploreNearbyFarmerModelImpl;
  const _ExploreNearbyFarmerModel._() : super._();

  factory _ExploreNearbyFarmerModel.fromJson(Map<String, dynamic> json) =
      _$ExploreNearbyFarmerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'cover_image')
  String get coverImage;
  @override
  double get rating;
  @override
  @JsonKey(name: 'distance_km')
  double get distanceKm;
  @override
  List<String> get specialties;

  /// Create a copy of ExploreNearbyFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreNearbyFarmerModelImplCopyWith<_$ExploreNearbyFarmerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExplorePreOrderModel _$ExplorePreOrderModelFromJson(Map<String, dynamic> json) {
  return _ExplorePreOrderModel.fromJson(json);
}

/// @nodoc
mixin _$ExplorePreOrderModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'farmer_name')
  String get farmerName => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_percentage')
  double get progressPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_left')
  int get daysLeft => throw _privateConstructorUsedError;

  /// Serializes this ExplorePreOrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExplorePreOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExplorePreOrderModelCopyWith<ExplorePreOrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExplorePreOrderModelCopyWith<$Res> {
  factory $ExplorePreOrderModelCopyWith(ExplorePreOrderModel value,
          $Res Function(ExplorePreOrderModel) then) =
      _$ExplorePreOrderModelCopyWithImpl<$Res, ExplorePreOrderModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'farmer_name') String farmerName,
      String image,
      @JsonKey(name: 'progress_percentage') double progressPercentage,
      @JsonKey(name: 'days_left') int daysLeft});
}

/// @nodoc
class _$ExplorePreOrderModelCopyWithImpl<$Res,
        $Val extends ExplorePreOrderModel>
    implements $ExplorePreOrderModelCopyWith<$Res> {
  _$ExplorePreOrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExplorePreOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? farmerName = null,
    Object? image = null,
    Object? progressPercentage = null,
    Object? daysLeft = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      farmerName: null == farmerName
          ? _value.farmerName
          : farmerName // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      daysLeft: null == daysLeft
          ? _value.daysLeft
          : daysLeft // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExplorePreOrderModelImplCopyWith<$Res>
    implements $ExplorePreOrderModelCopyWith<$Res> {
  factory _$$ExplorePreOrderModelImplCopyWith(_$ExplorePreOrderModelImpl value,
          $Res Function(_$ExplorePreOrderModelImpl) then) =
      __$$ExplorePreOrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'farmer_name') String farmerName,
      String image,
      @JsonKey(name: 'progress_percentage') double progressPercentage,
      @JsonKey(name: 'days_left') int daysLeft});
}

/// @nodoc
class __$$ExplorePreOrderModelImplCopyWithImpl<$Res>
    extends _$ExplorePreOrderModelCopyWithImpl<$Res, _$ExplorePreOrderModelImpl>
    implements _$$ExplorePreOrderModelImplCopyWith<$Res> {
  __$$ExplorePreOrderModelImplCopyWithImpl(_$ExplorePreOrderModelImpl _value,
      $Res Function(_$ExplorePreOrderModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExplorePreOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? farmerName = null,
    Object? image = null,
    Object? progressPercentage = null,
    Object? daysLeft = null,
  }) {
    return _then(_$ExplorePreOrderModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      farmerName: null == farmerName
          ? _value.farmerName
          : farmerName // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      progressPercentage: null == progressPercentage
          ? _value.progressPercentage
          : progressPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      daysLeft: null == daysLeft
          ? _value.daysLeft
          : daysLeft // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExplorePreOrderModelImpl extends _ExplorePreOrderModel {
  const _$ExplorePreOrderModelImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'farmer_name') required this.farmerName,
      required this.image,
      @JsonKey(name: 'progress_percentage') required this.progressPercentage,
      @JsonKey(name: 'days_left') required this.daysLeft})
      : super._();

  factory _$ExplorePreOrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExplorePreOrderModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'farmer_name')
  final String farmerName;
  @override
  final String image;
  @override
  @JsonKey(name: 'progress_percentage')
  final double progressPercentage;
  @override
  @JsonKey(name: 'days_left')
  final int daysLeft;

  @override
  String toString() {
    return 'ExplorePreOrderModel(id: $id, title: $title, farmerName: $farmerName, image: $image, progressPercentage: $progressPercentage, daysLeft: $daysLeft)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExplorePreOrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.farmerName, farmerName) ||
                other.farmerName == farmerName) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.progressPercentage, progressPercentage) ||
                other.progressPercentage == progressPercentage) &&
            (identical(other.daysLeft, daysLeft) ||
                other.daysLeft == daysLeft));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, farmerName, image, progressPercentage, daysLeft);

  /// Create a copy of ExplorePreOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExplorePreOrderModelImplCopyWith<_$ExplorePreOrderModelImpl>
      get copyWith =>
          __$$ExplorePreOrderModelImplCopyWithImpl<_$ExplorePreOrderModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExplorePreOrderModelImplToJson(
      this,
    );
  }
}

abstract class _ExplorePreOrderModel extends ExplorePreOrderModel {
  const factory _ExplorePreOrderModel(
          {required final String id,
          required final String title,
          @JsonKey(name: 'farmer_name') required final String farmerName,
          required final String image,
          @JsonKey(name: 'progress_percentage')
          required final double progressPercentage,
          @JsonKey(name: 'days_left') required final int daysLeft}) =
      _$ExplorePreOrderModelImpl;
  const _ExplorePreOrderModel._() : super._();

  factory _ExplorePreOrderModel.fromJson(Map<String, dynamic> json) =
      _$ExplorePreOrderModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'farmer_name')
  String get farmerName;
  @override
  String get image;
  @override
  @JsonKey(name: 'progress_percentage')
  double get progressPercentage;
  @override
  @JsonKey(name: 'days_left')
  int get daysLeft;

  /// Create a copy of ExplorePreOrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExplorePreOrderModelImplCopyWith<_$ExplorePreOrderModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ExploreExperienceModel _$ExploreExperienceModelFromJson(
    Map<String, dynamic> json) {
  return _ExploreExperienceModel.fromJson(json);
}

/// @nodoc
mixin _$ExploreExperienceModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_string')
  String get dateString => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;

  /// Serializes this ExploreExperienceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExploreExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExploreExperienceModelCopyWith<ExploreExperienceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExploreExperienceModelCopyWith<$Res> {
  factory $ExploreExperienceModelCopyWith(ExploreExperienceModel value,
          $Res Function(ExploreExperienceModel) then) =
      _$ExploreExperienceModelCopyWithImpl<$Res, ExploreExperienceModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String location,
      @JsonKey(name: 'date_string') String dateString,
      double price,
      String image});
}

/// @nodoc
class _$ExploreExperienceModelCopyWithImpl<$Res,
        $Val extends ExploreExperienceModel>
    implements $ExploreExperienceModelCopyWith<$Res> {
  _$ExploreExperienceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExploreExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = null,
    Object? dateString = null,
    Object? price = null,
    Object? image = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      dateString: null == dateString
          ? _value.dateString
          : dateString // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExploreExperienceModelImplCopyWith<$Res>
    implements $ExploreExperienceModelCopyWith<$Res> {
  factory _$$ExploreExperienceModelImplCopyWith(
          _$ExploreExperienceModelImpl value,
          $Res Function(_$ExploreExperienceModelImpl) then) =
      __$$ExploreExperienceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String location,
      @JsonKey(name: 'date_string') String dateString,
      double price,
      String image});
}

/// @nodoc
class __$$ExploreExperienceModelImplCopyWithImpl<$Res>
    extends _$ExploreExperienceModelCopyWithImpl<$Res,
        _$ExploreExperienceModelImpl>
    implements _$$ExploreExperienceModelImplCopyWith<$Res> {
  __$$ExploreExperienceModelImplCopyWithImpl(
      _$ExploreExperienceModelImpl _value,
      $Res Function(_$ExploreExperienceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExploreExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? location = null,
    Object? dateString = null,
    Object? price = null,
    Object? image = null,
  }) {
    return _then(_$ExploreExperienceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      dateString: null == dateString
          ? _value.dateString
          : dateString // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExploreExperienceModelImpl extends _ExploreExperienceModel {
  const _$ExploreExperienceModelImpl(
      {required this.id,
      required this.title,
      required this.location,
      @JsonKey(name: 'date_string') required this.dateString,
      required this.price,
      required this.image})
      : super._();

  factory _$ExploreExperienceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExploreExperienceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String location;
  @override
  @JsonKey(name: 'date_string')
  final String dateString;
  @override
  final double price;
  @override
  final String image;

  @override
  String toString() {
    return 'ExploreExperienceModel(id: $id, title: $title, location: $location, dateString: $dateString, price: $price, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExploreExperienceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.dateString, dateString) ||
                other.dateString == dateString) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, location, dateString, price, image);

  /// Create a copy of ExploreExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExploreExperienceModelImplCopyWith<_$ExploreExperienceModelImpl>
      get copyWith => __$$ExploreExperienceModelImplCopyWithImpl<
          _$ExploreExperienceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExploreExperienceModelImplToJson(
      this,
    );
  }
}

abstract class _ExploreExperienceModel extends ExploreExperienceModel {
  const factory _ExploreExperienceModel(
      {required final String id,
      required final String title,
      required final String location,
      @JsonKey(name: 'date_string') required final String dateString,
      required final double price,
      required final String image}) = _$ExploreExperienceModelImpl;
  const _ExploreExperienceModel._() : super._();

  factory _ExploreExperienceModel.fromJson(Map<String, dynamic> json) =
      _$ExploreExperienceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get location;
  @override
  @JsonKey(name: 'date_string')
  String get dateString;
  @override
  double get price;
  @override
  String get image;

  /// Create a copy of ExploreExperienceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExploreExperienceModelImplCopyWith<_$ExploreExperienceModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
