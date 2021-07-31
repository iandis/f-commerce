import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '/core/helpers/error_handler.dart';
import '/core/models/cart/cart_item.dart';
import '/core/models/product/product.dart';
import '/core/repositories/cartitems_repo/base_cartitems_repo.dart';
import '/core/repositories/products_repo/base_products_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BaseProductsRepository _productsRepo;
  final BaseCartItemsRepository cartItemsRepo;

  HomeCubit({
    BaseProductsRepository? productsRepo,
    BaseCartItemsRepository? cartItemsRepo,
  })  : cartItemsRepo = cartItemsRepo ?? GetIt.I<BaseCartItemsRepository>(),
        _productsRepo = productsRepo ?? GetIt.I<BaseProductsRepository>(),
        super(HomeState.init());

  Future<void> loadProducts({bool more = false}) async {
    if(state.status == HomeStatus.loading || state.status == HomeStatus.loadingMore) return;
    emit(more ? state.loadingMore() : state.loading());

    try {
      final nextPage = more ? state.currentPage + 1 : 0;
      final nextProducts = await _productsRepo.getProducts(page: nextPage);
      emit(state.loaded(
        products: state.products + nextProducts,
        newPage: nextPage,
      ));
    } catch (e, st) {
      ErrorHandler.catchIt(
        error: e,
        stackTrace: st,
        customUnknownErrorMessage:
            'Oops.. An unknown error occurred while fetching products list :(',
        onCatch: _handleError,
      );
    }
  }

  Future<void> addToCart(Product product) async {
    final isInCart = await cartItemsRepo.isInCartItem(product.id);
    if (isInCart) {
      final currentAmount = await cartItemsRepo.getCartItemCount(product.id);
      cartItemsRepo.updateCartItemAmount(
        id: product.id,
        newAmount: currentAmount + 1,
      );
    } else {
      final newCartItem = CartItem.fromProduct(
        product: product,
        amount: 1,
      );
      cartItemsRepo.insertCartItem(newCartItem);
    }
  }

  void _handleError(String errorMessage) {
    emit(state.error(errorMessage));
  }
}
