import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class ProductRegistrationScreen extends StatefulWidget {
  @override
  _ProductRegistrationScreenState createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final MoneyMaskedTextController _priceController = MoneyMaskedTextController(
    leftSymbol: 'R\$',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  String? _selectedReceipeId;
  List<dynamic> _receipes = [];

  @override
  void initState() {
    super.initState();
    _fetchReceipes();
  }

  Future<void> _fetchReceipes() async {
    try {
      final response = await Dio().get('http://localhost:8083/receipe');
      setState(() {
        _receipes = response.data['data'];
      });
    } catch (e) {
      print('Erro ao buscar receitas: $e');
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate() && _selectedReceipeId != null) {
      // Construindo o JSON
      final productData = {
        "category": _categoryController.text,
        "name": _nameController.text,
        "receipe": _selectedReceipeId,
        "sale_price": _priceController.numberValue,
        // Preço formatado
        "wheight": double.tryParse(_weightController.text) ?? 0.0,
        // Peso convertido
      };

      try {
        // Enviando requisição
        await Dio().post(
          'http://localhost:8083/product',
          options: Options(
            headers: {
              'Content-Type': 'application/json'
            }, // Definindo cabeçalho
          ),
          data: productData,
        );

        // Notificação de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto cadastrado com sucesso!')),
        );

        // Limpando os campos após sucesso
        _formKey.currentState!.reset();
        _nameController.clear();
        _weightController.clear();
        _categoryController.clear();
        _priceController.updateValue(0);
        setState(() {
          _selectedReceipeId = null;
        });
      } catch (e) {
        // Notificação de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar produto: $e')),
        );
      }
    } else {
      // Campos obrigatórios não preenchidos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Produtos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // Campo Nome do produto
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF4E9DA),
                  labelText: 'Nome do produto',
                  labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
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
                validator: (value) => value == null || value.isEmpty
                    ? 'O nome é obrigatório'
                    : null,
              ),
              SizedBox(height: 20),

              // Campo Peso (g)
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF4E9DA),
                  labelText: 'Peso (g)',
                  labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
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
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'O peso é obrigatório'
                    : null,
              ),
              SizedBox(height: 20),

              // Campo Categoria
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF4E9DA),
                  labelText: 'Categoria',
                  labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
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
                validator: (value) => value == null || value.isEmpty
                    ? 'A categoria é obrigatória'
                    : null,
              ),
              SizedBox(height: 20),

              // Campo Preço
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF4E9DA),
                  labelText: 'Preço',
                  labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
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
                keyboardType: TextInputType.number,
                validator: (value) =>
                    _priceController.numberValue <= 0 ? 'Preço inválido' : null,
              ),
              SizedBox(height: 20),

              // Campo de seleção Receita
              DropdownButtonFormField<String>(
                value: _selectedReceipeId,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFF4E9DA),
                  labelText: 'Receita',
                  labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
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
                items: _receipes.map<DropdownMenuItem<String>>((receipe) {
                  return DropdownMenuItem<String>(
                    value: receipe['id'],
                    child: Text(receipe['category']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReceipeId = value;
                  });
                },
                validator: (value) => value == null
                    ? 'Selecionar uma receita é obrigatório'
                    : null,
              ),
              SizedBox(height: 20),
              Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: _submitProduct,
                  child: Text('Cadastrar Produto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF996536),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
