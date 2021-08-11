part of '_cart_items_screen.dart';

abstract class _CartItemsProps extends State<CartItemsScreen> {
  final _cartItemsCubit = CartItemsCubit();
  final _cartItemListKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _cartItemsCubit.loadCartItems();
  }

  @override
  void dispose() {
    _cartItemsCubit.close();
    super.dispose();
  }

  void _gotoConfirmationPage() {
    if (_cartItemsCubit.state is! CartItemsLoaded) return;
    final selectedCartItems = _cartItemsCubit.getSelectedCartItems();
    final checkoutItems = CheckoutItems.withRandomInvoiceId(
      cartItems: selectedCartItems,
      destination: '--',
    );
    Navigator.of(context).pushNamed(
      AppRoutes.confirmation,
      arguments: checkoutItems,
    );
  }

  void _removeItem({
    required PredicativeValue<CartItem> item,
    required int index,
  }) {
    
    _cartItemListKey.currentState?.removeItem(
      index,
      (_, animation) {
        const begin = Offset(1.0, 0);
        const end = Offset(0.0, 0);
        const curve = Curves.linear;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: StatefulCartItemTile(
              currentItem: item,
              onStateChanged: null,
              onRemove: () {},
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 250),
    );
    _cartItemsCubit.removeItem(
      item: item.value,
      index: index,
    );
  }
}
