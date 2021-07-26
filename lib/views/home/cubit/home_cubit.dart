import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '/core/helpers/error_handler.dart';
import '/core/models/product/product.dart';
import '/core/repositories/products_repo/base_products_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BaseProductsRepository _productsRepo;

  HomeCubit({
    BaseProductsRepository? productsRepo,
  })  : _productsRepo = productsRepo ?? GetIt.I<BaseProductsRepository>(),
        super(HomeState.init());

  Future<void> loadProducts({bool more = false}) async {
    emit(more ? state.loadingMore() : state.loading());

    try {
      final nextPage = more ? state.currentPage + 1 : 0;
      final nextProducts = await _productsRepo.getProducts(page: nextPage);
      emit(state.loaded(
        products: nextProducts,
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

  void _handleError(String errorMessage) {
    emit(state.error(errorMessage));
  }
}
