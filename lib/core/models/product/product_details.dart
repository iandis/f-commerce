import 'dart:convert' show json;

import 'package:flutter/foundation.dart' show listEquals;

import 'product.dart';

class ProductDetails {

  const ProductDetails({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.material,
    required this.availableColors,
    required this.images,
  });

  final int id;
  final String name;
  final double price;
  final String description;
  final String material;
  final List<String> availableColors;

  /// Contains 3 images, the first one is always the placeholder
  final List<String> images;

  Product toProduct() => Product(
    id: id,
    name: name,
    price: price,
    image: images.first,
  );

  factory ProductDetails.fromMap(Map<String, dynamic> map) {
    return ProductDetails(
      id: map['id'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      material: map['material'] as String,
      availableColors: List<String>.from(map['available_colors'] as List),
      images: List<String>.from(map['images'] as List),
    );
  }

  factory ProductDetails.fromJson(String source) =>
      ProductDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductDetails(id: $id, name: $name, price: $price, description: $description, material: $material, available_colors: $availableColors, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductDetails &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.description == description &&
        other.material == material &&
        listEquals(other.availableColors, availableColors) &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        price.hashCode ^
        description.hashCode ^
        material.hashCode ^
        availableColors.hashCode ^
        images.hashCode;
  }
}
