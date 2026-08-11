/// Savatcha yakuniy hisob-kitobi.
class CartSummary {
  final int itemsCount;
  final int productsTotal;
  final int discount;
  final int deliveryFee;
  final int total;

  const CartSummary({
    required this.itemsCount,
    required this.productsTotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
  });
}
