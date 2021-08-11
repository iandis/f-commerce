import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart' as intl show initializeDateFormatting;
import 'package:intl/intl.dart' as intl show Intl;

import 'core/constants/app_routes.dart';
import 'core/helpers/screen_router.dart';
import 'singletons.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
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
      title: 'f-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          elevation: 4,
          shadowColor: Colors.grey.withOpacity(0.5),
        ),
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: ScreenRouter.onGenerateRoute,
    );
  }
}
