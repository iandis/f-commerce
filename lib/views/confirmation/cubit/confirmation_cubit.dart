import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '/core/helpers/error_handler.dart';
import '/core/models/cart/checkout_items.dart';
import '/core/repositories/cartitems_repo/base_cartitems_repo.dart';
import '/core/services/location_service/base_location_service.dart';

part 'confirmation_state.dart';

class ConfirmationCubit extends Cubit<ConfirmationState> {
  final BaseLocationService _locationService;
  final BaseCartItemsRepository _cartItemsRepo;
  ConfirmationCubit({
    BaseLocationService? locationService,
    BaseCartItemsRepository? cartItemsRepo,
  })  : _locationService = locationService ?? GetIt.I<BaseLocationService>(),
        _cartItemsRepo = cartItemsRepo ?? GetIt.I<BaseCartItemsRepository>(),
        super(const ConfirmationInit());

  Future<void> requestUserAddress() async {
    if (state is AddressLoading) return;
    emit(const AddressLoading());
    try {
      final isPermitted = await _locationService.requestLocationPermission();
      if (!isPermitted) {
        _catchError('Cannot get current location: Permission denied');
        return;
      }
      final userCurrentCoordinate = await _locationService.getCurrentCoordinates();
      if (userCurrentCoordinate.first == null || userCurrentCoordinate.last == null) {
        throw Exception();
      }
      final userAddress = await _locationService.getAddressFromCoordinates(
        latitude: userCurrentCoordinate.first!,
        longitude: userCurrentCoordinate.last!,
      );
      emit(AddressLoaded(userAddress));
    } catch (error, stackTrace) {
      ErrorHandler.catchIt(
        error: error,
        stackTrace: stackTrace,
        customUnknownErrorMessage: 'Oops... Failed to get current location :( Please try again',
        onCatch: _catchError,
      );
    }
  }

  Future<void> confirmCheckoutItems(CheckoutItems checkoutItems) async {
    if(state is! AddressLoaded) return;
    final currentState = state as AddressLoaded;
    final cartItemIds = checkoutItems.cartItems.map<int>((e) => e.id).toList(growable: false);
    await _cartItemsRepo.deleteCartItems(cartItemIds);
    
    final confirmedCheckoutItems = checkoutItems.copyWith(destination: currentState.userAddress);
    emit(ConfirmedCheckoutItems(confirmedCheckoutItems));
  }

  void _catchError(String errorMessage) {
    emit(ConfirmationError(errorMessage));
  }
}
