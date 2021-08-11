import 'package:flutter/material.dart';

import '/core/constants/app_routes.dart';
import '/core/helpers/formatters.dart';
import '/core/models/cart/checkout_items.dart';
import '/views/_widgets/cart_item_tile.dart';

class SuccessScreen extends StatefulWidget {
  final CheckoutItems checkoutItems;
  const SuccessScreen({
    Key? key,
    required this.checkoutItems,
  }) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil(ModalRoute.withName(AppRoutes.home));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Success'),
          brightness: Brightness.dark,
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: const EdgeInsets.only(bottom: 56),
          child: confirmationSummary,
        ),
        bottomSheet: totalPriceCell,
      ),
    );
  }

  Widget get userAddressText {
    final address = Text(
      widget.checkoutItems.destination,
      maxLines: 3,
      textAlign: TextAlign.justify,
    );
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width - 50,
          child: address,
        ),
      ],
    );
  }

  Widget get invoiceIdText {
    return Row(
      children: [
        const Icon(
          Icons.receipt_sharp,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        Text(widget.checkoutItems.invoiceId),
      ],
    );
  }

  Widget get confirmationSummary {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 20),
              Text(
                'Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              Divider(),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              invoiceIdText,
              const Divider(),
              userAddressText,
              const Divider(),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return CartItemTile(
                cartItem: widget.checkoutItems.cartItems[index],
              );
            },
            childCount: widget.checkoutItems.cartItems.length,
          ),
        ),
      ],
    );
  }

  Widget get totalPriceCell {
    return SizedBox(
      height: 56,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Total',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            Formatters.formatPrice(widget.checkoutItems.totalCheckoutPrice),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
