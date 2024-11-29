import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/product.dart';
import '../../../repository/product_repository.dart';

class ProductRegisterPage extends StatefulWidget {
  @override
  _ProductRegisterPageState createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  // Controladores para os campos do formulário
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _categoryController = TextEditingController();
  final _recipeController = TextEditingController();
  final _salePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String dataAtual = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Produtos',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color(0xFFAA7845),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagem do produto
            Center(
              child: Container(
                width: 200,
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 40),

            // Campo Nome do Produto
            TextField(
              controller: _nameController, // Armazena o valor do nome
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'Nome do produto',
                labelStyle: TextStyle(color: Color(0xFF996536)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Campo Peso
            TextField(
              controller: _weightController, // Armazena o valor do peso
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'Peso',
                labelStyle: TextStyle(color: Color(0xFF996536)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Campo Categoria
            TextField(
              controller: _categoryController, // Armazena a categoria
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'Categoria',
                labelStyle: TextStyle(color: Color(0xFF996536)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Campo Receita
            TextField(
              controller: _recipeController, // Armazena a receita
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'Receita',
                labelStyle: TextStyle(color: Color(0xFF996536)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Campo Preço de Venda
            TextField(
              controller: _salePriceController, // Armazena o preço de venda
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'Preço de Venda',
                labelStyle: TextStyle(color: Color(0xFF996536)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),


            // Botão Salvar Produto
            // Botões Salvar e Excluir
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Botão Excluir insumo
                ElevatedButton.icon(
                  onPressed: () {
                    // Inserir lógica para excluir
                    // habilitar botão apenas quando for editar o insumo
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text(''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(50, 60),
                  ),
                ),

                // Botão Salvar insumo
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _weightController.text.isNotEmpty &&
                        _categoryController.text.isNotEmpty &&
                        _recipeController.text.isNotEmpty &&
                        _salePriceController.text.isNotEmpty) {
                      try {
                        final productDTO = ProductDTO(
                          name: _nameController.text,
                          weight: double.tryParse(_weightController.text) ?? 0.0,
                          category: _categoryController.text,
                          recipe: _recipeController.text,
                          salePrice: double.tryParse(_salePriceController.text) ?? 0.0,
                        );

                        // Chama o método saveProduct do repositório
                        await saveProduct(productDTO);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Produto cadastrado com sucesso!')),
                        );

                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao salvar produto: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Preencha todos os campos!')),
                      );
                    }
                  },
                  icon: Icon(Icons.save, color: Colors.black),
                  label: Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB8FF8A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(120, 60),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
