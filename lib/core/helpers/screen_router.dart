import 'package:flutter/material.dart';

import '/core/constants/app_routes.dart';
import '/core/models/cart/checkout_items.dart';
import '/core/models/product/product.dart';
import '/views/_widgets/circular_reveal_clipper.dart';
import '/views/cart_items/screen/_cart_items_screen.dart';
import '/views/confirmation/screen/_confirmation_screen.dart';
import '/views/home/screen/_home_screen.dart';
import '/views/product_details/screen/_product_details_screen.dart';
import '/views/success/success_screen.dart';

class ScreenRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    
    final String? destinationRouteName = settings.name;
    final Object? arguments = settings.arguments;

    return PageRouteBuilder(
      pageBuilder: (_, __, ___) {
        if (destinationRouteName == AppRoutes.home) {
          return const HomeScreen();
        }
        if (destinationRouteName == AppRoutes.details && arguments is Product) {
          return ProductDetailsScreen(product: arguments);
        }
        if (destinationRouteName == AppRoutes.cart) {
          return const CartItemsScreen();
        }
        if (destinationRouteName == AppRoutes.confirmation && arguments is CheckoutItems) {
          return ConfirmationScreen(checkoutItems: arguments);
        }
        if (destinationRouteName == AppRoutes.success && arguments is CheckoutItems) {
          return SuccessScreen(checkoutItems: arguments);
        }
        throw ArgumentError('Unknown arguments of [$arguments] on route [$destinationRouteName]');
      },
      transitionsBuilder: (context, animation, __, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.fastLinearToSlowEaseIn;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return ScaleTransition(
          scale: animation.drive(tween),
          child: ClipPath(
            clipper: CircularRevealClipper(
              fraction: animation.value,
            ),
            child: child,
          ),
        );
      },
      settings: settings,
    );
  }
}
