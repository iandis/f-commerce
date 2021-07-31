import 'package:flutter/foundation.dart' show listEquals;
import 'package:intl/intl.dart';

import '/core/helpers/random_generator_helper.dart';
import 'cart_item.dart';

final DateFormat _dateFormatter = DateFormat('yyyyMMdd');

class CheckoutItems {
  const CheckoutItems({
    required this.cartItems,
    required this.destination,
    required this.invoiceId,
  });

  final List<CartItem> cartItems;
  final String destination;
  final String invoiceId;

  double get totalCheckoutPrice {
    return cartItems.fold<double>(
      0,
      (currentTotalPrice, currentCartItem) {
        return currentTotalPrice += currentCartItem.totalPrice;
      },
    );
  }

  CheckoutItems copyWith({
    List<CartItem>? cartItems,
    String? destination,
    String? invoiceId,
  }) {
    return CheckoutItems(
      cartItems: cartItems ?? this.cartItems,
      destination: destination ?? this.destination,
      invoiceId: invoiceId ?? this.invoiceId,
    );
  }

  factory CheckoutItems.withRandomInvoiceId({
    required List<CartItem> cartItems,
    required String destination,
  }) {
    final currentDate = _dateFormatter.format(DateTime.now());
    final random6alphanumeric = RandomGenHelper.generateAlphanumeric(6).toUpperCase();
    final randomInvoiceId = 'INVOICE/$currentDate/DEKORNATA/$random6alphanumeric';
    return CheckoutItems(
      cartItems: cartItems,
      destination: destination,
      invoiceId: randomInvoiceId,
    );
  }

  @override
  String toString() => 'CheckoutItems(cartItems: $cartItems, destination: $destination, invoiceId: $invoiceId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckoutItems &&
      listEquals(other.cartItems, cartItems) &&
      other.destination == destination &&
      other.invoiceId == invoiceId;
  }

  @override
  int get hashCode => cartItems.hashCode ^ destination.hashCode ^ invoiceId.hashCode;
}
