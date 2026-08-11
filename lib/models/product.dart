/// Mahsulot modeli.
class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final int oldPrice;
  final String description;
  final String image;
  final double rating;
  final int stock;
  final bool isNew;
  final bool isPopular;
  final List<String> features;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.oldPrice,
    required this.description,
    required this.image,
    required this.rating,
    required this.stock,
    this.isNew = false,
    this.isPopular = false,
    this.features = const [],
  });

  bool get hasDiscount => oldPrice > price;

  int get discountPercent {
    if (!hasDiscount) return 0;
    return ((oldPrice - price) / oldPrice * 100).round();
  }

  bool get inStock => stock > 0;

  Product copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    int? oldPrice,
    String? description,
    String? image,
    double? rating,
    int? stock,
    bool? isNew,
    bool? isPopular,
    List<String>? features,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      isNew: isNew ?? this.isNew,
      isPopular: isPopular ?? this.isPopular,
      features: features ?? this.features,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'price': price,
        'oldPrice': oldPrice,
        'description': description,
        'image': image,
        'rating': rating,
        'stock': stock,
        'isNew': isNew,
        'isPopular': isPopular,
        'features': features,
      };

  factory Product.fromMap(Map<dynamic, dynamic> map) => Product(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        price: (map['price'] as num).toInt(),
        oldPrice: (map['oldPrice'] as num?)?.toInt() ?? (map['price'] as num).toInt(),
        description: map['description'] as String? ?? '',
        image: map['image'] as String,
        rating: (map['rating'] as num?)?.toDouble() ?? 0,
        stock: (map['stock'] as num?)?.toInt() ?? 0,
        isNew: map['isNew'] as bool? ?? false,
        isPopular: map['isPopular'] as bool? ?? false,
        features: (map['features'] as List?)?.cast<String>() ?? const [],
      );
}
