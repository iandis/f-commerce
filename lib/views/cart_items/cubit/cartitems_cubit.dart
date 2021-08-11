import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '/core/helpers/error_handler.dart';
import '/core/models/cart/cart_item.dart';
import '/core/models/stateful_value/stateful_value.dart';
import '/core/repositories/cartitems_repo/base_cartitems_repo.dart';

part 'cartitems_state.dart';

class CartItemsCubit extends Cubit<CartItemsState> {
  final BaseCartItemsRepository _cartItemsRepo;

  CartItemsCubit({
    BaseCartItemsRepository? cartItemsRepo,
  })  : _cartItemsRepo = cartItemsRepo ?? GetIt.I<BaseCartItemsRepository>(),
        super(const CartItemsInit());

  Future<void> loadCartItems() async {
    if (state is CartItemsLoading) return;
    emit(const CartItemsLoading());
    try {
      final cartItems = await _cartItemsRepo.getCartItemList();
      final predicativeCartItems = cartItems.map((c) => PredicativeValue(value: c)).toList(growable: false);

      emit(CartItemsLoaded(predicativeCartItems));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops... Failed to load cart items :( Please try again',
        onCatch: _catchError,
      );
    }
  }

  Future<void> removeItem({
    required CartItem item,
    required int index,
  }) async {
    if (state is CartItemsModifying) return;
    if (state is! CartItemsLoaded) return;
    final currentState = state as CartItemsLoaded;
    emit(CartItemsModifying(currentState.cartItems));
    try {
      await _cartItemsRepo.deleteCartItem(item.id);

      final newCartItems = currentState.cartItems.toList()..removeAt(index);

      emit(CartItemsModified(newCartItems));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops... Failed to modify this item :( Please try again',
        onCatch: _catchError,
      );
    }
  }

  Future<void> incrementItem({
    required CartItem item,
    required int index,
  }) {
    return _modifyItemAmount(
      item: item,
      index: index,
      modifyBy: 1,
    );
  }

  Future<void> decrementItem({
    required CartItem item,
    required int index,
  }) {
    return _modifyItemAmount(
      item: item,
      index: index,
      modifyBy: -1,
    );
  }

  void toggleItem(int index) {
    if (state is! CartItemsLoaded) return;
    final currentState = state as CartItemsLoaded;
    final newCartItems = currentState.cartItems.toList(growable: false);
    final itemToToggle = newCartItems[index];
    newCartItems[index] = itemToToggle.copyWith(state: !itemToToggle.state);
    emit(CartItemsModified(newCartItems));
  }

  List<CartItem> getSelectedCartItems() {
    if (state is! CartItemsLoaded) return [];
    final currentState = state as CartItemsLoaded;
    return currentState.cartItems.where((c) => c.state).map<CartItem>((c) => c.value).toList(growable: false);
  }

  double calculateSelectedCartItemsTotalPrice() {
    if (state is! CartItemsLoaded) return 0;
    final currentState = state as CartItemsLoaded;
    return currentState.cartItems.where((c) => c.state).fold<double>(
      0,
      (currentTotal, currentItem) {
        return currentTotal += currentItem.value.totalPrice;
      },
    );
  }

  Future<void> _modifyItemAmount({
    required CartItem item,
    required int modifyBy,
    required int index,
  }) async {
    if (state is CartItemsModifying) return;
    if (state is! CartItemsLoaded) return;
    final currentState = state as CartItemsLoaded;
    emit(CartItemsModifying(currentState.cartItems));
    try {
      final newAmount = item.amount + modifyBy;
      await _cartItemsRepo.updateCartItemAmount(id: item.id, newAmount: newAmount);

      final newCartItems = currentState.cartItems.toList(growable: false);
      final itemToModify = newCartItems[index];
      newCartItems[index] = itemToModify.copyWith(value: item.copyWith(amount: newAmount));

      emit(CartItemsModified(newCartItems));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops... Failed to modify this item :( Please try again',
        onCatch: _catchError,
      );
    }
  }

  void _catchError(String errorMessage) {
    emit(CartItemsError(errorMessage));
  }
}
