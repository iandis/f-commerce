import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/constants/app_routes.dart';
import '/core/constants/app_theme.dart';
import '/core/helpers/formatters.dart';
import '/core/models/cart/cart_item.dart';
import '/core/models/cart/checkout_items.dart';
import '/core/services/navigation_service/base_navigation_service.dart';
import '/views/_widgets/cart_item_tile.dart';
import '/views/cart_items/cubit/cartitems_cubit.dart';

part 'cart_items_props.dart';
part 'cart_items_widgets.dart';

typedef VLB<T> = ValueListenableBuilder<T>;

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
        brightness: Brightness.dark,
        shape: widget.appBarShapeBorder,
        centerTitle: widget.centerTitle,
        elevation: 0,
      ),
      backgroundColor: widget.scaffoldBackgroundColor,
      body: BlocConsumer<CartItemsCubit, CartItemsState>(
        bloc: _cartItemsCubit,
        listener: (_, state) {
          if (state is CartItemsError) {
            GetIt.I<BaseNavigationService>().showSnackBar(
              message: state.errorMessage,
              backgroundColor: AppTheme.primaryColor,
            );
          }
        },
        builder: (_, state) {
          if (state is CartItemsLoaded) {
            if (state.cartItems.isEmpty) {
              return cartItemsEmpty;
            }
            return cartItemsList(state);
          }
          return Container(
            alignment: Alignment.center,
            color: widget.backgroundColor,
            child: const CircularProgressIndicator(),
          );
        },
      ),
      bottomSheet: BlocBuilder<CartItemsCubit,CartItemsState>(
        bloc: _cartItemsCubit,
        buildWhen: (prev, current) => current is CartItemsLoaded || current is CartItemsModified,
        builder: (_, state) {
          if(state is CartItemsLoaded) {
            if(state.cartItems.isNotEmpty) {
              return totalPriceCell(state);
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
