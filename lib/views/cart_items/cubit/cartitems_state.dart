part of 'cartitems_cubit.dart';

abstract class CartItemsState extends Equatable {
  const CartItemsState();

  @override
  List<Object> get props => [];
}

class CartItemsInit extends CartItemsState {
  const CartItemsInit();
}

class CartItemsLoading extends CartItemsState {
  const CartItemsLoading();
}


class CartItemsLoaded extends CartItemsState {
  const CartItemsLoaded(this.cartItems);
  
  final List<PredicativeValue<CartItem>> cartItems;
  
  @override
  List<Object> get props => [cartItems];
}

class CartItemsModifying extends CartItemsLoaded {
  const CartItemsModifying(List<PredicativeValue<CartItem>> cartItems) : super(cartItems);
} 

class CartItemsModified extends CartItemsLoaded {
  const CartItemsModified(List<PredicativeValue<CartItem>> cartItems) : super(cartItems);
}

class CartItemsError extends CartItemsState {
  const CartItemsError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}