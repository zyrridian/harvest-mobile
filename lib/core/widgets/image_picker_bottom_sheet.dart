import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final Function(String path) onImagePicked;

  const ImagePickerBottomSheet({super.key, required this.onImagePicked});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null && context.mounted) {
        onImagePicked(image.path);
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to pick image')),
        );
        Navigator.pop(context);
      }
    }
  }

  static Future<void> show(BuildContext context, {required Function(String path) onImagePicked}) async {
    if (kIsWeb) {
      final picker = ImagePicker();
      try {
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1080,
          maxHeight: 1080,
          imageQuality: 85,
        );
        if (image != null && context.mounted) {
          onImagePicked(image.path);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to pick image')),
          );
        }
      }
      return;
    }

    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImagePickerBottomSheet(onImagePicked: onImagePicked),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 40, left: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2F25),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF6E7A75)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildOption(
                  context: context,
                  icon: PhosphorIconsRegular.camera,
                  label: 'Camera',
                  onTap: () => _pickImage(context, ImageSource.camera),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOption(
                  context: context,
                  icon: PhosphorIconsRegular.image,
                  label: 'Gallery',
                  onTap: () => _pickImage(context, ImageSource.gallery),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF1A2F25)),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A2F25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
