import 'package:flutter/material.dart';

import '/views/_widgets/default_shimmer.dart';

late final _cardShadowColor = Colors.grey[50]?.withOpacity(0.3);

final _cardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
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
    return Card(
      margin: EdgeInsets.zero,
      borderOnForeground: false,
      elevation: 4.0,
      color: Colors.grey[50],
      clipBehavior: Clip.hardEdge,
      shadowColor: _cardShadowColor,
      shape: _cardShape,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: DefaultShimmer(
              child: Container(
                color: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultShimmer(
                    child: Container(
                      width: quarterScreenWidth * 1.5,
                      height: 15,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: _shimmeringItemDetailDecoration,
                    ),
                  ),
                  DefaultShimmer(
                    child: Container(
                      width: quarterScreenWidth * 0.85,
                      height: 15,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: _shimmeringItemDetailDecoration,
                    ),
                  ),
                  DefaultShimmer(
                    child: Container(
                      width: quarterScreenWidth,
                      height: 15,
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
