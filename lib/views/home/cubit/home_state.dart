part of 'home_cubit.dart';

enum HomeStatus {
  init,
  loading,
  loaded,
  loadingMore,
  error,
}

class HomeState extends Equatable {
  const HomeState({
    required this.currentPage,
    required this.status,
    required this.products,
    this.errorMessage,
  });

  final int currentPage;
  final HomeStatus status;
  final List<Product> products;
  final String? errorMessage;

  factory HomeState.init() {
    return const HomeState(
      currentPage: 0,
      status: HomeStatus.init,
      products: [],
    );
  }

  HomeState loading() {
    return const HomeState(
      currentPage: 0,
      status: HomeStatus.loading,
      products: [],
    );
  }

  HomeState loaded({
    required List<Product> products,
    int? newPage,
  }) {
    return HomeState(
      currentPage: newPage ?? currentPage,
      status: HomeStatus.loaded,
      products: products,
    );
  }

  HomeState loadingMore() {
    return HomeState(
      currentPage: currentPage,
      status: HomeStatus.loadingMore,
      products: products,
    );
  }

  HomeState error(String errorMessage) {
    return HomeState(
      currentPage: currentPage,
      status: HomeStatus.error,
      products: products,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object> get props => [currentPage, status, products];
}
