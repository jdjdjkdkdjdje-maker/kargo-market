/// Buyurtmadagi mahsulot (buyurtma vaqtidagi "surat" — keyingi
/// o'zgarishlar tarixga ta'sir qilmasligi uchun nusxa saqlanadi).
class OrderItem {
  final String productId;
  final String name;
  final String image;
  final int price;
  final int oldPrice;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.quantity,
  });

  int get total => price * quantity;

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'name': name,
        'image': image,
        'price': price,
        'oldPrice': oldPrice,
        'quantity': quantity,
      };

  factory OrderItem.fromMap(Map<dynamic, dynamic> map) => OrderItem(
        productId: map['productId'] as String,
        name: map['name'] as String,
        image: map['image'] as String,
        price: (map['price'] as num).toInt(),
        oldPrice: (map['oldPrice'] as num?)?.toInt() ?? (map['price'] as num).toInt(),
        quantity: (map['quantity'] as num).toInt(),
      );
}
