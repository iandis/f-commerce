import 'dart:async';

import '/core/models/cart/cart_item.dart';

abstract class BaseCartItemsRepository {
  StreamController<int> get cartItemCountController;
  Future<int> getCartItemCount();
  Future<List<CartItem>> getCartItemList();
  Future<void> insertCartItem(CartItem cartItem);
  Future<void> updateCartItemAmount({
    required int id,
    required int newAmount,
  });
  Future<void> deleteCartItem(int id);
  Future<bool> isInCartItem(int id);
  Future<void> close();
}
