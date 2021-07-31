part of 'product_details_cubit.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInit extends ProductDetailsState {
  const ProductDetailsInit();
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsLoaded extends ProductDetailsState {
  
  const ProductDetailsLoaded(this.productDetails);

  final ProductDetails productDetails;

  @override
  List<Object> get props => [productDetails];
}

class ProductDetailsError extends ProductDetailsState {

  const ProductDetailsError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}