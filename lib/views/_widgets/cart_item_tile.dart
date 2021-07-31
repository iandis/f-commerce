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
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;
  final EdgeInsetsGeometry? contentPadding;
  const CartItemTile({
    Key? key,
    required this.cartItem,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
    this.contentPadding,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: contentPadding ?? EdgeInsets.zero,
      minLeadingWidth: kMinInteractiveDimension,
      leading: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: CachedNetworkImage(imageUrl: cartItem.product.image),
      ),
      title: Text(cartItem.product.name),
      subtitle: itemCountCell,
      trailing: onRemove != null
          ? IconButton(
              onPressed: onRemove,
              color: Colors.redAccent,
              icon: const Icon(Icons.delete),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7.5,
                vertical: 2.5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppTheme.accentColor,
              ),
              child: Text('${cartItem.amount}'),
            ),
    );
  }

  Widget get itemCountCell {
    final Widget boxChild;
    if (onDecrement != null && onIncrement != null) {
      boxChild = NumberSpinner(
        value: cartItem.amount,
        lowerLimit: 1,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
      );
    } else {
      boxChild = Text('Total: ${Formatters.formatPrice(cartItem.totalPrice)}');
    }
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: 0.5,
      child: boxChild,
    );
  }
}
