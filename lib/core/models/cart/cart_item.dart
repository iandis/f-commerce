import '../product/product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.amount,
  });

  final Product product;
  final int amount;

  double get totalPrice => amount * product.price;

  CartItem copyWith({
    Product? product,
    int? amount,
  }) {
    return CartItem(
      product: product ?? this.product,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap({bool toLocalDb = false}) {
    return {
      'product': toLocalDb ? product.toJson() : product.toMap(),
      'amount': amount,
    };
  }

  factory CartItem.fromMap(
    Map<String, dynamic> map, {
    bool fromLocalDb = false,
  }) {
    final product = fromLocalDb
        ? Product.fromJson(map['product'] as String)
        : Product.fromMap(map['product'] as Map<String, dynamic>);
        
    return CartItem(
      product: product,
      amount: map['amount'] as int,
    );
  }

  @override
  String toString() => 'CartItem(product: $product, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
      other.product == product &&
      other.amount == amount;
  }

  @override
  int get hashCode => product.hashCode ^ amount.hashCode;
}
