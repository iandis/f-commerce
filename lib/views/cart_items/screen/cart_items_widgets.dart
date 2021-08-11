part of '_cart_items_screen.dart';

mixin _CartItemsWidgets on _CartItemsProps {
  Widget get cartItemsList {
    final state = _cartItemsCubit.state as CartItemsLoaded;
    return Container(
      color: widget.backgroundColor,
      margin: const EdgeInsets.only(bottom: 56),
      child: AnimatedList(
        key: _cartItemListKey,
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (_, index, __) {
          final currentItem = state.cartItems[index];
          return StatefulCartItemTile(
            currentItem: currentItem,
            onStateChanged: (_) => _cartItemsCubit.toggleItem(index),
            onIncrement: () => _cartItemsCubit.incrementItem(
              item: currentItem.value,
              index: index,
            ),
            onDecrement: () => _cartItemsCubit.decrementItem(
              item: currentItem.value,
              index: index,
            ),
            onRemove: () => _removeItem(
              item: currentItem,
              index: index,
            ),
          );
        },
        initialItemCount: state.cartItems.length,
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
            size: 60,
          ),
          SizedBox(height: 10),
          Text(
            "Oops... You haven't added any item yet :(",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget get totalPriceCell {
    final currentTotalPrice = _cartItemsCubit.calculateSelectedCartItemsTotalPrice();
    return ListTile(
      leading: const Text('Total'),
      title: Text(
        Formatters.formatPrice(currentTotalPrice),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: ElevatedButton(
        onPressed: currentTotalPrice > 0 ? _gotoConfirmationPage : null,
        child: const Text('Checkout'),
      ),
    );
  }
}
