import 'package:fcommerce/views/_widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/constants/app_routes.dart';
import '/core/services/screen_messenger/base_screen_messenger.dart';
import '/views/_widgets/cart_count_icon.dart';
import '/views/_widgets/product_card/product_card.dart';
import '/views/_widgets/product_card/product_card_loading.dart';
import '/views/home/cubit/home_cubit.dart';

part 'home_screen_props.dart';
part 'home_screen_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends _HomeScreenProps with _HomeScreenWidgets {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _scrollToTop(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('f-commerce'),
          actions: [
            CartCountIcon(
              onTap: _gotoCartItemsPage,
              cartCountStream: _homeCubit.cartItemsRepo.cartItemCountController.stream,
            ),
          ],
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: _homeCubit.loadProducts,
          child: BlocConsumer<HomeCubit, HomeState>(
            bloc: _homeCubit,
            listener: (_, state) {
              if (state.status == HomeStatus.error && state.products.isNotEmpty) {
                GetIt.I<BaseScreenMessenger>().showSnackBar(
                  context: context,
                  message: state.errorMessage,
                );
              }
            },
            builder: (_, state) {
              if (state.status == HomeStatus.error && state.products.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: ErrorScreen(
                      errorMessage: state.errorMessage!,
                      onRetry: _homeCubit.loadProducts,
                    ),
                  ),
                );
              }
              final Widget mainGrid;
              if (state.status == HomeStatus.loading) {
                mainGrid = const ProductsLoadingIndicator(itemCount: 10);
              } else {
                mainGrid = productsGrid;
              }
              return CustomScrollView(
                controller: _productsScrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    sliver: mainGrid,
                  ),
                  if (state.status == HomeStatus.loadingMore)
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      sliver: ProductsLoadingIndicator(),
                    ),
                  if (state.isAtEndOfPage)
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        height: 20,
                        child: const Text(
                          'No more products',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
