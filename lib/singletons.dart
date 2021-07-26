
import 'package:get_it/get_it.dart';

import '/core/repositories/cartitems_repo/base_cartitems_repo.dart';
import '/core/repositories/cartitems_repo/cartitems_repo.dart';

import '/core/repositories/products_repo/base_products_repo.dart';
import '/core/repositories/products_repo/products_repo.dart';

import '/core/services/http_service/base_http_service.dart';
import '/core/services/http_service/http_service.dart';

import '/core/services/localdb_service/base_localdb_service.dart';
import '/core/services/localdb_service/localdb_service.dart';

void initSingletons() {
  GetIt.I.registerSingleton<BaseHttpService>(HTTPService());
  GetIt.I.registerSingleton<BaseLocalDbService>(LocalDbService()..initDb());
  GetIt.I.registerSingleton<BaseProductsRepository>(
    ProductsRepository(
      httpService: GetIt.I<BaseHttpService>(),
    ),
  );
  GetIt.I.registerSingleton<BaseCartItemsRepository>(
    CartItemsRepository(
      localDbService: GetIt.I<BaseLocalDbService>(),
    ),
  );
}
