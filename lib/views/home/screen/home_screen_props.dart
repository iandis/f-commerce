part of '_home_screen.dart';

abstract class _HomeScreenProps extends State<HomeScreen> {
  final _homeCubit = HomeCubit();
  final _productsScrollController = ScrollController();
  final _navigationService = GetIt.I<BaseNavigationService>();

  @override
  void initState() {
    super.initState();

    _homeCubit.cartItemsRepo
        .getCartItemsCount()
        .then(_homeCubit.cartItemsRepo.cartItemCountController.add);

    _productsScrollController.addListener(() {
      final currentOffset = _productsScrollController.offset;
      final almostBottom = _productsScrollController.position.maxScrollExtent - 90;
      final isScrollingDown = _productsScrollController.position.userScrollDirection == ScrollDirection.reverse;
      final isNotLoadingMore = _homeCubit.state.status != HomeStatus.loadingMore;
      final isNotLoading = _homeCubit.state.status != HomeStatus.loading;

      if (currentOffset >= almostBottom &&
          isScrollingDown &&
          isNotLoading &&
          isNotLoadingMore) {
        _homeCubit.loadProducts(more: true);
      }
    });

    _homeCubit.loadProducts();
  }

  @override
  void dispose() {
    _homeCubit.close();
    _productsScrollController.dispose();
    super.dispose();
  }

  bool _scrollToTop() {
    if (_productsScrollController.offset > 0) {
      _productsScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
      );
      return false;
    } else {
      return true;
    }
  }

  void _gotoCartItemsPage() {
    Navigator.of(context).pushNamed(AppRoutes.cart);
  }
}
