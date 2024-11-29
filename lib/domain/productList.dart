import 'product.dart';

class ProductList {
  final List<Product> products;

  ProductList({required this.products});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List<dynamic>;
    List<Product> products = list.map((p) => Product.fromJson(p)).toList();
    return ProductList(products: products);
  }
}
