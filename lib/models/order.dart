import 'order_item.dart';

/// Buyurtma modeli — faqat telefon xotirasida saqlanadi.
class Order {
  final String id;
  final DateTime createdAt;
  final List<OrderItem> items;
  final int productsTotal;
  final int discount;
  final int deliveryFee;
  final int total;
  final String customerName;
  final String phone;
  final String address;
  final String comment;
  final String paymentMethod;
  String status;
  DateTime? statusUpdatedAt;

  Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.productsTotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.customerName,
    required this.phone,
    required this.address,
    this.comment = '',
    required this.paymentMethod,
    required this.status,
    this.statusUpdatedAt,
  });

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt,
        'items': items.map((e) => e.toMap()).toList(),
        'productsTotal': productsTotal,
        'discount': discount,
        'deliveryFee': deliveryFee,
        'total': total,
        'customerName': customerName,
        'phone': phone,
        'address': address,
        'comment': comment,
        'paymentMethod': paymentMethod,
        'status': status,
        'statusUpdatedAt': statusUpdatedAt,
      };

  factory Order.fromMap(Map<dynamic, dynamic> map) => Order(
        id: map['id'] as String,
        createdAt: map['createdAt'] as DateTime,
        items: (map['items'] as List)
            .map((e) => OrderItem.fromMap(e as Map<dynamic, dynamic>))
            .toList(),
        productsTotal: (map['productsTotal'] as num).toInt(),
        discount: (map['discount'] as num?)?.toInt() ?? 0,
        deliveryFee: (map['deliveryFee'] as num?)?.toInt() ?? 0,
        total: (map['total'] as num).toInt(),
        customerName: map['customerName'] as String,
        phone: map['phone'] as String,
        address: map['address'] as String,
        comment: map['comment'] as String? ?? '',
        paymentMethod: map['paymentMethod'] as String? ?? 'Naqd pul',
        status: map['status'] as String? ?? 'Qabul qilindi',
        statusUpdatedAt: map['statusUpdatedAt'] as DateTime?,
      );
}
