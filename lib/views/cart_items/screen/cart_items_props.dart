part of '_cart_items_screen.dart';

abstract class _CartItemsProps extends State<CartItemsScreen> {
  final _cartItemsCubit = CartItemsCubit();
  final _selectedCartItems = ValueNotifier<Set<CartItem>>({});

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
    if (_selectedCartItems.value.contains(item)) {
      newSelectedCartItems.remove(item);
      _selectedCartItems.value = newSelectedCartItems;
    } else {
      newSelectedCartItems.add(item);
      _selectedCartItems.value = newSelectedCartItems;
    }
  }

  void _removeCartItem(CartItem item) {
    final newSelectedCartItems = _selectedCartItems.value.toSet();
    newSelectedCartItems.remove(item);
    _selectedCartItems.value = newSelectedCartItems;
    _cartItemsCubit.removeItem(item);
  }

  void _gotoConfirmationPage() {
    if (_cartItemsCubit.state is! CartItemsLoaded) return;
    final selectedCartItems = _selectedCartItems.value.toList();
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
