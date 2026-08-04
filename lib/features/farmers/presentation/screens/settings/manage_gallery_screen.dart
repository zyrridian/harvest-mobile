import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_app/core/config/router/app_router.dart';
import 'package:harvest_app/features/farmers/domain/entities/farmer_gallery_image.dart';
import 'package:harvest_app/features/farmers/presentation/providers/settings/manage_gallery_controller.dart';
import 'package:harvest_app/core/widgets/image_picker_bottom_sheet.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_cropper/image_cropper.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class ManageGalleryScreen extends ConsumerWidget {
  const ManageGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryState = ref.watch(manageGalleryControllerProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.caretLeft,
              color: kDarkGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Manage Gallery',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kDarkGreen,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
        ),
        actions: [
          IconButton(
            icon: const PhosphorIcon(PhosphorIconsRegular.plus,
                color: kDarkGreen),
            onPressed: () => _showAddImageDialog(context, ref),
          ),
        ],
      ),
      body: galleryState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kDarkGreen)),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PhosphorIcon(PhosphorIconsRegular.warningCircle,
                  size: 48, color: kTextGrey),
              const SizedBox(height: 16),
              Text(error.toString(), style: const TextStyle(color: kTextGrey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref
                    .read(manageGalleryControllerProvider.notifier)
                    .refresh(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkGreen, foregroundColor: Colors.white),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (images) {
          if (images.isEmpty) {
            return RefreshIndicator(
              color: kDarkGreen,
              backgroundColor: Colors.white,
              onRefresh: () => ref.read(manageGalleryControllerProvider.notifier).refresh(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const PhosphorIcon(PhosphorIconsRegular.image,
                                size: 64, color: kPillGrey),
                            const SizedBox(height: 16),
                            Text(
                              'No images in your gallery',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: kTextGrey,
                                    fontSize: 16,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => _showAddImageDialog(context, ref),
                              icon: const PhosphorIcon(PhosphorIconsRegular.plus,
                                  size: 18),
                              label: const Text('Add Image'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kDarkGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: kDarkGreen,
            backgroundColor: Colors.white,
            onRefresh: () => ref.read(manageGalleryControllerProvider.notifier).refresh(),
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return _buildGalleryItem(context, ref, image);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGalleryItem(
      BuildContext context, WidgetRef ref, FarmerGalleryImage image) {
    return Stack(
      children: [
        // Image
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              context.push(
                AppRouter.imageViewer,
                extra: {
                  'heroTag': 'gallery_image_${image.id}',
                  'imageUrl': image.imageUrl,
                },
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Hero(
                tag: 'gallery_image_${image.id}',
                child: CachedNetworkImage(
                  imageUrl: image.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: kPillGrey,
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: kDarkGreen, strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: kPillGrey,
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Delete Button Overlay
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _showDeleteConfirmation(context, ref, image),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const PhosphorIcon(
                PhosphorIconsRegular.trash,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddImageDialog(BuildContext context, WidgetRef ref) {
    ImagePickerBottomSheet.show(
      context,
      onImagePicked: (path) async {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: kDarkGreen,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(
              title: 'Crop Image',
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
          ],
        );

        if (croppedFile != null && context.mounted) {
          final captionController = TextEditingController();
          final file = File(croppedFile.path);

          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('Add Gallery Image',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: kDarkGreen)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 250, // Finite constraint for IntrinsicWidth
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          file,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: captionController,
                      decoration: InputDecoration(
                        hintText: 'Add a caption (optional)',
                        filled: true,
                        fillColor: kPillGrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Cancel',
                        style: TextStyle(color: kTextGrey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final caption = captionController.text.trim();
                      ref
                          .read(manageGalleryControllerProvider.notifier)
                          .addImage(
                            file,
                            caption: caption.isNotEmpty ? caption : null,
                          );
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Uploading image...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kDarkGreen,
                        foregroundColor: Colors.white),
                    child: const Text('Upload'),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, FarmerGalleryImage image) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Image?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: kDarkGreen)),
          content: const Text(
              'Are you sure you want to remove this image from your gallery? This action cannot be undone.',
              style: TextStyle(color: kTextGrey, fontSize: 14)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: kTextGrey)),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(manageGalleryControllerProvider.notifier)
                    .deleteImage(image.id);
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image deleted successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
