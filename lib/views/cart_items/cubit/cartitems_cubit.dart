import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '/core/helpers/error_handler.dart';
import '/core/models/cart/cart_item.dart';
import '/core/repositories/cartitems_repo/base_cartitems_repo.dart';

part 'cartitems_state.dart';

class CartItemsCubit extends Cubit<CartItemsState> {
  final BaseCartItemsRepository _cartItemsRepo;

  CartItemsCubit({BaseCartItemsRepository? cartItemsRepo})
      : _cartItemsRepo = cartItemsRepo ?? GetIt.I<BaseCartItemsRepository>(),
        super(const CartItemsInit());

  void _catchError(String errorMessage) {
    emit(CartItemsError(errorMessage));
  }

  Future<void> loadCartItems() async {
    if (state is CartItemsLoading) return;
    emit(const CartItemsLoading());
    try {
      final cartItems = await _cartItemsRepo.getCartItemList();
      emit(CartItemsLoaded(cartItems));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops... Failed to load cart items :( Please try again',
        onCatch: _catchError,
      );
    }
  }

  Future<void> removeItem(CartItem item) async {
    if (state is CartItemsModifying) return;
    if (state is! CartItemsLoaded) return;
    final currentState = state as CartItemsLoaded;
    emit(CartItemsModifying(currentState.cartItems));
    try{
      await _cartItemsRepo.deleteCartItem(item.id);
      final cartItems = await _cartItemsRepo.getCartItemList();
      emit(CartItemsModified(cartItems));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops... Failed to modify this item :( Please try again',
        onCatch: _catchError,
      );
    }
  }

  Future<void> _modifyItemAmount(CartItem item, int modifyBy) async {
    if (state is CartItemsModifying) return;
    if (state is! CartItemsLoaded) return;
    final currentState = state as CartItemsLoaded;
    emit(CartItemsModifying(currentState.cartItems));
    try {
      await _cartItemsRepo.updateCartItemAmount(id: item.id, newAmount: item.amount + modifyBy);
      final cartItems = await _cartItemsRepo.getCartItemList();
      emit(CartItemsModified(cartItems));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops... Failed to modify this item :( Please try again',
        onCatch: _catchError,
      );
    }
  }

  Future<void> incrementItem(CartItem item) {
    return _modifyItemAmount(item, 1);
  }
  Future<void> decrementItem(CartItem item) {
    return _modifyItemAmount(item, -1);
  }
}
