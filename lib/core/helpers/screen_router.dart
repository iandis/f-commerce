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
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) {
        switch (settings.name) {
          case AppRoutes.home:
            return const HomeScreen();
          case AppRoutes.details:
            final Object? product = settings.arguments;
            if(product is Product) {
              return ProductDetailsScreen(product: product);
            }
            throw ArgumentError(product);
          case AppRoutes.cart:
            return const CartItemsScreen();
          case AppRoutes.confirmation:
            final Object? checkoutItems = settings.arguments;
            if(checkoutItems is CheckoutItems) {
              return ConfirmationScreen(checkoutItems: checkoutItems);
            }
            throw ArgumentError(checkoutItems);
          case AppRoutes.success:
            final Object? confirmedCheckoutItems = settings.arguments;
            if(confirmedCheckoutItems is CheckoutItems) {
              return SuccessScreen(checkoutItems: confirmedCheckoutItems);
            }
            throw ArgumentError(confirmedCheckoutItems);
          default:
            return const Center(
              child: Text(
                "Oops.. The page you're looking for does not exist.",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
        }
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

