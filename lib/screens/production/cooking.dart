import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CookingPage extends StatefulWidget {
  @override
  _CookingPageState createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  List<Order> inProductionOrders = [];
  List<Order> completedOrders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch pedidos em produção
      final inProductionResponse = await http.get(
        Uri.parse("http://localhost:8083/production?status=em_producao"),
      );

      // Fetch pedidos concluídos
      final completedResponse = await http.get(
        Uri.parse("http://localhost:8083/production?status=produzido"),
      );

      if (inProductionResponse.statusCode == 200 &&
          completedResponse.statusCode == 200) {
        setState(() {
          inProductionOrders = (jsonDecode(inProductionResponse.body)['data'] as List)
              .map((data) => Order.fromJson(data))
              .toList();

          completedOrders = (jsonDecode(completedResponse.body)['data'] as List)
              .map((data) => Order.fromJson(data))
              .toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao carregar pedidos: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateOrderStatus(String id) async {
    try {
      final response = await http.put(
        Uri.parse("http://localhost:8083/production/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"status": "produzido"}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Produto finalizado com sucesso!")),
        );
        _fetchOrders();
      } else {
        throw Exception("Falha ao atualizar o status: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
      _fetchOrders(); // Atualiza a lista após a mudança
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false, // Opcional: Evita que o botão de voltar apareça automaticamente
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0), // Ajuste o tamanho conforme necessário
          child: Container(
            padding: EdgeInsets.only(top: 8.0),  // Ajuste o valor do padding conforme necessário
            child: TabBar(
              tabs: [
                Tab(text: 'Em produção'),
                Tab(text: 'Concluídos'),
              ],
              labelColor: Color(0xFF996536),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF996536),
            ),
          ),
        ),
      ),

      body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            // Aba "Em produção"
            ListView.builder(
              itemCount: inProductionOrders.length,
              itemBuilder: (context, index) {
                final order = inProductionOrders[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(order.product.name),
                    subtitle: Text('Quantidade: ${order.quantity}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _updateOrderStatus(order.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC4A580),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Finalizar produto'),
                    ),
                  ),
                );
              },
            ),
            // Aba "Concluídos"
            ListView.builder(
              itemCount: completedOrders.length,
              itemBuilder: (context, index) {
                final order = completedOrders[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(order.product.name),
                    subtitle: Text('Quantidade: ${order.quantity}'),
                    trailing: IconButton(
                      icon: Icon(Icons.print),
                      onPressed: () {
                        print('Gerando código de barras para: ${order.product.name}');
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Classe para representar uma ordem
class Order {
  final String id;
  final Product product;
  final int quantity;
  final String requestDate;
  final String status;

  Order({
    required this.id,
    required this.product,
    required this.quantity,
    required this.requestDate,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      requestDate: json['request_date'],
      status: json['status'],
    );
  }
}

// Classe para representar um produto
class Product {
  final String id;
  final String name;

  Product({required this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
    );
  }
}
