import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../models/product.dart';
import '../../providers/app_providers.dart';
import '../../services/snackbar_service.dart';

/// Mahsulot qo'shish / tahrirlash formasi.
class ProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;

  const ProductFormScreen({super.key, this.productId});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _oldPriceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ratingController;
  late final TextEditingController _stockController;
  late final TextEditingController _featuresController;

  String _category = AppCategories.all.first.name;
  String _image = 'assets/products/p01.jpg';
  bool _isNew = false;
  bool _isPopular = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _oldPriceController = TextEditingController();
    _descriptionController = TextEditingController();
    _ratingController = TextEditingController();
    _stockController = TextEditingController();
    _featuresController = TextEditingController();

    if (widget.productId != null) {
      final product = ref.read(productByIdProvider(widget.productId!));
      if (product != null) {
        _isEditing = true;
        _nameController.text = product.name;
        _priceController.text = '${product.price}';
        _oldPriceController.text = product.oldPrice > product.price
            ? '${product.oldPrice}'
            : '';
        _descriptionController.text = product.description;
        _ratingController.text = product.rating.toStringAsFixed(1);
        _stockController.text = '${product.stock}';
        _featuresController.text = product.features.join('\n');
        _category = product.category;
        _image = product.image;
        _isNew = product.isNew;
        _isPopular = product.isPopular;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _oldPriceController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _stockController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      SnackbarService.error('Formani to\'g\'ri to\'ldiring');
      return;
    }

    final price = int.parse(_priceController.text.trim());
    final oldPriceText = _oldPriceController.text.trim();
    final oldPrice = oldPriceText.isEmpty
        ? price
        : int.parse(oldPriceText);

    final features = _featuresController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (_isEditing) {
      final existing = ref.read(productByIdProvider(widget.productId!));
      if (existing != null) {
        await ref.read(productsProvider.notifier).updateProduct(existing.copyWith(
              name: _nameController.text.trim(),
              category: _category,
              price: price,
              oldPrice: oldPrice,
              description: _descriptionController.text.trim(),
              image: _image,
              rating: double.parse(_ratingController.text.trim().replaceAll(',', '.')),
              stock: int.parse(_stockController.text.trim()),
              isNew: _isNew,
              isPopular: _isPopular,
              features: features,
            ));
        SnackbarService.success('Mahsulot yangilandi');
      }
    } else {
      final id = 'p${DateTime.now().millisecondsSinceEpoch}';
      await ref.read(productsProvider.notifier).addProduct(Product(
            id: id,
            name: _nameController.text.trim(),
            category: _category,
            price: price,
            oldPrice: oldPrice,
            description: _descriptionController.text.trim(),
            image: _image,
            rating: double.parse(_ratingController.text.trim().replaceAll(',', '.')),
            stock: int.parse(_stockController.text.trim()),
            isNew: _isNew,
            isPopular: _isPopular,
            features: features,
          ));
      SnackbarService.success('Mahsulot qo\'shildi');
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Mahsulotni tahrirlash' : 'Yangi mahsulot'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text(
              'Saqlash',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------- Rasm tanlash ----------
            Text(
              'Mahsulot rasmi',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 92,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF12241C) : Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListView(
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                children: [
                  for (var i = 1; i <= 44; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _image = 'assets/products/p${i.toString().padLeft(2, '0')}.jpg';
                          });
                        },
                        child: Container(
                          width: 74,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _image ==
                                      'assets/products/p${i.toString().padLeft(2, '0')}.jpg'
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/products/p${i.toString().padLeft(2, '0')}.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: isDark
                                    ? const Color(0xFF1B3328)
                                    : const Color(0xFFEDF2EF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ---------- Asosiy maydonlar ----------
            TextFormField(
              controller: _nameController,
              validator: (v) => Validators.requiredText(v, 'Mahsulot nomini kiriting'),
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Mahsulot nomi',
                hintText: 'Masalan: Aqlli telefon Nova X10',
                prefixIcon: Icon(Icons.inventory_2_outlined, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            // Kategoriya
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Kategoriya',
                prefixIcon: Icon(Icons.category_outlined, size: 20),
              ),
              items: AppCategories.all
                  .map((c) => DropdownMenuItem(value: c.name, child: Text(c.name)))
                  .toList(),
              onChanged: (v) {
                if (v != null) setState(() => _category = v);
              },
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    validator: (v) =>
                        Validators.positiveNumber(v, 'Narxni kiriting'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Narx (so\'m)',
                      prefixIcon: Icon(Icons.payments_outlined, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _oldPriceController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Eski narx (ixtiyoriy)',
                      prefixIcon: Icon(Icons.percent_rounded, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ratingController,
                    validator: Validators.rating,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Reyting (0–5)',
                      prefixIcon: Icon(Icons.star_rounded, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    validator: (v) =>
                        Validators.positiveNumber(v, 'Soni kiriting'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Ombordagi soni',
                      prefixIcon: Icon(Icons.warehouse_outlined, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              validator: (v) => Validators.requiredText(v, 'Tavsifni kiriting'),
              maxLines: 3,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                labelText: 'Tavsif',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _featuresController,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                labelText: 'Xususiyatlar (har biri yangi qatorda)',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.checklist_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            // ---------- Belgilar ----------
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF12241C) : Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _isNew,
                    onChanged: (v) => setState(() => _isNew = v),
                    title: const Text('Yangi mahsulot'),
                    subtitle: const Text('Bosh sahifadagi "Yangi" bo\'limida ko\'rsatiladi'),
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _isPopular,
                    onChanged: (v) => setState(() => _isPopular = v),
                    title: const Text('Mashhur mahsulot'),
                    subtitle: const Text('Bosh sahifadagi "Mashhur" bo\'limida ko\'rsatiladi'),
                    activeColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_outlined, size: 20),
                label: Text(_isEditing ? 'O\'zgarishlarni saqlash' : 'Mahsulotni qo\'shish'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
