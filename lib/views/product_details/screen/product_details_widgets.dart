part of '_product_details_screen.dart';

mixin _ProductDetailsWidgets on _ProductDetailsProps {
  Widget productDetails(ProductDetailsLoaded state) {
    final productImages = state.productDetails.images.map((image) {
      return Container(
        color: Colors.grey[200],
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          placeholder: (_, __) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentColor,
                backgroundColor: AppTheme.primaryColor,
              ),
            );
          },
        ),
      );
    }).toList(growable: false);

    final expandedHeight = MediaQuery.of(context).size.height * 0.67;

    final imageSlider = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView(
          controller: _imageSliderController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: _dotIndicator.moveDot,
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
        cartCountIcon,
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
        color: Colors.amber,
        fontSize: 20,
        fontWeight: FontWeight.w500,
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
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 18,
                wordSpacing: 1.5,
              ),
            ),
            const Divider(),
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

  Widget get cartCountIcon {
    final circleBadgeDecoration = BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    );

    final countBadge = StreamBuilder<int>(
      initialData: 0,
      stream: _productDetailsCubit.cartItemsRepo.cartItemCountController.stream,
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
      onPressed: showCartItems,
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
