import 'package:flutter/material.dart';
import 'package:panfit_app/screens/production/register/ProductionRequestScreen.dart';
import 'package:panfit_app/domain/item.dart';
import 'package:panfit_app/domain/product.dart';
import 'package:panfit_app/repository/item_repository.dart';
import 'package:panfit_app/repository/product_repository.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List<Item>> futureItems;
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureItems = fetchItems(); // Inicializa a Future para obter os itens cadastrados
    futureProducts = fetchProducts(); // Inicializa a Future para obter os produtos cadastrados
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Opcional: Evita que o botão de voltar apareça automaticamente
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // Ajuste o tamanho conforme necessário
            child: TabBar(
              tabs: [
                Tab(text: 'Ingredientes'),
                Tab(text: 'Produtos'),
              ],
              labelColor: Color(0xFF996536),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF996536),
            ),
          ),
        ),
        body: TabBarView(
          // Listagem dos ingredientes
          children: [
            FutureBuilder<List<Item>>(
              future: futureItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar ingredientes: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum ingrediente encontrado'));
                }

                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final int unitValue = (item.stock_wheight / item.wheight).truncate();
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.category),
                      trailing: Text('Quantidade: $unitValue'),
                    );
                  },
                );
              },
            ),

            // Listagem dos produtos
            FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar produtos: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum produto encontrado'));
                }

                final products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final int unitValue = (product.stock_wheight / product.wheight).truncate();
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.category),
                      trailing: Text('Quantidade: $unitValue'),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Navegar para a tela de cadastro de insumos
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductionRequestScreen(),
              ),
            );

            // Exibir SnackBar com mensagem de sucesso
            if (result != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
            }
          },
          backgroundColor: Color(0xFFF4E9DA),
          child: Icon(Icons.add, color: Color(0xFF996536)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
