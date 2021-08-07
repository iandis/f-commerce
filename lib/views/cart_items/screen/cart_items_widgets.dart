part of '_cart_items_screen.dart';

mixin _CartItemsWidgets on _CartItemsProps {
  Widget cartItemsList(CartItemsLoaded state) {
    return Container(
      color: widget.backgroundColor,
      margin: const EdgeInsets.only(bottom: 56),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (_, index) {
          final currentItem = state.cartItems[index];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: VLB<Set<int>>(
                  valueListenable: _selectedCartItems,
                  builder: (_, selectedItems, __) => Checkbox(
                    value: selectedItems.contains(currentItem.id),
                    onChanged: (_) => _selectCartItem(currentItem),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: CartItemTile(
                  cartItem: currentItem,
                  onIncrement: () => _cartItemsCubit.incrementItem(currentItem),
                  onDecrement: () => _cartItemsCubit.decrementItem(currentItem),
                  onRemove: () => _removeCartItem(currentItem),
                ),
              ),
            ],
          );
        },
        itemCount: state.cartItems.length,
      ),
    );
  }

  Widget get cartItemsEmpty {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.shopping_bag_outlined,
            color: AppTheme.accentColor,
            size: 60,
          ),
          SizedBox(height: 10),
          Text(
            "Oops... You haven't added any item yet :(",
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget totalPriceCell(CartItemsLoaded state) {
    return VLB<Set<int>>(
      valueListenable: _selectedCartItems,
      builder: (_, selectedItems, __) {
        final totalPrice = state.cartItems.where((c) => selectedItems.contains(c.id)).fold<double>(
          0,
          (total, item) {
            return total += item.totalPrice;
          },
        );
        return ListTile(
          leading: const Text('Total'),
          title: Text(
            Formatters.formatPrice(totalPrice),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: ElevatedButton(
            onPressed: totalPrice > 0 ? _gotoConfirmationPage : null,
            child: const Text('Checkout'),
          ),
        );
      },
    );
  }
}
