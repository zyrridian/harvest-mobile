import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:harvest_app/features/community/presentation/providers/community_controller.dart';
import '../../../../presentation/providers/utility_providers.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

const kBgColor = Color(0xFFFFFFFF);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final List<String> _tags = [];
  final List<String> _images = [];
  bool _isLoading = false;
  bool _isUploadingImage = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && _tags.length < 5 && !_tags.contains(tag)) {
      setState(() => _tags.add(tag.trim()));
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  void _addImageUrl(String url) {
    if (url.isNotEmpty) {
      setState(() => _images.add(url.trim()));
      _imageUrlController.clear();
    }
  }

  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final useCase = ref.read(createPostUseCaseProvider);
    final result = await useCase.call(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      tags: _tags,
      images: _images,
    );

    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (post) {
        Navigator.pop(context, true); // Return true to indicate success and refresh feed
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    
    if (!mounted) return;
    setState(() => _isUploadingImage = true);
    
    try {
      final uploadFileUseCase = ref.read(uploadFileUseCaseProvider);
      final result = await uploadFileUseCase(File(pickedFile.path));
      
      if (!mounted) return;
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
        (uploadedFile) {
          _addImageUrl(uploadedFile.url);
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'New Post',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: kDarkGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _isLoading
                ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: kDarkGreen)))
                : ElevatedButton(
                    onPressed: _submitPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDarkGreen,
                      elevation: 0,
                      minimumSize: const Size(72, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tip Container
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPillGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kDarkGreen, fontSize: 13, height: 1.5),
                  children: const [
                    TextSpan(text: 'Tip: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'The community is a shared space for both farmers and consumers. If you run a farm, your posts will automatically be tagged with your farm\'s badge!'),
                  ],
                ),
              ),
            ),

            // Title Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 22, 
                  fontWeight: FontWeight.w700,
                  color: kDarkGreen,
                ),
                decoration: InputDecoration(
                  hintText: 'Post title',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 22, 
                    fontWeight: FontWeight.w700, 
                    color: Colors.grey.shade400
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const Divider(),

            // Content Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _contentController,
                maxLines: 8,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Share your thoughts, tips, or experiences...',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                  border: InputBorder.none,
                ),
              ),
            ),

            const Divider(),

            // Tags Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tag, size: 20, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text('Tags', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                      Text('(up to 5)', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      children: _tags.map((tag) => Chip(
                        label: Text('#$tag'),
                        onDeleted: () => _removeTag(tag),
                        backgroundColor: Colors.grey.shade100,
                        deleteIconColor: Colors.grey.shade600,
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_tags.length < 5)
                    TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Add a tag and press Enter',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      onSubmitted: _addTag,
                    ),
                ],
              ),
            ),

            const Divider(),

            // Images Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.image_outlined, size: 20, color: Colors.black87),
                      const SizedBox(width: 8),
                      Text('Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_images.isNotEmpty) ...[
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(_images[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _images.removeAt(index));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  GestureDetector(
                    onTap: _isUploadingImage ? null : _pickAndUploadImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomPaint(
                        painter: DashedBorderPainter(),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: _isUploadingImage 
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  '+ Add Image',
                                  style: TextStyle(color: Colors.blueGrey.shade400, fontWeight: FontWeight.w500),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 6.0;
    const double dashSpace = 4.0;
    
    // Draw top
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
    
    // Draw right
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width, startY), Offset(size.width, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
    
    // Draw bottom
    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX - dashWidth, size.height), paint);
      startX -= dashWidth + dashSpace;
    }
    
    // Draw left
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY - dashWidth), paint);
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
