part of '_home_screen.dart';

mixin _HomeScreenWidgets on _HomeScreenProps {
  Widget get productsGrid {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          final currentProduct = _homeCubit.state.products[index];
          return ProductCard(
            product: currentProduct,
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.details,
              arguments: currentProduct,
            ),
            onAddToCartPressed: () => _homeCubit.addToCart(currentProduct),
          );
        },
        childCount: _homeCubit.state.products.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 295,
      ),
    );
  }
}
