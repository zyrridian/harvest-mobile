import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ImageViewerScreen extends StatelessWidget {
  final String heroTag;
  final String imageUrl;
  final bool isLocal;

  const ImageViewerScreen({
    super.key,
    required this.heroTag,
    required this.imageUrl,
    this.isLocal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const PhosphorIcon(PhosphorIconsRegular.x, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: isLocal
                ? (kIsWeb
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(imageUrl),
                        fit: BoxFit.contain,
                      ))
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white, size: 50),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
