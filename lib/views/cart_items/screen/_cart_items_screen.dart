import 'package:fcommerce/core/models/stateful_value/stateful_value.dart';
import 'package:fcommerce/core/models/cart/cart_item.dart';
import 'package:fcommerce/views/_widgets/stateful_cart_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/constants/app_routes.dart';
import '/core/helpers/formatters.dart';
import '/core/models/cart/checkout_items.dart';
import '/core/services/screen_messenger/base_screen_messenger.dart';
import '/views/cart_items/cubit/cartitems_cubit.dart';

part 'cart_items_props.dart';
part 'cart_items_widgets.dart';

class CartItemsScreen extends StatefulWidget {
  final bool centerTitle;
  final bool withBackButton;
  final ShapeBorder? appBarShapeBorder;
  final Color? scaffoldBackgroundColor;
  final Color? backgroundColor;
  const CartItemsScreen({
    Key? key,
    this.centerTitle = false,
    this.withBackButton = true,
    this.appBarShapeBorder,
    this.backgroundColor,
    this.scaffoldBackgroundColor,
  }) : super(key: key);

  @override
  _CartItemsScreenState createState() => _CartItemsScreenState();
}

class _CartItemsScreenState extends _CartItemsProps with _CartItemsWidgets {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        automaticallyImplyLeading: widget.withBackButton,
        shape: widget.appBarShapeBorder,
        centerTitle: widget.centerTitle,
      ),
      backgroundColor: widget.scaffoldBackgroundColor,
      body: BlocConsumer<CartItemsCubit, CartItemsState>(
        bloc: _cartItemsCubit,
        listener: (_, state) {
          if (state is CartItemsError) {
            GetIt.I<BaseScreenMessenger>().showSnackBar(
              context: context,
              message: state.errorMessage,
            );
          }
        },
        builder: (_, state) {
          if (state is CartItemsLoaded) {
            if (state.cartItems.isEmpty) {
              return cartItemsEmpty;
            }
            return cartItemsList;
          } else if(state is CartItemsError) {
            return cartItemsEmpty;
          }
          return Container(
            alignment: Alignment.center,
            color: widget.backgroundColor,
            child: const CircularProgressIndicator(),
          );
        },
      ),
      bottomSheet: BlocBuilder<CartItemsCubit, CartItemsState>(
        bloc: _cartItemsCubit,
        builder: (_, state) {
          if(state is CartItemsLoaded && state.cartItems.isEmpty) {
            return const SizedBox();
          }
          return totalPriceCell;
        },
      ),
    );
  }
}
