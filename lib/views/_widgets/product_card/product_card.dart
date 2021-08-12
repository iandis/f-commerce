import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 10,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                ),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: product.image,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Formatters.formatPrice(product.price),
                      style: const TextStyle(fontFamily: 'Lato'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onAddToCartPressed,
                child: const Text('Add to cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
