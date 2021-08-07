part of '_confirmation_screen.dart';

abstract class _ConfirmationProps extends State<ConfirmationScreen> {
  final _confirmationCubit = ConfirmationCubit();

  @override
  void initState() {
    super.initState();
    _confirmationCubit.requestUserAddress();
  }

  @override
  void dispose() {
    _confirmationCubit.close();
    super.dispose();
  }

  void cannotConfirmCheckout(String reason) {
    GetIt.I<BaseScreenMessenger>().showSnackBar(
      context: context,
      message: reason,
      backgroundColor: AppTheme.primaryColor,
    );
  }

  void confirmCheckout() {
    GetIt.I<BaseScreenMessenger>().showDialog(
      context: context,
      blurFactor: 4,
      barrierDismissible: false,
      barrierLabel: '',
      pageBuilder: (_, __, ___) => Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
    _confirmationCubit.confirmCheckoutItems(widget.checkoutItems);
  }
}
