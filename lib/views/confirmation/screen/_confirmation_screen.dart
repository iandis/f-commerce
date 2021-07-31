
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '/core/constants/app_routes.dart';
import '/core/constants/app_theme.dart';
import '/core/helpers/formatters.dart';
import '/core/models/cart/checkout_items.dart';
import '/core/services/navigation_service/base_navigation_service.dart';
import '/views/_widgets/cart_item_tile.dart';
import '/views/confirmation/cubit/confirmation_cubit.dart';

part 'confirmation_props.dart';
part 'confirmation_widgets.dart';

class ConfirmationScreen extends StatefulWidget {
  final CheckoutItems checkoutItems;

  const ConfirmationScreen({
    Key? key,
    required this.checkoutItems,
  }) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends _ConfirmationProps with _ConfirmationWidgets {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        brightness: Brightness.dark,
      ),
      body: BlocListener<ConfirmationCubit, ConfirmationState>(
        bloc: _confirmationCubit,
        listener: (_, state) {
          if (state is ConfirmationError) {
            GetIt.I<BaseNavigationService>().showSnackBar(
              message: state.errorMessage,
              backgroundColor: AppTheme.primaryColor,
              floating: true,
            );
          } else if (state is ConfirmedCheckoutItems) {
            GetIt.I<BaseNavigationService>().offToName(
              AppRoutes.success,
              arguments: state.confirmedCheckoutItems,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: const EdgeInsets.only(bottom: 56),
          child: confirmationSummary,
        ),
      ),
      bottomSheet: totalPriceCell,
    );
  }
}
