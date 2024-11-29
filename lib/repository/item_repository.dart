import 'package:dio/dio.dart';
import 'package:panfit_app/domain/item.dart';

import 'package:panfit_app/domain/ItemList.dart';

// Função para ler um item do backend
Future<List<Item>> fetchItems() async {
  try {
    var dio = Dio();
    final response = await dio.get('http://localhost:8083/item');

    if (response.statusCode == 200) {
      var jsonData = response.data;
      if (jsonData != null && jsonData['data'] != null) {
        ItemList itemList = ItemList.fromJson(jsonData);
        return itemList.items;
      } else {
        throw Exception('Estrutura de resposta inválida');
      }
    } else {
      throw Exception('Falha ao carregar itens');
    }
  } catch (e) {
    print('Erro: $e');
    throw Exception('Erro na solicitação $e');
  }
}

// Função para criar um item no backend
Future<Item> saveItem(ItemDTO item) async {
  try {
    var dio = Dio();
    final response = await dio.post('http://localhost:8083/item', data: item.toJson());

    if (response.statusCode == 201) {
      var jsonData = response.data;
      if (jsonData != null && jsonData['data'] != null) {
        Item item = Item.fromJson(jsonData);
        return item;
      } else {
        throw Exception('Estrutura de resposta inválida');
      }
    } else {
      throw Exception('Falha ao carregar itens');
    }
  } catch (e) {
    print('Erro: $e');
    throw Exception('Erro na solicitação $e');
  }
}

// Função para excluir um item do backend
Future<bool> deleteItem(String item_id) async {
  try {
    var dio = Dio();
    final response = await dio.delete('http://localhost:8083/item/$item_id');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Erro ao excluir o item');
    }
  } catch (e) {
    print('Erro: $e');
    throw Exception('Erro na solicitação $e');
  }
}