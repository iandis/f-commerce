import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '/core/models/cart/cart_item.dart';
import '/core/services/localdb_service/base_localdb_service.dart';

import 'base_cartitems_repo.dart';

class CartItemsRepository implements BaseCartItemsRepository {
  final BaseLocalDbService _localDbService;
  final StreamController<int> _cartItemCountController;

  CartItemsRepository({
    required BaseLocalDbService localDbService,
    StreamController<int>? cartItemController,
  })  : _localDbService = localDbService,
        _cartItemCountController = cartItemController ?? StreamController();

  @override
  StreamController<int> get cartItemCountController => _cartItemCountController;

  @override
  Future<int> getCartItemCount() async {
    final favCount = await _localDbService.select(
      table: _localDbService.cartItemsTable,
      columns: ['COUNT(*)'],
    );
    return Sqflite.firstIntValue(favCount) ?? 0;
  }

  @override
  Future<void> close() async {
    await _cartItemCountController.sink.close();
  }

  @override
  Future<List<CartItem>> getCartItemList() async {
    final cartItemList = await _localDbService.select(
      table: _localDbService.cartItemsTable,
    );

    return List<CartItem>.from(
      cartItemList.map(
        (cartItem) => CartItem.fromMap(
          cartItem,
          fromLocalDb: true,
        ),
      ),
    );
  }

  @override
  Future<void> insertCartItem(CartItem cartItem) async {
    await _localDbService.insert(
      table: _localDbService.cartItemsTable,
      values: cartItem.toMap(toLocalDb: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    getCartItemCount().then(_cartItemCountController.add);
  }

  @override
  Future<void> updateCartItemAmount({
    required int id,
    required int newAmount,
  }) async {
    await _localDbService.update(
      table: _localDbService.cartItemsTable,
      values: {
        'amount': newAmount,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteCartItem(int id) async {
    await _localDbService.delete(
      table: _localDbService.cartItemsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    getCartItemCount().then(_cartItemCountController.add);
  }

  @override
  Future<bool> isInCartItem(int id) async {
    final findCartItem = await _localDbService.select(
      table: _localDbService.cartItemsTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (findCartItem.isEmpty) return false;
    return true;
  }
}
