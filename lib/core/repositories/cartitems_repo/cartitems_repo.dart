import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:rxdart/subjects.dart';

import '/core/models/cart/cart_item.dart';
import '/core/services/localdb_service/base_localdb_service.dart';

import 'base_cartitems_repo.dart';

class CartItemsRepository implements BaseCartItemsRepository {

  CartItemsRepository({
    BaseLocalDbService? localDbService,
    BehaviorSubject<int>? cartItemController,
  })  : _localDbService = localDbService ?? GetIt.I<BaseLocalDbService>(),
        cartItemCountController = cartItemController ?? BehaviorSubject<int>();

  @override
  final BehaviorSubject<int> cartItemCountController;

  final BaseLocalDbService _localDbService;

  @override
  Future<int> getCartItemsCount() async {
    final favCount = await _localDbService.select(
      table: _localDbService.cartItemsTable,
      columns: ['COUNT(*)'],
    );
    return Sqflite.firstIntValue(favCount) ?? 0;
  }

  @override
  Future<int> getCartItemCount(int id) async {
    final cartItemCount = await _localDbService.select(
      table: _localDbService.cartItemsTable,
      columns: ['amount'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return (cartItemCount.first['amount'] as int?) ?? 0;
  }

  @override
  Future<void> close() async {
    await cartItemCountController.sink.close();
  }

  @override
  Future<List<CartItem>> getCartItemList() async {
    final cartItemList = await _localDbService.select(
      table: _localDbService.cartItemsTable,
    );

    return cartItemList
        .map(
          (cartItem) => CartItem.fromMap(
            cartItem,
            fromLocalDb: true,
          ),
        )
        .toList();
  }

  @override
  Future<void> insertCartItem(CartItem cartItem) async {
    await _localDbService.insert(
      table: _localDbService.cartItemsTable,
      values: cartItem.toMap(toLocalDb: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    getCartItemsCount().then(cartItemCountController.add);
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteCartItems(List<int> ids) async {
    await _localDbService.batch((batch) {
      for (final int id in ids) {
        batch.delete(
          _localDbService.cartItemsTable,
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    });
    getCartItemsCount().then(cartItemCountController.add);
  }

  @override
  Future<void> deleteCartItem(int id) async {
    await _localDbService.delete(
      table: _localDbService.cartItemsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    getCartItemsCount().then(cartItemCountController.add);
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
