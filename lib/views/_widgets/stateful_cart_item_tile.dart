

import 'package:flutter/material.dart';

import '/core/models/cart/cart_item.dart';
import '/core/models/stateful_value/stateful_value.dart';
import 'cart_item_tile.dart';

class StatefulCartItemTile extends StatelessWidget {
  /// a [CartItemTile] with [Checkbox]
  /// 
  /// if [onIncrement] or [onDecrement] is null,
  /// instead of showing [NumberSpinner] this will
  /// show total price instead.
  ///
  /// and if [onRemove] is null,
  /// this will show item amount instead.
  const StatefulCartItemTile({
    Key? key,
    required this.currentItem,
    required this.onStateChanged,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  }) : super(key: key);

  final PredicativeValue<CartItem> currentItem;
  final void Function(bool?)? onStateChanged;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Checkbox(
            value: currentItem.state,
            onChanged: onStateChanged,
          ),
        ),
        Expanded(
          flex: 9,
          child: CartItemTile(
            cartItem: currentItem.value,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onRemove: onRemove,
          ),
        ),
      ],
    );
  }
}
