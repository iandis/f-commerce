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

  Widget get cartCountIcon {
    final circleBadgeDecoration = BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    );

    final countBadge = StreamBuilder<int>(
      initialData: 0,
      stream: _homeCubit.cartItemsRepo.cartItemCountController.stream,
      builder: (_, countSnapshot) {
        final countText = Text(
          countSnapshot.data.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        );

        return Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(
              minHeight: 12,
              minWidth: 13,
            ),
            decoration: circleBadgeDecoration,
            child: countText,
          ),
        );
      },
    );

    return IconButton(
      onPressed: _gotoCartItemsPage,
      padding: const EdgeInsets.all(4),
      color: Colors.grey[900],
      iconSize: 27,
      icon: Stack(
        children: [
          const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          countBadge,
        ],
      ),
    );
  }
}
