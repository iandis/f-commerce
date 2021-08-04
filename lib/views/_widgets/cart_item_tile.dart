import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/core/constants/app_theme.dart';
import '/core/helpers/formatters.dart';
import '/core/models/cart/cart_item.dart';
import '/views/_widgets/number_spinner.dart';

/// if [onIncrement] or [onDecrement] is null,
/// instead of showing [NumberSpinner] this will
/// show total price instead.
///
/// and if [onRemove] is null,
/// this will show item amount instead.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key? key,
    required this.cartItem,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
    this.contentPadding,
  }) : super(key: key);

  final CartItem cartItem;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding ?? EdgeInsets.zero,
      leading: itemImage,
      title: itemName,
      subtitle: itemCountCell,
      trailing: itemTrailing,
    );
  }

  Widget get itemImage {
    return Container(
      width: kMinInteractiveDimension,
      height: kMinInteractiveDimension,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: CachedNetworkImage(
        imageUrl: cartItem.product.image,
      ),
    );
  }

  Widget get itemName {
    return Text(
      cartItem.product.name,
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget get itemCountCell {
    final itemPrice = Text(Formatters.formatPrice(cartItem.totalPrice));

    final Widget boxChild;

    if (onDecrement != null && onIncrement != null) {
      boxChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 3, child: itemPrice),
          Flexible(
            flex: 2,
            child: NumberSpinner(
              value: cartItem.amount,
              lowerLimit: 1,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ),
        ],
      );
    } else {
      boxChild = itemPrice;
    }
    return boxChild;
  }

  Widget get itemTrailing {
    if (onRemove != null) {
      return IconButton(
        onPressed: onRemove,
        color: Colors.redAccent,
        icon: const Icon(Icons.delete),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7.5,
        vertical: 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppTheme.accentColor,
      ),
      child: Text('${cartItem.amount}'),
    );
  }
}
