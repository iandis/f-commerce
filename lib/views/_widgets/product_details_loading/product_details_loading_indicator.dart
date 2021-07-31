import 'package:flutter/material.dart';

import '/views/_widgets/default_shimmer.dart';

final _shimmeringItemDetailDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
);

class ProductDetailsLoadingIndicator extends StatelessWidget {
  const ProductDetailsLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productImagesSlider = SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.67,
      flexibleSpace: FlexibleSpaceBar(
        background: DefaultShimmer(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.67,
          ),
        ),
      ),
      pinned: true,
    );

    final productName = DefaultShimmer(
      child: Container(
        height: 40,
        decoration: _shimmeringItemDetailDecoration,
      ),
    );

    final productPrice = DefaultShimmer(
      child: Container(
        height: 25,
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: _shimmeringItemDetailDecoration,
      ),
    );

    final productMaterial = DefaultShimmer(
      child: Container(
        height: 25,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: _shimmeringItemDetailDecoration,
      ),
    );

    return CustomScrollView(
      slivers: [
        productImagesSlider,
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productName,
                const SizedBox(height: 5),
                productPrice,
                const Divider(),
                const Text(
                  'Material',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                productMaterial,
                const Divider(),
                const Text(
                  'Available Colors',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                DefaultShimmer(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                    width: 90,
                    decoration: _shimmeringItemDetailDecoration,
                  ),
                ),
                DefaultShimmer(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                    width: 125,
                    decoration: _shimmeringItemDetailDecoration,
                  ),
                ),
                DefaultShimmer(
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                    width: 110,
                    decoration: _shimmeringItemDetailDecoration,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Divider(),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
      ],
    );
  }
}
