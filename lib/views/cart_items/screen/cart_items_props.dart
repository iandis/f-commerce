part of '_cart_items_screen.dart';

abstract class _CartItemsProps extends State<CartItemsScreen> {
  final _cartItemsCubit = CartItemsCubit();
  final _selectedCartItems = ValueNotifier<Set<int>>({});

  @override
  void initState() {
    super.initState();
    _cartItemsCubit.loadCartItems();
  }

  @override
  void dispose() {
    _cartItemsCubit.close();
    _selectedCartItems.dispose();
    super.dispose();
  }

  void _selectCartItem(CartItem item) {
    final newSelectedCartItems = _selectedCartItems.value.toSet();
    if (_selectedCartItems.value.contains(item.id)) {
      newSelectedCartItems.remove(item.id);
      _selectedCartItems.value = newSelectedCartItems;
    } else {
      newSelectedCartItems.add(item.id);
      _selectedCartItems.value = newSelectedCartItems;
    }
  }

  void _removeCartItem(CartItem item) {
    final newSelectedCartItems = _selectedCartItems.value.toSet();
    newSelectedCartItems.remove(item.id);
    _selectedCartItems.value = newSelectedCartItems;
    _cartItemsCubit.removeItem(item);
  }

  void _gotoConfirmationPage() {
    if (_cartItemsCubit.state is! CartItemsLoaded) return;
    final currentState = _cartItemsCubit.state as CartItemsLoaded;
    final selectedCartItems = currentState.cartItems.where((c) => _selectedCartItems.value.contains(c.id)).toList();
    final checkoutItems = CheckoutItems.withRandomInvoiceId(
      cartItems: selectedCartItems,
      destination: '--',
    );
    Navigator.of(context).pushNamed(
      AppRoutes.confirmation,
      arguments: checkoutItems,
    );
  }
}
