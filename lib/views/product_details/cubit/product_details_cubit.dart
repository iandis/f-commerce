import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '/core/helpers/error_handler.dart';
import '/core/models/cart/cart_item.dart';
import '/core/models/product/product.dart';
import '/core/models/product/product_details.dart';
import '/core/repositories/cartitems_repo/base_cartitems_repo.dart';
import '/core/repositories/products_repo/base_products_repo.dart';

part 'product_details_state.dart';

typedef BPRepo = BaseProductsRepository;
typedef BCIRepo = BaseCartItemsRepository;

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final BPRepo _productsRepo;
  final BCIRepo cartItemsRepo;

  ProductDetailsCubit({
    BPRepo? productsRepo,
    BCIRepo? cartItemsRepo,
  })  : cartItemsRepo = cartItemsRepo ?? GetIt.I<BCIRepo>(),
        _productsRepo = productsRepo ?? GetIt.I<BPRepo>(),
        super(const ProductDetailsInit());

  Future<void> requestProductDetails(Product product) async {
    if (state is ProductDetailsLoading) return;
    emit(const ProductDetailsLoading());
    try {
      final productDetails = await _productsRepo.getProductDetails(product.id);
      emit(ProductDetailsLoaded(productDetails));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops.. An unknown error occurred while loading product details :(',
        onCatch: _catchError,
      );
    }
  }

  Future<void> addToCart() async {
    if (state is ProductDetailsLoaded) {
      final state = this.state as ProductDetailsLoaded;
      final isInCart = await cartItemsRepo.isInCartItem(state.productDetails.id);
      if (isInCart) {
        final currentAmount = await cartItemsRepo.getCartItemCount(state.productDetails.id);
        cartItemsRepo.updateCartItemAmount(
          id: state.productDetails.id,
          newAmount: currentAmount + 1,
        );
      } else {
        final newCartItem = CartItem.fromProduct(
          product: state.productDetails.toProduct(),
          amount: 1,
        );
        cartItemsRepo.insertCartItem(newCartItem);
      }
    }
  }

  void _catchError(String errorMessage) {
    emit(ProductDetailsError(errorMessage));
  }
}
