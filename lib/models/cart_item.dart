/// Savatchadagi mahsulot (mahsulot id + miqdor).
class CartItem {
  final String productId;
  int quantity;

  CartItem({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'quantity': quantity,
      };

  factory CartItem.fromMap(Map<dynamic, dynamic> map) => CartItem(
        productId: map['productId'] as String,
        quantity: (map['quantity'] as num).toInt(),
      );
}
