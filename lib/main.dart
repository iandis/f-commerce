// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart' as intl show initializeDateFormatting;
import 'package:intl/intl.dart' as intl show Intl;

import 'core/constants/app_routes.dart';
import 'core/helpers/screen_router.dart';
import 'core/services/navigation_service/base_navigation_service.dart';
import 'core/services/notification_service/base_notification_service.dart';
import 'singletons.dart';

Future<void> main() async {
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

  await _initNotification();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;

    return MaterialApp(
      title: 'f-commerce',
      debugShowCheckedModeBanner: false,
      navigatorKey: GetIt.I<BaseNavigationService>().navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        appBarTheme: appBarTheme.copyWith(
          brightness: Brightness.dark,
          elevation: 1,
          shadowColor: Colors.grey.withOpacity(0.5),
        ),
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: ScreenRouter.onGenerateRoute,
    );
  }
}

Future<void> _initNotification() async {
  final BaseNotificationService notifService = GetIt.I<BaseNotificationService>();
  // final BaseNavigationService navService = GetIt.I<BaseNavigationService>();
  await notifService.init();

  // notifService.onBackgroundNotification(
  //   (final Notification notification) {
  //     final Map<String, dynamic> additionalData = notification.data;

  //     additionalData['title'] = notification.remoteNotification?.title;
  //     additionalData['body'] = notification.remoteNotification?.body;

  //     notifService.showNotification(
  //       1,
  //       '${notification.remoteNotification?.title ?? 'Null Title'} from background',
  //       '${notification.remoteNotification?.title ?? 'Null Body'} from background',
  //       jsonEncode(additionalData),
  //     );
  //   },
  // );

  
  // notifService.onReceiveNotification(
  //   (final Notification notification) {
  //     final Map<String, dynamic> additionalData = notification.data;

  //     additionalData['title'] = notification.remoteNotification?.title;
  //     additionalData['body'] = notification.remoteNotification?.body;

  //     notifService.showNotification(
  //       1,
  //       '${notification.remoteNotification?.title ?? 'Null Title'} from terminated state',
  //       '${notification.remoteNotification?.title ?? 'Null Body'} from terminated state',
  //       jsonEncode(additionalData),
  //     );
  //   },
  // );

  // notifService.onSelectNotification(
  //   (final String? payload) {
  //     final Map<String, dynamic>? data;
  //     if (payload != null) {
  //       final dynamic decodedData = jsonDecode(payload);
  //       if (decodedData is Map<String, dynamic>) {
  //         data = decodedData;
  //       } else {
  //         data = null;
  //       }
  //     } else {
  //       data = null;
  //     }

  //     if (data != null) {
  //       final dynamic rawTitle = data['title'];
  //       final dynamic rawBody = data['body'];

  //       final String title = rawTitle is String ? rawTitle : 'Null Title';
  //       final String body = rawBody is String ? rawBody : 'Null Body';

  //       navService.showSnackBar(
  //         message: 'Title: $title from select notification\nBody: $body from select notification',
  //       );
  //     }
  //   },
  // );
}
