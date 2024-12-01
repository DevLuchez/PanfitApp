import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:panfit_app/domain/product.dart';

class ProductSale extends StatefulWidget {
  @override
  _ProductSaleState createState() => _ProductSaleState();
}

class _ProductSaleState extends State<ProductSale> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  TextEditingController? _autocompleteController; // Controlador para o campo do Autocomplete
  List<Product> _products = [];
  Product? _selectedProduct;
  List<Map<String, dynamic>> _orderItems = [];
  bool _isLoading = false;
  String? _errorMessage; // Variável para exibir mensagens de erro
  bool _isAddButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();

    // Adicionar listeners para os campos de texto
    _quantityController.addListener(_updateButtonState);
    _searchController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() => _isLoading = true);
      final response = await Dio().get('http://localhost:8083/product');
      final List<dynamic> data = response.data['data'];
      setState(() {
        _products = data.map((json) => Product.fromJson(json)).toList();
      });
    } catch (e) {
      print('Erro ao buscar produtos: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _updateButtonState() {
    // Verificar se o campo de busca contém algo ou se o produto foi selecionado
    final isSearchNotEmpty = _autocompleteController != null;

    // Verificar se a quantidade é válida
    final isQuantityValid = _quantityController.text.isNotEmpty &&
        int.tryParse(_quantityController.text) != null &&
        int.parse(_quantityController.text) > 0;

    setState(() {
      // O botão será habilitado se houver um produto selecionado ou se o campo de busca não estiver vazio,
      // e a quantidade for válida
      _isAddButtonEnabled = isSearchNotEmpty && isQuantityValid;
    });
  }


  void _addProductToOrder() {
    setState(() {
      _errorMessage = null; // Resetar mensagem de erro
    });

    // Validação de segurança (caso o botão esteja habilitado indevidamente)
    if (_selectedProduct == null) {
      setState(() {
        _errorMessage = "Selecione um produto para vender.";
      });
      return;
    }

    if (_quantityController.text.isEmpty) {
      setState(() {
        _errorMessage = "Insira a quantidade do produto a ser vendido.";
      });
      return;
    }

    // Validar se a quantidade é um número válido e maior que 0
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      setState(() {
        _errorMessage = "A quantidade deve ser maior que zero.";
      });
      return;
    }

    if (_selectedProduct != null && _quantityController.text.isNotEmpty) {
      // Verificar se o produto já está na lista
      final isProductInOrder = _orderItems.any(
            (item) => (item['product'] as Product).id == _selectedProduct!.id,
      );

      if (isProductInOrder) {
        // Exibir mensagem de erro
        setState(() {
          _errorMessage =
          "O produto '${_selectedProduct!.name}' já foi adicionado na lista de vendas.";
        });
        return;
      }

      // Caso não esteja duplicado, adicionar à lista
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      if (quantity > 0) {
        setState(() {
          _orderItems.add({
            'product': _selectedProduct!,
            'quantity': quantity,
            // TODO - Quando o back aceitar o atributo de preço do produto, alterar para que este possa ser utilizado
            //'subtotal': _selectedProduct!.sale_price * quantity,
            'subtotal': 20.90 * quantity,
          });
          _selectedProduct = null;
          _searchController.clear();// TODO - Corrigir limpa da barra de pesquisa
          _quantityController.clear();
          _autocompleteController?.clear();
          _errorMessage = null; // Limpar mensagem de erro
          _isAddButtonEnabled = false;
        });
      }
    }
  }

  double _getTotalPrice() {
    return _orderItems.fold(0, (sum, item) => sum + item['subtotal']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Venda de Produtos',
          style: TextStyle(
            color: Color(0xFF996536),
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Autocomplete<Product>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<Product>.empty();
                          }
                          return _products.where((Product product) {
                            return product.name
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        displayStringForOption: (Product product) => product.name,
                        onSelected: (Product product) {
                          setState(() {
                            _selectedProduct = product;
                            _errorMessage = null;
                          });
                        },
                        fieldViewBuilder: (context, textEditingController, focusNode, onEditingComplete) {
                          _autocompleteController = textEditingController; // Salva a referência do controlador

                          textEditingController.addListener(() {
                            _searchController.text = textEditingController.text;
                          });
                          return Container(
                            width: 360,
                            child: TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFF996536)
                                ),
                                filled: true,
                                fillColor: Color(0xFFF4E9DA),
                                labelText: 'Buscar produtos',
                                labelStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF996536)
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color(0xFF996536),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              onChanged: (_) {
                                setState(() {
                                  _errorMessage = null; // Limpar erro ao digitar
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantidade',
                          filled: true,
                          fillColor: Color(0xFFF4E9DA),
                          labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Color(0xFF996536)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF996536),
                              width: 1.0,
                            ),
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {
                            _errorMessage = null; // Limpar erro ao digitar
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isAddButtonEnabled ? _addProductToOrder : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF996536),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Adicionar',
                        style: TextStyle(
                            fontFamily: 'Poppins'
                        ),
                      ),
                    ),
                  ],
                ),
                if (_errorMessage != null) // Exibir mensagem de erro condicionalmente
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.red,
                          fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _orderItems.length,
              itemBuilder: (context, index) {
                final item = _orderItems[index];
                final product = item['product'] as Product;
                final quantity = item['quantity'] as int;
                final subtotal = item['subtotal'] as double;

                return ListTile(
                  title: Text('${product.name} (x$quantity)'),
                  subtitle: Text('Subtotal: R\$ ${subtotal.toStringAsFixed(2).replaceAll('.', ',')}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Color(0xFFE07B74),),
                    onPressed: () {
                      setState(() {
                        _orderItems.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: R\$ ${_getTotalPrice().toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    color: Color(0xFF528533),
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => _orderItems.clear());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF528533),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Finalizar Venda',
                    style: TextStyle(
                        fontFamily: 'Poppins'
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
