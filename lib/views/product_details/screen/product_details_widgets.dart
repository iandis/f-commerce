part of '_product_details_screen.dart';

mixin _ProductDetailsWidgets on _ProductDetailsProps {
  Widget productDetails(ProductDetailsLoaded state) {
    final expandedHeight = MediaQuery.of(context).size.height * 0.67;

    final productImages = state.productDetails.images.map((image) {
      return Container(
        color: Colors.grey[200],
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (_, __) {
            return DefaultShimmer(
              child: Container(
                color: Colors.white,
                height: expandedHeight,
              ),
            );
          },
        ),
      );
    }).toList(growable: false);

    final imageSlider = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView(
          controller: _imageSliderController,
          onPageChanged: _dotIndicator?.moveDot,
          children: productImages,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _dotIndicator,
        ),
      ],
    );

    final parallaxAppBar = SliverAppBar(
      actions: [
        CartCountIcon(
          onTap: showCartItems,
          cartCountStream: _productDetailsCubit.cartItemsRepo.cartItemCountController.stream,
        ),
      ],
      expandedHeight: expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        background: imageSlider,
      ),
      pinned: true,
    );

    final productName = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 6,
          child: Text(
            state.productDetails.name,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: _productDetailsCubit.addToCart,
            padding: const EdgeInsets.all(4),
            iconSize: 27,
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );

    final productPrice = Text(
      Formatters.formatPrice(state.productDetails.price),
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'Lato',
      ),
    );

    final productMaterial = Text(
      state.productDetails.material,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );

    final namePriceMaterialSection = SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            productName,
            productPrice,
            const Divider(),
            const Text(
              'Material',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            productMaterial,
            const Divider(),
            const Text(
              'Available Colors',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );

    final availableColorTagCards = SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: state.productDetails.availableColors.map<Widget>((color) {
            return ColorTagCard(colorName: color);
          }).toList(),
        ),
      ),
    );

    final productDescription = SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            const Text(
              'Description',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              state.productDetails.description,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Lato',
              ),
            ),
            const Divider(),
            const SizedBox(height: 15),

          ],
        ),
      ),
    );

    return CustomScrollView(
      slivers: [
        parallaxAppBar,
        namePriceMaterialSection,
        availableColorTagCards,
        productDescription,
      ],
    );
  }
}
