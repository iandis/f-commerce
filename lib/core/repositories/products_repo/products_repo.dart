import 'dart:convert';
import 'dart:io';

import '/core/constants/app_apis.dart';
import '/core/helpers/error_handler.dart';
import '/core/models/product/product.dart';
import '/core/models/product/product_details.dart';
import '/core/services/http_service/base_http_service.dart';

import 'base_products_repo.dart';

class ProductsRepository implements BaseProductsRepository {
  final BaseHttpService _httpService;

  const ProductsRepository({
    required BaseHttpService networkService,
  }) : _httpService = networkService;

  Map<String, String> get _defaultHeader => const {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  @override
  Future<ProductDetails> getProductDetails(int id) async {
    final uri = Uri.parse(
      AppApis.endpointOf(AppApiEndpoints.details, id),
    );
    final response = await _httpService.get(
      uri,
      headers: _defaultHeader,
    );
    if (response.statusCode == 200) {
      return ProductDetails.fromJson(response.body);
    } else {
      throw ErrorHandler.transformStatusCodeToException(
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }
  }

  @override
  Future<List<Product>> getProducts({int page = 0}) async {
    final uri = Uri.parse(
      AppApis.endpointOf(AppApiEndpoints.products, page),
    );
    final response = await _httpService.get(
      uri,
      headers: _defaultHeader,
    );

    if (response.statusCode == 200) {
      final map = json.decode(response.body) as Map<String, dynamic>;
      final data = map['data'] as List<Map<String, dynamic>>;
      return List<Product>.from(
        data.map((d) => Product.fromMap(d)),
      );
    } else {
      throw ErrorHandler.transformStatusCodeToException(
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }
  }
}
