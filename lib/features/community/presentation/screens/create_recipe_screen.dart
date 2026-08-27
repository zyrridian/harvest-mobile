import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/widgets/web_constrained_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:harvest_app/features/community/presentation/providers/recipe_controller.dart';
import 'package:harvest_app/features/system/presentation/providers/utility_providers.dart';

class CreateRecipeScreen extends ConsumerStatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  ConsumerState<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends ConsumerState<CreateRecipeScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  String _difficulty = 'medium';
  final List<String> _difficulties = ['easy', 'medium', 'hard'];

  String? _imageUrl;
  bool _isLoading = false;
  bool _isUploadingImage = false;

  final List<Map<String, dynamic>> _ingredients = [];
  final List<TextEditingController> _instructionControllers = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    for (var controller in _instructionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addIngredientRow() {
    setState(() {
      _ingredients.add({
        'nameController': TextEditingController(),
        'qtyController': TextEditingController(),
        'unitController': TextEditingController(),
      });
    });
  }

  void _removeIngredientRow(int index) {
    setState(() {
      (_ingredients[index]['nameController'] as TextEditingController)
          .dispose();
      (_ingredients[index]['qtyController'] as TextEditingController).dispose();
      (_ingredients[index]['unitController'] as TextEditingController)
          .dispose();
      _ingredients.removeAt(index);
    });
  }

  void _addInstructionRow() {
    setState(() {
      _instructionControllers.add(TextEditingController());
    });
  }

  void _removeInstructionRow(int index) {
    setState(() {
      _instructionControllers[index].dispose();
      _instructionControllers.removeAt(index);
    });
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
          setState(() {
            _imageUrl = uploadedFile.url;
          });
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

  Future<void> _submitRecipe() async {
    if (_titleController.text.trim().isEmpty || _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Image are required')),
      );
      return;
    }

    final prepTime = int.tryParse(_prepTimeController.text) ?? 0;
    final cookTime = int.tryParse(_cookTimeController.text) ?? 0;
    final servings = int.tryParse(_servingsController.text) ?? 1;

    final formattedIngredients = _ingredients
        .map((ing) {
          final qtyText = (ing['qtyController'] as TextEditingController).text;
          return {
            'name':
                (ing['nameController'] as TextEditingController).text.trim(),
            'quantity': qtyText.isNotEmpty ? double.tryParse(qtyText) : null,
            'unit':
                (ing['unitController'] as TextEditingController).text.trim(),
          };
        })
        .where((ing) => (ing['name'] as String).isNotEmpty)
        .toList();

    final formattedInstructions = _instructionControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    setState(() => _isLoading = true);

    final useCase = ref.read(createRecipeUseCaseProvider);
    final result = await useCase.call({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'image_url': _imageUrl,
      'prep_time_minutes': prepTime,
      'cook_time_minutes': cookTime,
      'servings': servings,
      'difficulty': _difficulty,
      'ingredients': formattedIngredients,
      'instructions': formattedInstructions,
      'is_featured': false,
    });

    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (recipe) {
        ref.read(recipeControllerProvider.notifier).refresh();
        Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebConstrainedBox(
      maxWidth: 600,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Create Recipe',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2)))
                  : ElevatedButton(
                      onPressed: _submitRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF86A789),
                        elevation: 0,
                        minimumSize: const Size(72, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Publish',
                          style: TextStyle(color: Colors.white)),
                    ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              GestureDetector(
                onTap: _isUploadingImage ? null : _pickAndUploadImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    image: _imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(_imageUrl!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _isUploadingImage
                      ? const Center(child: CircularProgressIndicator())
                      : _imageUrl == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined,
                                    size: 40, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                Text('Add Recipe Photo',
                                    style:
                                        TextStyle(color: Colors.grey.shade500)),
                              ],
                            )
                          : null,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              _buildLabel('Recipe Title'),
              TextField(
                controller: _titleController,
                decoration: _inputDecoration('e.g. Grandmas Apple Pie'),
              ),
              const SizedBox(height: 16),

              // Description
              _buildLabel('Description (Optional)'),
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration:
                    _inputDecoration('Share a little bit about this recipe...'),
              ),
              const SizedBox(height: 24),

              // Meta Details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Prep Time (min)'),
                        TextField(
                          controller: _prepTimeController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('15'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Cook Time (min)'),
                        TextField(
                          controller: _cookTimeController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('45'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Servings'),
                        TextField(
                          controller: _servingsController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('4'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Difficulty'),
                        DropdownButtonFormField<String>(
                          value: _difficulty,
                          decoration: _inputDecoration(''),
                          items: _difficulties.map((d) {
                            return DropdownMenuItem(
                              value: d,
                              child: Text(d[0].toUpperCase() + d.substring(1)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _difficulty = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // Ingredients
              Text('Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._ingredients.asMap().entries.map((entry) {
                final idx = entry.key;
                final ing = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: ing['nameController'],
                          decoration:
                              _inputDecoration('Ingredient (e.g. Flour)'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: ing['qtyController'],
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('Qty'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: ing['unitController'],
                          decoration: _inputDecoration('Unit (g)'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () => _removeIngredientRow(idx),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addIngredientRow,
                icon: const Icon(Icons.add, color: Color(0xFF166534)),
                label: Text('Add Ingredient',
                    style: TextStyle(color: const Color(0xFF166534))),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // Instructions
              Text('Instructions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._instructionControllers.asMap().entries.map((entry) {
                final idx = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${idx + 1}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          maxLines: 2,
                          decoration: _inputDecoration('Describe this step...'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () => _removeInstructionRow(idx),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: _addInstructionRow,
                icon: const Icon(Icons.add, color: Color(0xFF166534)),
                label: Text('Add Step',
                    style: TextStyle(color: const Color(0xFF166534))),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
