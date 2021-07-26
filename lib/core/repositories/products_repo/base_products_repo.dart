
import '/core/models/product/product.dart';
import '/core/models/product/product_details.dart';

abstract class BaseProductsRepository {
  Future<ProductDetails> getProductDetails(int id);
  Future<List<Product>> getProducts({int page = 0});
}