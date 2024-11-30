import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ProductRegistrationScreen extends StatefulWidget {
  @override
  _ProductRegistrationScreenState createState() => _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

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
      print('Error fetching receipes: $e');
    }
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState!.validate() && _selectedReceipeId != null) {
      final productData = {
        "name": _nameController.text,
        "wheight": double.tryParse(_weightController.text) ?? 0.0,
        "category": _categoryController.text,
        "receipe": _selectedReceipeId,
      };

      try {
        await Dio().post(
          'http://localhost:8083/product',
          data: productData,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produto cadastrado com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar produto: $e')),
        );
      }
    } else {
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
                validator: (value) => value == null || value.isEmpty
                    ? 'O nome do produto é obrigatório'
                    : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Peso (g)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'O peso é obrigatório'
                    : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Categoria'),
                validator: (value) => value == null || value.isEmpty
                    ? 'A categoria é obrigatória'
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedReceipeId,
                decoration: InputDecoration(labelText: 'Receita'),
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
              ElevatedButton(
                onPressed: _submitProduct,
                child: Text('Cadastrar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}