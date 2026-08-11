import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../models/product.dart';
import '../../providers/app_providers.dart';
import '../../routes/app_routes.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/skeleton.dart';

/// Qidiruv sahifasi — faqat lokal ma'lumotlar orasidan qidiradi.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  String? _categoryFilter;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 42,
          margin: const EdgeInsets.only(right: 12),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: (value) => setState(() => _query = value.trim()),
            decoration: InputDecoration(
              hintText: 'Telefon, naushnik, televizor...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: productsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(16),
          children: List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: const ProductCardSkeleton(),
            ),
          ),
        ),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Xatolik yuz berdi',
          subtitle: e.toString(),
        ),
        data: (products) {
          // Kategoriya filtri (chiplar)
          final categories = _buildCategoryList(products);
          var results = searchProducts(products, _query);
          if (_categoryFilter != null) {
            results = results
                .where((p) => p.category == _categoryFilter)
                .toList();
          }

          return Column(
            children: [
              if (categories.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'Barchasi',
                        selected: _categoryFilter == null,
                        onTap: () => setState(() => _categoryFilter = null),
                      ),
                      const SizedBox(width: 8),
                      for (final category in categories) ...[
                        _FilterChip(
                          label: category,
                          selected: _categoryFilter == category,
                          onTap: () => setState(() => _categoryFilter = category),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Expanded(
                child: _query.isEmpty && _categoryFilter == null
                    ? _Suggestions(
                        products: products,
                        onQuery: (q) {
                          _controller.text = q;
                          setState(() => _query = q);
                        },
                      )
                    : results.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'Hech narsa topilmadi',
                            subtitle: 'Boshqa so\'z bilan qidirib ko\'ring',
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${results.length} ta natija',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white54
                                          : AppColors.textGrey,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ProductGrid(products: results),
                              ),
                            ],
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<String> _buildCategoryList(List<Product> products) {
    final seen = <String>{};
    final result = <String>[];
    for (final p in products) {
      if (seen.add(p.category)) result.add(p.category);
    }
    return result;
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF163026)
                    : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.white12
                      : const Color(0xFFDDE7E1),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mashhur qidiruv so'zlari takliflari.
class _Suggestions extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<String> onQuery;

  const _Suggestions({required this.products, required this.onQuery});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Telefon',
      'Naushnik',
      'Televizor',
      'Kompyuter',
      'Klaviatura',
      'Sovutgich',
      'Velosiped',
      'Krossovka',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Ommabop qidiruvlar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions
              .map(
                (s) => ActionChip(
                  label: Text(s),
                  avatar: const Icon(Icons.search_rounded, size: 15),
                  onPressed: () => onQuery(s),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
        if (products.isNotEmpty) ...[
          Text(
            'Eng ko\'p ko\'rilgan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          ...products.take(4).map(
                (p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      p.image,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => AppRoutes.toProductDetail(context, p.id),
                ),
              ),
        ],
      ],
    );
  }
}
