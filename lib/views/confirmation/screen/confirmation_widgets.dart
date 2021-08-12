part of '_confirmation_screen.dart';

mixin _ConfirmationWidgets on _ConfirmationProps {
  Widget get userAddressText {
    return BlocBuilder<ConfirmationCubit, ConfirmationState>(
      bloc: _confirmationCubit,
      builder: (_, state) {
        final Widget address;
        if (state is AddressLoaded) {
          address = Text(
            state.userAddress,
            maxLines: 3,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontFamily: 'Lato'),
          );
        } else if (state is ConfirmationError) {
          address = IconButton(
            onPressed: _confirmationCubit.requestUserAddress,
            icon: const Icon(Icons.refresh),
          );
        } else if (state is AddressLoading) {
          address = const CupertinoActivityIndicator();
        } else {
          address = const Text('--');
        }
        return Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.grey,
            ),
            const SizedBox(width: 5),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 50,
              child: address,
            ),
          ],
        );
      },
    );
  }

  Widget get invoiceIdText {
    return Row(
      children: [
        const Icon(
          Icons.receipt_sharp,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        Text(
          widget.checkoutItems.invoiceId,
          style: const TextStyle(fontFamily: 'Lato'),
        ),
      ],
    );
  }

  Widget get confirmationSummary {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              invoiceIdText,
              const Divider(),
              userAddressText,
              const Divider(),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return CartItemTile(
                cartItem: widget.checkoutItems.cartItems[index],
              );
            },
            childCount: widget.checkoutItems.cartItems.length,
          ),
        ),
      ],
    );
  }

  Widget get totalPriceCell {
    final totalPrice = widget.checkoutItems.totalCheckoutPrice;
    return ListTile(
      leading: const Text('Total'),
      title: Text(
        Formatters.formatPrice(totalPrice),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: BlocBuilder<ConfirmationCubit, ConfirmationState>(
        bloc: _confirmationCubit,
        builder: (_, state) {
          final VoidCallback? onPressed;
          if (state is ConfirmationError) {
            onPressed = () => cannotConfirmCheckout(state.errorMessage);
          } else if (state is AddressLoading) {
            onPressed = () => cannotConfirmCheckout('Please wait until your address is loaded');
          } else if (state is ConfirmedCheckoutItems) {
            onPressed = null;
          } else {
            onPressed = confirmCheckout;
          }
          return ElevatedButton(
            onPressed: onPressed,
            child: const Text('Confirm'),
          );
        },
      ),
    );
  }
}
