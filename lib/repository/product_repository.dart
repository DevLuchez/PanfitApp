import 'package:dio/dio.dart';
import 'package:panfit_app/domain/product.dart';

import 'package:panfit_app/domain/productList.dart';

// Função para buscar produtos do backend
Future<List<Product>> fetchProducts() async {
  try {
    var dio = Dio();
    final response = await dio.get('http://localhost:8083/product');

    if (response.statusCode == 200) {
      var jsonData = response.data;
      if (jsonData != null && jsonData['data'] != null) {
        ProductList productList = ProductList.fromJson(jsonData);
        return productList.products;
      } else {
        throw Exception('Estrutura de resposta inválida');
      }
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  } catch (e) {
    print('Erro: $e');
    throw Exception('Erro na solicitação $e');
  }
}

// Função para salvar um produto no backend
Future<Product> saveProduct(ProductDTO product) async {
  try {
    var dio = Dio();
    final response = await dio.post(
      'http://localhost:8083/product',
      data: product.toJson(),
    );

    if (response.statusCode == 201) {
      var jsonData = response.data;
      if (jsonData != null && jsonData['data'] != null) {
        return Product.fromJson(jsonData['data']);
      } else {
        throw Exception('Estrutura de resposta inválida');
      }
    } else {
      throw Exception('Falha ao salvar produto');
    }
  } catch (e) {
    print('Erro: $e');
    throw Exception('Erro na solicitação $e');
  }
}


// Função para excluir um produto do backend
Future<bool> deleteProduct(String productId) async {
  try {
    var dio = Dio();
    final response = await dio.delete('http://localhost:8083/product/$productId');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Erro ao excluir o produto');
    }
  } catch (e) {
    print('Erro: $e');
    throw Exception('Erro na solicitação $e');
  }
}

// Função para atualizar um produto no backend
Future<Product> updateProduct(String productId, Product updatedProduct) async {
  try {
    var dio = Dio();
    final response = await dio.put(
      'http://localhost:8083/product/$productId',
      data: updatedProduct.toJson(),
    );

    if (response.statusCode == 200) {
      var jsonData = response.data;
      if (jsonData != null && jsonData['data'] != null) {
        return Product.fromJson(jsonData['data']);
      } else {
        throw Exception('Estrutura de resposta inválida');
      }
    } else {
      throw Exception('Falha ao atualizar o produto');
    }
  } catch (e) {
    print('Erro: $e');
    throw Exception('Erro na solicitação $e');
  }
}
