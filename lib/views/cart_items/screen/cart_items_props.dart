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

  void _selectCartItem(int index) {
    final newSelectedCartItems = _selectedCartItems.value.toSet();
    if (_selectedCartItems.value.contains(index)) {
      newSelectedCartItems.remove(index);
      _selectedCartItems.value = newSelectedCartItems;
    } else {
      newSelectedCartItems.add(index);
      _selectedCartItems.value = newSelectedCartItems;
    }
  }

  void _gotoConfirmationPage() {
    if (_cartItemsCubit.state is! CartItemsLoaded) return;
    final currentState = _cartItemsCubit.state as CartItemsLoaded;
    final selectedCartItems = _selectedCartItems.value.map<CartItem>((index) {
      return currentState.cartItems[index];
    }).toList();
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
