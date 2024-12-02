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
  TextEditingController? _autocompleteController;
  List<Product> _products = [];
  Product? _selectedProduct;
  List<Map<String, dynamic>> _orderItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAddButtonEnabled = false;
  String _selectedPaymentType = "pix";

  @override
  void initState() {
    super.initState();
    _fetchProducts();
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
    final isSearchNotEmpty = _autocompleteController != null;
    final isQuantityValid = _quantityController.text.isNotEmpty &&
        int.tryParse(_quantityController.text) != null &&
        int.parse(_quantityController.text) > 0;
    setState(() {
      _isAddButtonEnabled = isSearchNotEmpty && isQuantityValid;
    });
  }

  void _addProductToOrder() {
    setState(() {
      _errorMessage = null;
    });

    if (_selectedProduct == null) {
      setState(() => _errorMessage = "Selecione um produto para vender.");
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 0;
    if (quantity <= 0) {
      setState(() => _errorMessage = "A quantidade deve ser maior que zero.");
      return;
    }

    final isProductInOrder = _orderItems.any(
          (item) => (item['product'] as Product).id == _selectedProduct!.id,
    );

    if (isProductInOrder) {
      setState(() => _errorMessage =
      "O produto '${_selectedProduct!.name}' já foi adicionado na lista de vendas.");
      return;
    }

    setState(() {
      _orderItems.add({
        'product': _selectedProduct!,
        'quantity': quantity,
        'subtotal': _selectedProduct!.sale_price * quantity,
      });
      _selectedProduct = null;
      _searchController.clear();
      _quantityController.clear();
      _autocompleteController?.clear();
      _isAddButtonEnabled = false;
    });
  }

  Future<void> _submitSale() async {
    if (_orderItems.isEmpty) {
      setState(() => _errorMessage = "Adicione produtos à venda antes de finalizar.");
      return;
    }

    try {
      final List<Map<String, dynamic>> products = _orderItems
          .map((item) => {
        'id': (item['product'] as Product).id,
        'quantity': item['quantity']
      })
          .toList();

      final response = await Dio().post('http://localhost:8083/sale', data: {
        'products': products,
        'payment_type': _selectedPaymentType,
      });

      if (response.statusCode == 200) {
        setState(() {
          _orderItems.clear();
          _errorMessage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Venda finalizada com sucesso!")),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = "Erro ao finalizar a venda. Tente novamente.");
      print(e);
    }
  }

  double _getTotalPrice() {
    return _orderItems.fold(0, (sum, item) => sum + item['subtotal']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Venda de Produtos',
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
                          _autocompleteController = textEditingController;
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search, color: Color(0xFF996536)),
                              filled: true,
                              fillColor: Color(0xFFF4E9DA),
                              labelText: 'Buscar produtos',
                              labelStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: Color(0xFF996536),
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
                                borderSide: BorderSide(color: Color(0xFF996536)),
                              ),
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
                          prefixIcon: Icon(Icons.search, color: Color(0xFF996536)),
                          filled: true,
                          fillColor: Color(0xFFF4E9DA),
                          labelText: 'Quantidade',
                          labelStyle: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF996536),
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
                            borderSide: BorderSide(color: Color(0xFF996536)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _isAddButtonEnabled ? _addProductToOrder : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF996536),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Adicionar', style: TextStyle(fontFamily: 'Poppins')),
                    ),
                  ],
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(fontFamily: 'Poppins', color: Colors.red, fontSize: 14),
                    ),
                  ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedPaymentType,
                  items: [
                    DropdownMenuItem(value: "pix", child: Text("Pix")),
                    DropdownMenuItem(value: "credito", child: Text("Crédito")),
                    DropdownMenuItem(value: "debito", child: Text("Débito")),
                    DropdownMenuItem(value: "dinheiro", child: Text("Dinheiro")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentType = value!;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Color(0xFF996536)),
                    filled: true,
                    fillColor: Color(0xFFF4E9DA),
                    labelText: 'Forma de pagamento',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF996536),
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
                      borderSide: BorderSide(color: Color(0xFF996536)),
                    ),
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
                  subtitle: Text('Subtotal: R\$ ${subtotal.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => _orderItems.removeAt(index));
                    },
                  ),
                );
              },
            ),
          ),
          if (_orderItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Total: R\$ ${_getTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF996536),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitSale,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF996536),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      'Finalizar Venda',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
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
