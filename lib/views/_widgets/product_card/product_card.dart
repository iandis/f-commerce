import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/core/constants/app_theme.dart';
import '/core/helpers/formatters.dart';
import '/core/models/product/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onPressed;
  final VoidCallback? onAddToCartPressed;

  const ProductCard({
    required this.product,
    required this.onPressed,
    this.onAddToCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.grey[50]?.withOpacity(0.3),
        elevation: 4.0,
        primary: Colors.grey[50],
        onPrimary: Colors.black87,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              color: Colors.grey[200],
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: product.image,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    Formatters.formatPrice(product.price),
                    style: TextStyle(
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onAddToCartPressed,
              style: ElevatedButton.styleFrom(
                primary: AppTheme.secondaryColor,
                fixedSize: Size(
                  MediaQuery.of(context).size.width / 2,
                  MediaQuery.of(context).size.height / 3,
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: const BeveledRectangleBorder(),
              ),
              child: const Text('Add to cart'),
            ),
          ),
        ],
      ),
    );
  }
}
