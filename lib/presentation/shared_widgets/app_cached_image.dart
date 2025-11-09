import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:harvest_app/core/config/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// A customizable and reusable widget for displaying cached network images
/// with built-in loading placeholders and error handling.
///
/// This widget wraps [CachedNetworkImage] with standardized shimmer loading
/// effects and error states, providing a consistent image loading experience
/// throughout the application.
///
/// **Features:**
/// - Automatic image caching for improved performance
/// - Shimmer loading animation during image load
/// - Graceful error handling with fallback UI
/// - Customizable dimensions and styling
/// - Optional border radius support
/// - Extensible placeholder and error widgets
///
/// **Example Usage:**
/// ```dart
/// // Basic usage
/// AppCachedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   height: 200,
/// )
///
/// // With custom styling
/// AppCachedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   height: 150,
///   width: 150,
///   borderRadius: BorderRadius.circular(12.r),
///   fit: BoxFit.contain,
/// )
///
/// // Profile avatar example
/// ClipOval(
///   child: AppCachedImage(
///     imageUrl: userAvatarUrl,
///     height: 60,
///     width: 60,
///   ),
/// )
/// ```
class AppCachedImage extends StatelessWidget {
  /// The URL of the image to be displayed.
  ///
  /// This should be a valid HTTP or HTTPS URL pointing to an image resource.
  /// The image will be cached automatically after the first successful load.
  final String imageUrl;

  /// The height constraint for the image.
  ///
  /// If null, the image will size itself based on its intrinsic dimensions
  /// or parent constraints. When specified, this height is also applied to
  /// the placeholder and error widgets for consistent layout.
  final double? height;

  /// The width constraint for the image.
  ///
  /// Defaults to [double.infinity] to fill available horizontal space.
  /// When specified, this width is also applied to the placeholder and
  /// error widgets for consistent layout.
  final double? width;

  /// How the image should be inscribed into the allocated space.
  ///
  /// Defaults to [BoxFit.cover] which scales the image to cover the entire
  /// container, potentially cropping the image if aspect ratios don't match.
  ///
  /// Common values:
  /// - [BoxFit.cover]: Scales to cover entire space (may crop)
  /// - [BoxFit.contain]: Scales to fit entirely within space (may letterbox)
  /// - [BoxFit.fill]: Stretches to fill space exactly (may distort)
  final BoxFit fit;

  /// The height of the shimmer placeholder during loading.
  ///
  /// If null, defaults to [height] or 64 pixels as fallback.
  /// Useful when you want the placeholder to have different dimensions
  /// than the final image.
  final double? placeholderHeight;

  /// The width of the shimmer placeholder during loading.
  ///
  /// If null, defaults to [width] or [double.infinity] as fallback.
  /// Useful when you want the placeholder to have different dimensions
  /// than the final image.
  final double? placeholderWidth;

  /// The base color for the shimmer animation effect.
  ///
  /// This is the darker color in the shimmer gradient. If null, defaults
  /// to a semi-transparent grey from the app's color scheme.
  /// Should have good contrast with [highlightColor].
  final Color? baseColor;

  /// The highlight color for the shimmer animation effect.
  ///
  /// This is the lighter color that creates the "shine" effect in the shimmer.
  /// If null, defaults to a semi-transparent white from the app's color scheme.
  /// Should be lighter than [baseColor] for proper visual effect.
  final Color? highlightColor;

  /// The background color of the error state container.
  ///
  /// Displayed when the image fails to load. If null, defaults to the
  /// app's background color. Should provide good contrast with [errorIconColor].
  final Color? errorBackgroundColor;

  /// The icon displayed in the error state.
  ///
  /// Defaults to [Icons.broken_image_rounded]. Choose an icon that clearly
  /// indicates an image loading failure to users.
  final IconData errorIcon;

  /// The size of the error state icon in logical pixels.
  ///
  /// Defaults to 32.0. Should be proportional to the image dimensions
  /// for good visual balance.
  final double errorIconSize;

  /// The color of the error state icon.
  ///
  /// If null, defaults to the app's grey color. Should have good contrast
  /// with [errorBackgroundColor] for accessibility.
  final Color? errorIconColor;

  /// The border radius applied to the image and its states.
  ///
  /// When provided, wraps the entire widget tree in a [ClipRRect] to apply
  /// rounded corners consistently across loading, loaded, and error states.
  ///
  /// Example: `BorderRadius.circular(8.r)` for rounded corners
  final BorderRadius? borderRadius;

  /// An optional asset image path to display in the error state.
  /// If provided, this image will be shown instead of the default error icon.
  /// This can be used to display a branded or themed error image.
  ///
  /// Example: `assets/images/error_image.png`
  final String? errorAssetImage;

  /// A custom widget builder to display during image loading.
  ///
  /// When provided, completely replaces the default shimmer placeholder.
  /// The widget should ideally match the expected dimensions of the final image
  /// to prevent layout shifts.
  ///
  /// The builder receives the [BuildContext] and image URL as parameters.
  ///
  /// Example:
  /// ```dart
  /// customPlaceholder: (context, url) => Container(
  ///   height: 200,
  ///   color: Colors.grey[300],
  ///   child: Center(child: CircularProgressIndicator()),
  /// )
  /// ```
  final PlaceholderWidgetBuilder? customPlaceholder;

  /// A custom widget builder to display when image loading fails.
  ///
  /// When provided, completely replaces the default error state UI.
  /// Should clearly indicate to users that the image failed to load.
  ///
  /// The builder receives the [BuildContext], image URL, and error as parameters.
  ///
  /// Example:
  /// ```dart
  /// customErrorWidget: (context, url, error) => Container(
  ///   height: 200,
  ///   color: Colors.red[50],
  ///   child: Column(
  ///     mainAxisAlignment: MainAxisAlignment.center,
  ///     children: [
  ///       Icon(Icons.error, color: Colors.red),
  ///       Text('Failed to load image'),
  ///     ],
  ///   ),
  /// )
  /// ```
  final LoadingErrorWidgetBuilder? customErrorWidget;

  /// Creates an [AppCachedImage] widget.
  ///
  /// The [imageUrl] parameter is required and should be a valid HTTP/HTTPS URL.
  /// All other parameters are optional and have sensible defaults.
  ///
  /// **Performance Considerations:**
  /// - Images are automatically cached after first load
  /// - Large images are automatically resized based on widget constraints
  /// - Memory usage is managed by the underlying [CachedNetworkImage]
  ///
  /// **Accessibility:**
  /// - Consider providing semantic labels for images when used in complex layouts
  /// - Ensure error states have sufficient color contrast
  /// - Error icons should be recognizable to users with visual impairments
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.placeholderHeight,
    this.placeholderWidth,
    this.baseColor,
    this.highlightColor,
    this.errorBackgroundColor,
    this.errorIcon = Icons.image_not_supported_outlined,
    this.errorIconSize = 32,
    this.errorIconColor,
    this.borderRadius,
    this.customPlaceholder,
    this.errorAssetImage,
    this.customErrorWidget,
  }) : assert(errorIconSize > 0, 'errorIconSize must be positive');

  @override
  Widget build(BuildContext context) {
    // Runtime validation for imageUrl
    assert(imageUrl.isNotEmpty, 'imageUrl cannot be empty');

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: customPlaceholder ?? _buildPlaceholder,
      errorWidget: customErrorWidget ?? _buildErrorWidget,
    );

    // Apply border radius if specified
    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  /// Builds the default shimmer loading placeholder.
  ///
  /// Creates a shimmer animation effect with customizable colors and dimensions.
  /// The shimmer provides visual feedback that content is loading, improving
  /// perceived performance.
  ///
  /// **Parameters:**
  /// - [context]: The build context (required by CachedNetworkImage)
  /// - [url]: The image URL being loaded (required by CachedNetworkImage)
  ///
  /// **Returns:**
  /// A [Widget] containing the shimmer animation with a colored container.
  Widget _buildPlaceholder(BuildContext context, String url) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.withValues(alpha: 0.3),
      highlightColor: highlightColor ?? AppColors.white.withValues(alpha: 0.5),
      child: Container(
        height: placeholderHeight ?? height ?? 64,
        width: placeholderWidth ?? width ?? double.infinity,
        color: baseColor ?? Colors.grey.withValues(alpha: 0.3),
      ),
    );
  }

  /// Builds the default error state widget.
  ///
  /// Displays an icon or fallback image indicating the image failed to load.
  /// The error state provides clear feedback to users, allowing them to
  /// understand that the content is unavailable.
  ///
  /// **Parameters:**
  /// - [context]: The build context (required by CachedNetworkImage)
  /// - [url]: The image URL that failed to load (required by CachedNetworkImage)
  /// - [error]: The error that occurred during loading (required by CachedNetworkImage)
  ///
  /// **Returns:**
  /// A [Widget] containing the error state UI with icon and background.
  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    // If a fallback asset image is provided, use it.
    if (errorAssetImage != null && errorAssetImage!.isNotEmpty) {
      return Image.asset(
        errorAssetImage!,
        height: height,
        width: width,
        fit: fit,
      );
    }

    // Otherwise, show the default icon-based error widget.
    return Container(
      height: height ?? 64,
      width: width ?? double.infinity,
      color: errorBackgroundColor ?? Colors.grey.shade100,
      child: Icon(
        errorIcon,
        size: errorIconSize,
        color: errorIconColor ?? Colors.grey.shade400,
      ),
    );
  }
}

/// A simplified version of [AppCachedImage] for common use cases.
///
/// This widget provides a streamlined API for the most frequent image loading
/// scenarios, reducing boilerplate while maintaining the core functionality
/// of the full [AppCachedImage] widget.
///
/// **Use this when:**
/// - You need basic image loading with default styling
/// - You don't need custom colors or error handling
/// - You want minimal configuration
///
/// **Use [AppCachedImage] when:**
/// - You need custom placeholder/error styling
/// - You want to override default colors
/// - You need advanced configuration options
///
/// **Example:**
/// ```dart
/// SimpleCachedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   height: 200,
///   borderRadius: BorderRadius.circular(8.r),
/// )
/// ```
class SimpleCachedImage extends StatelessWidget {
  /// The URL of the image to be displayed.
  ///
  /// Must be a valid HTTP or HTTPS URL pointing to an image resource.
  final String imageUrl;

  /// The height constraint for the image.
  ///
  /// If null, the image will size itself based on available space or
  /// intrinsic dimensions.
  final double? height;

  /// The width constraint for the image.
  ///
  /// If null, defaults to available horizontal space. Unlike [AppCachedImage],
  /// this doesn't default to [double.infinity] to allow for more flexible sizing.
  final double? width;

  /// How the image should be inscribed into the allocated space.
  ///
  /// Defaults to [BoxFit.cover]. See [AppCachedImage.fit] for more details
  /// on available options and their behavior.
  final BoxFit fit;

  /// The border radius applied to the image.
  ///
  /// When provided, rounds the corners of the image and all its states
  /// (loading, loaded, error) consistently.
  final BorderRadius? borderRadius;

  /// Creates a [SimpleCachedImage] widget with minimal configuration.
  ///
  /// This constructor only exposes the most commonly used parameters,
  /// making it ideal for straightforward image loading scenarios.
  ///
  /// **Example:**
  /// ```dart
  /// SimpleCachedImage(
  ///   imageUrl: productImageUrl,
  ///   height: 150,
  ///   fit: BoxFit.contain,
  /// )
  /// ```
  const SimpleCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AppCachedImage(
      imageUrl: imageUrl,
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      borderRadius: borderRadius,
    );
  }
}

/// Example usage patterns for [AppCachedImage] and [SimpleCachedImage].
///
/// This class demonstrates various ways to use the cached image components
/// in different scenarios commonly found in mobile applications.
///
/// **Note:** This class is for documentation purposes and should not be
/// included in production code. Copy the relevant examples to your
/// implementation files as needed.
class AppCachedImageExamples extends StatelessWidget {
  const AppCachedImageExamples({super.key});

  /// Demonstrates various usage patterns for the cached image components.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic usage - equivalent to original implementation
        const Text('Basic Usage:'),
        const AppCachedImage(
          imageUrl: 'https://example.com/image.jpg',
          height: 96,
        ),

        const SizedBox(height: 16),

        // Custom dimensions with different fit
        const Text('Custom Dimensions:'),
        const AppCachedImage(
          imageUrl: 'https://example.com/image.jpg',
          height: 200,
          width: 150,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: 16),

        // Rounded corners for modern UI
        const Text('With Border Radius:'),
        const AppCachedImage(
          imageUrl: 'https://example.com/image.jpg',
          height: 100,
          width: 100,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),

        const SizedBox(height: 16),

        // Custom styling for brand consistency
        const Text('Custom Colors:'),
        AppCachedImage(
          imageUrl: 'https://example.com/image.jpg',
          height: 96,
          baseColor: Colors.grey.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.7),
          errorBackgroundColor: Colors.red.withValues(alpha: 0.1),
          errorIconColor: Colors.red,
        ),

        const SizedBox(height: 16),

        // Profile avatar with circular clipping
        const Text('Circular Avatar:'),
        const ClipOval(
          child: AppCachedImage(
            imageUrl: 'https://example.com/avatar.jpg',
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 16),

        // Simplified version for quick implementation
        const Text('Simplified Version:'),
        const SimpleCachedImage(
          imageUrl: 'https://example.com/image.jpg',
          height: 120,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ],
    );
  }
}
