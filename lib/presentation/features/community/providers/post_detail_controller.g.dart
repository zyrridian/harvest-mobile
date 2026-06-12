// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postDetailControllerHash() =>
    r'3b93a0c35f07bc73c1614f9dfcb325bf18810b2b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PostDetailController
    extends BuildlessAutoDisposeNotifier<PostDetailState> {
  late final String postId;

  PostDetailState build(
    String postId,
  );
}

/// See also [PostDetailController].
@ProviderFor(PostDetailController)
const postDetailControllerProvider = PostDetailControllerFamily();

/// See also [PostDetailController].
class PostDetailControllerFamily extends Family<PostDetailState> {
  /// See also [PostDetailController].
  const PostDetailControllerFamily();

  /// See also [PostDetailController].
  PostDetailControllerProvider call(
    String postId,
  ) {
    return PostDetailControllerProvider(
      postId,
    );
  }

  @override
  PostDetailControllerProvider getProviderOverride(
    covariant PostDetailControllerProvider provider,
  ) {
    return call(
      provider.postId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postDetailControllerProvider';
}

/// See also [PostDetailController].
class PostDetailControllerProvider extends AutoDisposeNotifierProviderImpl<
    PostDetailController, PostDetailState> {
  /// See also [PostDetailController].
  PostDetailControllerProvider(
    String postId,
  ) : this._internal(
          () => PostDetailController()..postId = postId,
          from: postDetailControllerProvider,
          name: r'postDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postDetailControllerHash,
          dependencies: PostDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              PostDetailControllerFamily._allTransitiveDependencies,
          postId: postId,
        );

  PostDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  PostDetailState runNotifierBuild(
    covariant PostDetailController notifier,
  ) {
    return notifier.build(
      postId,
    );
  }

  @override
  Override overrideWith(PostDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PostDetailControllerProvider._internal(
        () => create()..postId = postId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PostDetailController, PostDetailState>
      createElement() {
    return _PostDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailControllerProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostDetailControllerRef
    on AutoDisposeNotifierProviderRef<PostDetailState> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _PostDetailControllerProviderElement
    extends AutoDisposeNotifierProviderElement<PostDetailController,
        PostDetailState> with PostDetailControllerRef {
  _PostDetailControllerProviderElement(super.provider);

  @override
  String get postId => (origin as PostDetailControllerProvider).postId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
