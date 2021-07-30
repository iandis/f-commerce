import '../product/product.dart';

class CartItem {
  const CartItem({
    required this.id,
    required this.product,
    required this.amount,
  });

  final int id;
  final Product product;
  final int amount;

  double get totalPrice => amount * product.price;

  factory CartItem.fromProduct({
    required Product product,
    required int amount,
  }) {
    return CartItem(
      id: product.id,
      product: product,
      amount: amount,
    );
  }

  CartItem copyWith({
    int? id,
    Product? product,
    int? amount,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap({bool toLocalDb = false}) {
    return {
      'id': id,
      'product': toLocalDb ? product.toJson() : product.toMap(),
      'amount': amount,
    };
  }

  factory CartItem.fromMap(
    Map<String, dynamic> map, {
    bool fromLocalDb = false,
  }) {
    final product =
        fromLocalDb ? Product.fromJson(map['product'] as String) : Product.fromMap(map['product'] as Map<String, dynamic>);

    return CartItem(
      id: map['id'] as int,
      product: product,
      amount: map['amount'] as int,
    );
  }

  @override
  String toString() => 'CartItem(id: $id, product: $product, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem && other.id == id && other.product == product && other.amount == amount;
  }

  @override
  int get hashCode => id.hashCode ^ product.hashCode ^ amount.hashCode;
}
