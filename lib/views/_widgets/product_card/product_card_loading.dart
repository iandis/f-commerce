import 'package:flutter/material.dart';

import '/views/_widgets/default_shimmer.dart';

final _cardShape = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
);

final _shimmeringItemDetailDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(5),
);

const _shimmeringAddToCartButton = BoxDecoration(
  color: Colors.white,
);

class ProductsLoadingIndicator extends StatelessWidget {
  final double itemExtent;
  final int itemCount;

  const ProductsLoadingIndicator({
    Key? key,
    this.itemExtent = 295,
    this.itemCount = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double halfScreenWidth = MediaQuery.of(context).size.width * 0.5;
    final double quarterScreenWidth = MediaQuery.of(context).size.width * 0.25;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: itemExtent,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, __) => _card(halfScreenWidth, quarterScreenWidth),
        childCount: itemCount,
      ),
    );
  }

  Widget _card(double halfScreenWidth, double quarterScreenWidth) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: _cardShape,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: DefaultShimmer(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[200],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultShimmer(
                    child: Container(
                      width: quarterScreenWidth * 1.5,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: _shimmeringItemDetailDecoration,
                    ),
                  ),
                  DefaultShimmer(
                    child: Container(
                      width: quarterScreenWidth * 0.85,
                      height: 13,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: _shimmeringItemDetailDecoration,
                    ),
                  ),
                  const Spacer(),
                  DefaultShimmer(
                    child: Container(
                      width: quarterScreenWidth,
                      height: 13,
                      decoration: _shimmeringItemDetailDecoration,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: DefaultShimmer(
              child: Container(
                width: halfScreenWidth,
                height: 20,
                decoration: _shimmeringAddToCartButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
