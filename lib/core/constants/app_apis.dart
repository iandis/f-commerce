
/// Available endpoints are:
/// * products
/// * details
enum AppApiEndpoints {
  products,
  details,
}

extension ApiEndpointsName on AppApiEndpoints {
  String get name {
    switch(index) {
      case 0:
        return 'products';
      case 1:
        return 'details';
      default:
        throw IndexError(index, AppApiEndpoints.values.length);
    }
  }
}

class AppApis {
  /// This database was created by me 😀
  /// 
  /// It uses Firebase Realtime Database as its host and
  /// `Faker.js` as its dataset generator. So if you notice
  /// multiple duplicate images, it's because `Faker.js`'s
  /// random image url generator is limited.
  static const String _baseUrl = 'https://fcommerce-api-default-rtdb.asia-southeast1.firebasedatabase.app';
  
  /// This is used for retrieving either `/products/{page}` or `/details/{productId}`
  ///
  /// Note: all endpoints and product id start from 0
  static String endpointOf(AppApiEndpoints endpoint, int pageOrId) {
    return '$_baseUrl/${endpoint.name}/$pageOrId.json';
  }
}