import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart' as intl show initializeDateFormatting;
import 'package:intl/intl.dart' as intl show Intl;

import 'core/constants/app_routes.dart';
import 'core/constants/app_theme.dart';
import 'core/helpers/screen_router.dart';
import 'core/services/navigation_service/base_navigation_service.dart';
import 'singletons.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  intl.Intl.defaultLocale = 'id';
  intl.initializeDateFormatting('id_ID');

  initSingletons();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dekornata',
      debugShowCheckedModeBanner: false,
      navigatorKey: GetIt.I<BaseNavigationService>().navigatorKey,
      scaffoldMessengerKey: GetIt.I<BaseNavigationService>().messengerKey,
      theme: ThemeData(
        accentColor: AppTheme.accentColor,
        primaryColor: AppTheme.primaryColor,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: ScreenRouter.onGenerateRoute,
    );
  }
}
