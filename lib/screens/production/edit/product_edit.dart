import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:panfit_app/domain/product.dart'; // Modelo do Produto (certifique-se de ter um arquivo para o modelo do produto)

class ProductEditPage extends StatefulWidget {
  final Product product;

  const ProductEditPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late double wheight;
  late String category;
  late String receipe;

  @override
  void initState() {
    super.initState();
    // Inicializa os campos com os dados do produto passado
    name = widget.product.name;
    wheight = widget.product.wheight;
    category = widget.product.category;
    receipe = widget.product.recipe;
  }

  Future<void> updateProduct() async {
    try {
      var dio = Dio();
      final response = await dio.put(
        'http://localhost:8083/product/${widget.product.id}',
        data: {
          'name': name,
          'wheight': wheight,
          'category': category,
          'receipe': receipe,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Retorna para a tela anterior
      } else {
        throw Exception('Erro ao atualizar o produto');
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o produto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (value) => name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: wheight.toString(),
                decoration: InputDecoration(labelText: 'Peso'),
                keyboardType: TextInputType.number,
                onChanged: (value) => wheight = double.tryParse(value) ?? 0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Peso é obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: category,
                decoration: InputDecoration(labelText: 'Categoria'),
                onChanged: (value) => category = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Categoria é obrigatória';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: receipe,
                decoration: InputDecoration(labelText: 'Receita'),
                onChanged: (value) => setState(() => receipe = value!),
                items: <String>['Receita A', 'Receita B', 'Receita C']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Receita é obrigatória';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateProduct(); // Atualiza o produto
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
