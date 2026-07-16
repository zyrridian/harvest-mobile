import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:harvest_app/features/catalog/domain/entities/product_request.dart';
import 'package:harvest_app/domain/entities/farmer_product_detail.dart';
import 'package:harvest_app/features/catalog/domain/entities/category.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmer_products_controller.dart';
import 'package:harvest_app/features/catalog/presentation/providers/category/category_providers.dart';
import 'package:harvest_app/features/farmers/presentation/providers/unit_providers.dart';
import 'package:harvest_app/core/widgets/app_cached_image.dart';
import 'package:harvest_app/core/widgets/image_picker_bottom_sheet.dart';
import 'package:intl/intl.dart';

const kBgColor = Colors.white;
const kDarkGreen = Color(0xFF1A2F25);
const kPrimaryGreen = Color(0xFF2D4A3E);
const kAccentOrange = Color(0xFFE86A33);
const kCardBg = Colors.white;
const kInputBg = Color(0xFFF5F5F5);
const kTextGrey = Color(0xFF6E7A75);
const kBorderColor = Color(0xFFE5E7EB);

class FarmerAddEditProductScreen extends ConsumerStatefulWidget {
  final String? productId;
  const FarmerAddEditProductScreen({super.key, this.productId});

  @override
  ConsumerState<FarmerAddEditProductScreen> createState() =>
      _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<FarmerAddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  FarmerProductDetail? _product;

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _longDescController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _minOrderController = TextEditingController(text: '1');
  final _maxOrderController = TextEditingController(text: '10');
  final _targetAmountController = TextEditingController();

  final _imageUrlController = TextEditingController();
  final _tagController = TextEditingController();
  final _specKeyController = TextEditingController();
  final _specValueController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUnit;
  bool _isOrganic = false;
  bool _isAvailable = true;
  bool _isHarvest = false;
  DateTime? _harvestDate;

  List<String> _images = [];
  List<String> _tags = [];
  List<ProductSpecificationEntity> _specifications = [];

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProductDetails();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _longDescController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minOrderController.dispose();
    _maxOrderController.dispose();
    _targetAmountController.dispose();
    _imageUrlController.dispose();
    _tagController.dispose();
    _specKeyController.dispose();
    _specValueController.dispose();
    super.dispose();
  }

  Future<void> _loadProductDetails() async {
    setState(() => _isLoading = true);
    final result = await ref
        .read(getFarmerProductDetailUseCaseProvider)
        .call(widget.productId!);
    result.fold((failure) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
      setState(() => _isLoading = false);
    }, (product) {
      _product = product;
      _nameController.text = product.name;
      _descController.text = product.description;
      _longDescController.text = product.longDescription;
      _priceController.text = product.price.toString();
      _selectedUnit = product.unit;
      _stockController.text = product.stock.toString();
      _minOrderController.text = product.minimumOrder.toString();
      _maxOrderController.text = product.maximumOrder.toString();
      _targetAmountController.text = product.targetAmount?.toString() ?? '';
      _selectedCategory = product.categoryId;
      _isOrganic = product.isOrganic;
      _isAvailable = product.isAvailable;
      _isHarvest = product.isHarvest;
      _harvestDate = product.harvestDate;
      _images = product.images.map((e) => e.url).toList();
      _tags = List.from(product.tags);
      _specifications = List.from(product.specifications);

      setState(() => _isLoading = false);
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final request = ProductRequest(
      name: _nameController.text,
      description: _descController.text,
      longDescription: _longDescController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      unit: _selectedUnit ?? '',
      stock: int.tryParse(_stockController.text) ?? 0,
      minimumOrder: int.tryParse(_minOrderController.text) ?? 1,
      maximumOrder: int.tryParse(_maxOrderController.text) ?? 10,
      isOrganic: _isOrganic,
      isAvailable: _isAvailable,
      isHarvest: _isHarvest,
      targetAmount: double.tryParse(_targetAmountController.text),
      harvestDate: _harvestDate,
      categoryId: _selectedCategory,
      images: _images
          .asMap()
          .entries
          .map((e) => ProductImageEntity(url: e.value, isPrimary: e.key == 0))
          .toList(),
      tags: _tags,
      specifications: _specifications,
    );

    if (widget.productId == null) {
      final result =
          await ref.read(createFarmerProductUseCaseProvider).call(request);
      result.fold((failure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failure.message)));
        setState(() => _isLoading = false);
      }, (product) {
        ref.read(farmerProductsControllerProvider.notifier).refresh();
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully')));
      });
    } else {
      final result = await ref
          .read(updateFarmerProductUseCaseProvider)
          .call(widget.productId!, request);
      result.fold((failure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failure.message)));
        setState(() => _isLoading = false);
      }, (product) {
        ref.read(farmerProductsControllerProvider.notifier).refresh();
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(allCategoriesProvider);
    final unitsAsyncValue = ref.watch(allUnitsProvider);
    final isEditing = widget.productId != null;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: kDarkGreen),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.productId == null ? 'Add Product' : 'Edit Product',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: kDarkGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ) ??
              TextStyle(
                color: kDarkGreen,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: kDarkGreen))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagesInput(),
                      const SizedBox(height: 24),
                      _buildLabel('Product Name'),
                      _buildTextField(
                          _nameController, 'e.g., Organic Tomatoes'),
                      const SizedBox(height: 20),
                      _buildLabel('Category'),
                      categoriesAsyncValue.when(
                        data: (categories) =>
                            _buildCategoryDropdown(categories),
                        loading: () => const CircularProgressIndicator(),
                        error: (e, s) => Text('Error loading categories: $e'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Price (Rp)'),
                                _buildTextField(_priceController, '0.00',
                                    isNumber: true),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Unit (e.g., kg, bunch)'),
                                unitsAsyncValue.when(
                                  data: (units) => _buildUnitDropdown(units),
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                  error: (e, s) =>
                                      Text('Error loading units: $e'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Stock (Available Quantity)'),
                      _buildTextField(_stockController, 'e.g., 50',
                          isNumber: true),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Min Order'),
                                _buildTextField(_minOrderController, '1',
                                    isNumber: true),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Max Order'),
                                _buildTextField(_maxOrderController, '10',
                                    isNumber: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildLabel('Description'),
                      _buildTextField(
                          _descController, 'Briefly describe your product...',
                          maxLines: 2),
                      const SizedBox(height: 20),
                      _buildLabel('Long Description'),
                      _buildTextField(_longDescController,
                          'Provide a detailed description...',
                          maxLines: 4),
                      const SizedBox(height: 20),
                      SwitchListTile(
                        title: const Text('Is Organic'),
                        value: _isOrganic,
                        onChanged: (val) => setState(() => _isOrganic = val),
                        activeColor: kDarkGreen,
                      ),
                      SwitchListTile(
                        title: const Text('Is Available'),
                        value: _isAvailable,
                        onChanged: (val) => setState(() => _isAvailable = val),
                        activeColor: kDarkGreen,
                      ),
                      SwitchListTile(
                        title: const Text(
                            'Enable Harvest Mode (Pre-order with deposit)'),
                        value: _isHarvest,
                        onChanged: (val) => setState(() => _isHarvest = val),
                        activeColor: kDarkGreen,
                      ),
                      if (_isHarvest) ...[
                        const SizedBox(height: 16),
                        _buildLabel('Target Harvest Amount (pack) *'),
                        _buildTextField(_targetAmountController, 'e.g., 500',
                            isNumber: true),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Text(
                            'Orders will be capped at this amount. Customers pay 20% deposit.',
                            style: TextStyle(color: kTextGrey, fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Harvest Date'),
                        _buildDatePicker(),
                      ],
                      const SizedBox(height: 20),
                      _buildTagsInput(),
                      const SizedBox(height: 20),
                      _buildSpecificationsInput(),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            isEditing ? 'Update Product' : 'Save Product',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _harvestDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          setState(() {
            _harvestDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _harvestDate != null
                  ? DateFormat('yyyy-MM-dd').format(_harvestDate!)
                  : 'Select Date',
              style: TextStyle(
                  color: _harvestDate != null
                      ? kDarkGreen
                      : kTextGrey.withOpacity(0.5)),
            ),
            const Icon(PhosphorIconsRegular.calendar, color: kDarkGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Product Images'),
        if (_images.isEmpty)
          InkWell(
            onTap: () {
              ImagePickerBottomSheet.show(context, onImagePicked: (path) {
                setState(() {
                  _images.add(path);
                });
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: kInputBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kInputBg), // No harsh border
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(PhosphorIconsRegular.camera,
                      color: kDarkGreen, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add product images',
                    style: TextStyle(color: kTextGrey, fontSize: 13),
                  ),
                ],
              ),
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ..._images.asMap().entries.map((entry) {
                final index = entry.key;
                final url = entry.value;
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kBorderColor),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: AppCachedImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _images.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.red, size: 14),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              InkWell(
                onTap: () {
                  ImagePickerBottomSheet.show(context, onImagePicked: (path) {
                    setState(() {
                      _images.add(path);
                    });
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: kInputBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kInputBg),
                  ),
                  child: const Center(
                    child: Icon(PhosphorIconsRegular.plus, color: kDarkGreen),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTagsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Tags'),
        TextFormField(
          controller: _tagController,
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _tags.add(value);
                _tagController.clear();
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Add a tag (e.g., fresh, local) and press enter',
            hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
            filled: true,
            fillColor: kInputBg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kDarkGreen, width: 2),
            ),
            suffixIcon: IconButton(
              icon: const Icon(PhosphorIconsRegular.plusCircle,
                  color: kDarkGreen),
              onPressed: () {
                if (_tagController.text.isNotEmpty) {
                  setState(() {
                    _tags.add(_tagController.text);
                    _tagController.clear();
                  });
                }
              },
            ),
          ),
        ),
        if (_tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.asMap().entries.map((entry) {
                return Chip(
                  label: Text(entry.value),
                  labelStyle: TextStyle(color: kDarkGreen, fontSize: 13),
                  backgroundColor: kPrimaryGreen.withOpacity(0.1),
                  deleteIcon:
                      const Icon(Icons.close, size: 16, color: kDarkGreen),
                  onDeleted: () {
                    setState(() {
                      _tags.removeAt(entry.key);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide.none,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSpecificationsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Specifications'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _specKeyController,
                decoration: InputDecoration(
                  hintText: 'Attribute (e.g., Weight)',
                  hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
                  filled: true,
                  fillColor: kCardBg,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kDarkGreen, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _specValueController,
                decoration: InputDecoration(
                  hintText: 'Value (e.g., 500g)',
                  hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
                  filled: true,
                  fillColor: kCardBg,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kDarkGreen, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: kDarkGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon:
                    const Icon(PhosphorIconsRegular.plus, color: Colors.white),
                onPressed: () {
                  if (_specKeyController.text.isNotEmpty &&
                      _specValueController.text.isNotEmpty) {
                    setState(() {
                      _specifications.add(ProductSpecificationEntity(
                        key: _specKeyController.text,
                        value: _specValueController.text,
                      ));
                      _specKeyController.clear();
                      _specValueController.clear();
                    });
                  }
                },
              ),
            ),
          ],
        ),
        if (_specifications.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kInputBg), // Match others
                borderRadius: BorderRadius.circular(12),
                color: kInputBg,
              ),
              child: Column(
                children: _specifications.asMap().entries.map((entry) {
                  return ListTile(
                    title: Text(
                      entry.value.key,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    subtitle: Text(
                      entry.value.value,
                      style: TextStyle(color: kTextGrey, fontSize: 13),
                    ),
                    trailing: IconButton(
                      icon: const Icon(PhosphorIconsRegular.trash,
                          color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _specifications.removeAt(entry.key);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: kDarkGreen,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false, int maxLines = 1, bool requiredField = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      maxLines: maxLines,
      validator: (value) {
        if (requiredField && (value == null || value.isEmpty)) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kTextGrey.withOpacity(0.5)),
        filled: true,
        fillColor: kInputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDarkGreen, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(List<Category> categories) {
    if (categories.isEmpty) {
      return const Text('No categories available');
    }

    if (_selectedCategory != null &&
        !categories.any((c) => c.id == _selectedCategory)) {
      _selectedCategory = null;
    }

    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: kInputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDarkGreen, width: 2),
        ),
      ),
      items: categories.map((Category category) {
        return DropdownMenuItem(
          value: category.id,
          child: Text(
            category.name,
            style: TextStyle(color: kDarkGreen),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedCategory = newValue;
          });
        }
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildUnitDropdown(List<ProductUnit> units) {
    if (units.isEmpty) {
      return const Text('No units available');
    }

    if (_selectedUnit != null && !units.any((u) => u.value == _selectedUnit)) {
      _selectedUnit = null;
    }

    return DropdownButtonFormField<String>(
      value: _selectedUnit,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: kInputBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDarkGreen, width: 2),
        ),
      ),
      items: units.map((ProductUnit unit) {
        return DropdownMenuItem(
          value: unit.value,
          child: Text(
            unit.label,
            style: TextStyle(color: kDarkGreen),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedUnit = newValue;
          });
        }
      },
      validator: (value) => value == null ? 'Please select a unit' : null,
    );
  }
}
