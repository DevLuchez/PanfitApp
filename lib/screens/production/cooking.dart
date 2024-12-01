import 'package:flutter/material.dart';

class CookingPage extends StatefulWidget {
  @override
  _CookingPageState createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {

  //método findAll de produtos com status concluído
  final List<Order> orders = [
    Order(
      imageUrl: '/Users/daniel/Projetos/panfit/front/PanfitApp-Front/assets/boloPanfitChocolate.png',
      title: 'Pão Integral',
      priority: 'Alta',
    ),
    Order(
      imageUrl: '/Users/daniel/Projetos/panfit/front/PanfitApp-Front/assets/boloPanfitMorango.png',
      title: 'Bolo de Cenoura',
      priority: 'Média',
    ),
    // Adicione mais ordens aqui
  ];

  // Lista para controlar a seleção de ordens
   List<bool> _selectedOrders = [];

  @override
  void initState() {
    super.initState();
    // Inicializa a lista de seleções com false
    _selectedOrders = List<bool>.filled(orders.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de abas
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 1),
            TabBar(
              tabs: [
                Tab(text: 'Em produção'),
                Tab(text: 'Concluídos'),
              ],
              labelColor: Color(0xFF996536),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF996536),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Aba "Em produção" com a lista de ordens
                  ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: Text(order.title),
                          subtitle: Text('Tempo restante: ${order.priority}'),
                          secondary: Image.asset(order.imageUrl),
                          value: _selectedOrders[index],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedOrders[index] = value!; // Atualiza o estado
                            });
                          },
                        ),
                      );
                    },
                  ),
                  // Aba "Concluídos" - coloque o conteúdo que desejar aqui
                  ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(order.title),
                          subtitle: Text('Tempo restante: ${order.priority}'),
                          leading: Image.asset(order.imageUrl),
                          trailing: IconButton(
                            icon: Icon(Icons.print),
                            onPressed: () {
                              print('Gerando código de barras para: ${order.title}');
                            },
                          ),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe para representar uma ordem (exemplo)
class Order {
  final String imageUrl;
  final String title;
  final String priority;

  Order({
    required this.imageUrl,
    required this.title,
    required this.priority,
  });
}
