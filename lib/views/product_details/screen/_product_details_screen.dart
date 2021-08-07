
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/constants/app_theme.dart';
import '/core/helpers/formatters.dart';
import '/core/models/product/product.dart';
import '/core/services/screen_messenger/base_screen_messenger.dart';
import '/views/_widgets/carousel_indicator/horizontal_dot_indicator.dart';
import '/views/_widgets/color_tag_card.dart';
import '/views/_widgets/product_details_loading/product_details_loading_indicator.dart';
import '/views/cart_items/screen/_cart_items_screen.dart';
import '/views/product_details/cubit/product_details_cubit.dart';

part 'product_details_props.dart';
part 'product_details_widgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    required this.product,
  });

  final Product product;

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends _ProductDetailsProps with _ProductDetailsWidgets {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        bloc: _productDetailsCubit,
        listener: (_, state) {
          if (state is ProductDetailsError) {
            GetIt.I<BaseScreenMessenger>().showSnackBar(
              context: context,
              backgroundColor: AppTheme.primaryColor,
              message: state.errorMessage,
            );
          }
        },
        builder: (_, state) {
          if (state is ProductDetailsLoaded) {
            return productDetails(state);
          } else {
            return const ProductDetailsLoadingIndicator();
          }
        },
      ),
    );
  }
}
