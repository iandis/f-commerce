part of '_home_screen.dart';

abstract class _HomeScreenProps extends State<HomeScreen> {
  final _homeCubit = HomeCubit();
  final _productsScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _homeCubit.cartItemsRepo.getCartItemsCount().then(_homeCubit.cartItemsRepo.cartItemCountController.add);

    _productsScrollController.addListener(_loadMoreProducts);
    _homeCubit.loadProducts();
    _subscribeToNotification();
  }

  @override
  void dispose() {
    _homeCubit.close();
    _productsScrollController.dispose();
    super.dispose();
  }

  void _loadMoreProducts() {
    if (_productsScrollController.offset >= _productsScrollController.position.maxScrollExtent - 90 &&
        _productsScrollController.position.userScrollDirection == ScrollDirection.reverse &&
        _homeCubit.state.status != HomeStatus.loading &&
        _homeCubit.state.status != HomeStatus.loadingMore &&
        !_homeCubit.state.isAtEndOfPage) {
      _homeCubit.loadProducts(more: true);
    }
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

  void _subscribeToNotification() {
    final BaseNotificationService notifService = GetIt.I<BaseNotificationService>();
    // ignore: deprecated_member_use_from_same_package
    final BaseNavigationService navService = GetIt.I<BaseNavigationService>();
    notifService.onForegroundNotification(
      (final Notification notification) {
        navService.showDialogWithBlur(
          barrierLabel: '',
          barrierDismissible: true,
          pageBuilder: (BuildContext context, __, ___) {
            return AlertDialog(
              title: Text('${notification.remoteNotification?.title ?? 'Null Title'} from foreground'),
              content: Text('${notification.remoteNotification?.body ?? 'Null Body'} from foreground'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    notifService.onBackgroundNotificationOpened(
      (final Notification notification) {
        navService.showDialogWithBlur(
          barrierLabel: '',
          barrierDismissible: true,
          pageBuilder: (BuildContext context, __, ___) {
            return AlertDialog(
              title: Text('${notification.remoteNotification?.title ?? 'Null Title'} from background'),
              content: Text('${notification.remoteNotification?.body ?? 'Null Body'} from background'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
