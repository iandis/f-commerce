import 'package:get_it/get_it.dart';

import 'core/repositories/cartitems_repo/base_cartitems_repo.dart';
import 'core/repositories/cartitems_repo/cartitems_repo.dart';
import 'core/repositories/products_repo/base_products_repo.dart';
import 'core/repositories/products_repo/products_repo.dart';
import 'core/services/http_service/base_http_service.dart';
import 'core/services/http_service/http_service.dart';
import 'core/services/localdb_service/base_localdb_service.dart';
import 'core/services/localdb_service/localdb_service.dart';
import 'core/services/location_service/base_location_service.dart';
import 'core/services/location_service/location_service.dart';
import 'core/services/screen_messenger/base_screen_messenger.dart';
import 'core/services/screen_messenger/screen_messenger.dart';

void initSingletons() {
  GetIt.I.registerSingleton<BaseHttpService>(HttpService());
  GetIt.I.registerSingleton<BaseLocalDbService>(LocalDbService());
  GetIt.I.registerSingleton<BaseProductsRepository>(ProductsRepository());
  GetIt.I.registerSingleton<BaseCartItemsRepository>(CartItemsRepository());

  GetIt.I.registerLazySingleton<BaseLocationService>(() => LocationService());
  GetIt.I.registerLazySingleton<BaseScreenMessenger>(() => ScreenMessenger());
}
