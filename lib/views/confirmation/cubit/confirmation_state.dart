part of 'confirmation_cubit.dart';

abstract class ConfirmationState extends Equatable {
  const ConfirmationState();

  @override
  List<Object> get props => [];
}

class ConfirmationInit extends ConfirmationState {
  const ConfirmationInit();
}

class AddressLoading extends ConfirmationState {
  const AddressLoading();
}

class AddressLoaded extends ConfirmationState {
  
  const AddressLoaded(this.userAddress);

  final String userAddress;

  @override
  List<Object> get props => [userAddress];
}

class ConfirmedCheckoutItems extends ConfirmationState {
  const ConfirmedCheckoutItems(this.confirmedCheckoutItems);

  final CheckoutItems confirmedCheckoutItems;

  @override
  List<Object> get props => [confirmedCheckoutItems];
}

class ConfirmationError extends ConfirmationState {
  
  const ConfirmationError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
