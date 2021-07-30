import 'dart:async';

import 'package:rxdart/subjects.dart';
import '/core/models/cart/cart_item.dart';

abstract class BaseCartItemsRepository {
  BehaviorSubject<int> get cartItemCountController;
  Future<int> getCartItemsCount();
  Future<int> getCartItemCount(int id);
  Future<List<CartItem>> getCartItemList();
  Future<void> insertCartItem(CartItem cartItem);
  Future<void> updateCartItemAmount({
    required int id,
    required int newAmount,
  });
  Future<void> deleteCartItems(List<int> ids);
  Future<void> deleteCartItem(int id);
  Future<bool> isInCartItem(int id);
  Future<void> close();
}
