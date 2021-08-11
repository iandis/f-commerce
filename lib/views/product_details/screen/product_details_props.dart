part of '_product_details_screen.dart';

abstract class _ProductDetailsProps extends State<ProductDetailsScreen> {
  final _productDetailsCubit = ProductDetailsCubit();
  final _imageSliderController = PageController();
  HorizontalDotIndicator? _dotIndicator;

  @override
  void initState() {
    super.initState();
    _productDetailsCubit.requestProductDetails(widget.product);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dotIndicator ??= HorizontalDotIndicator(
        dotCount: 3,
        dotSize: 10.0,
        activeDotColor: Theme.of(context).primaryColor,
        inactiveDotColor: Theme.of(context).primaryColor.withOpacity(0.3),
        dotSpacing: 5.0,
      );
  }

  @override
  void dispose() {
    _productDetailsCubit.close();
    _dotIndicator?.dispose();
    _imageSliderController.dispose();
    super.dispose();
  }

  void showCartItems() {
    const appBarShapeBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
    showModalBottomSheet(
      context: context,
      shape: appBarShapeBorder,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const CartItemsScreen(
          centerTitle: true,
          withBackButton: false,
          appBarShapeBorder: appBarShapeBorder,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.transparent,
        );
      },
    );
  }
}
