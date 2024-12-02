import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Adicionado para requisições HTTP
import 'package:panfit_app/screens/production/register/input_time.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<dynamic> orders = [];
  bool isLoading = true; // Adicionado para indicar o carregamento

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final url =
    Uri.parse('http://localhost:8083/production?status=nao_produzido');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          orders = responseData['data'];
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // Caso o endpoint retorne um erro
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      // Caso haja falha na conexão
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedidos a produzir',
          style: TextStyle(
            color: Color(0xFF996536),
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF996536)))
          : orders.isEmpty
          ? Center(
        child: Text(
          'Nenhum pedido encontrado.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final productName = order['product']['name'];
          final orderId = order['id'];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(productName),
              subtitle: Text('Quantidade: ${order['quantity']}'),
              trailing: ElevatedButton(
                onPressed: () async {
                  // Navega para a página InputTime e espera pelo resultado
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputTime(
                        id: orderId,
                        name: productName,
                      ),
                    ),
                  );
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                    await _fetchOrders(); // Atualiza a lista de pedidos
                  }
                },
                child: Text('Produzir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC4A580),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
