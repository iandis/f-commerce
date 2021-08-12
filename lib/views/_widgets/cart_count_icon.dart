import 'package:flutter/material.dart';

class CartCountIcon extends StatelessWidget {
  const CartCountIcon({
    Key? key,
    required this.onTap,
    required this.cartCountStream,
  }) : super(key: key);

  final VoidCallback onTap;
  final Stream<int> cartCountStream;

  @override
  Widget build(BuildContext context) {
    final circleBadgeDecoration = BoxDecoration(
      color: Theme.of(context).accentColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          spreadRadius: 0.2,
        ),
      ],
    );

    final countBadge = StreamBuilder<int>(
      initialData: 0,
      stream: cartCountStream,
      builder: (_, countSnapshot) {
        final countText = Text(
          countSnapshot.data.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        );

        return Positioned(
          right: 0.4,
          bottom: 0.4,
          child: Container(
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(
              minHeight: 12,
              minWidth: 13,
            ),
            decoration: circleBadgeDecoration,
            child: countText,
          ),
        );
      },
    );

    const shoppingCartShadow = Positioned(
      top: 1.0,
      right: 1.0,
      child: Icon(
        Icons.shopping_cart,
        color: Colors.black12,
      ),
    );

    return IconButton(
      onPressed: onTap,
      padding: const EdgeInsets.all(4),
      iconSize: 27,
      icon: Stack(
        children: [
          shoppingCartShadow,
          const Icon(Icons.shopping_cart),
          countBadge,
        ],
      ),
    );
  }
}
