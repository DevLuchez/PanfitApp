import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panfit_app/domain/item.dart';
import 'package:panfit_app/repository/item_repository.dart';
import 'ProductionRequestScreen.dart';

class InputRegisterPage extends StatefulWidget {
  @override
  _InputRegisterPageState createState() => _InputRegisterPageState();
}

class _InputRegisterPageState extends State<InputRegisterPage> {
  // Campos controladores para os inputs do formulário
  final _nameController = TextEditingController();
  final _gtinController = TextEditingController();
  final _weightController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    String dataAtual = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Ingredientes',
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Imagem do insumo
            Center(
              child: Container(
                width: 200,
                height: 200,
                color: Colors.grey[300],
                child: Icon(Icons.image, size: 50, color: Colors.white),
              ),
            ),
            SizedBox(height: 40),

            // Campo Nome do Insumo
            TextField(
              controller: _nameController, // Armazena o valor do nome
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'Nome do insumo',
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
            ),
            SizedBox(height: 20),

            // Campo GTIN
            TextField(
              controller: _gtinController, // Armazena o valor do GTIN
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'GTIN',
                labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
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
                labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Campo Quantidade
            TextField(
              controller: _quantityController, // Controlador de quantidade
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF4E9DA),
                labelText: 'Quantidade',
                labelStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF996536)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Campo Categoria
            DropdownButton<String>(
              value: _selectedCategory.isEmpty ? null : _selectedCategory,
              hint: Text('Selecione a categoria'),
              items: ['Categoria 1', 'Categoria 2', 'Categoria 3'] // Exemplos
                  .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value ?? '';
                });
              },
            ),


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
                    backgroundColor: Color(0xFFE07B74),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(50, 60),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    // Navegar para a tela de cadastro de insumos
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductionRequestScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: Text('Código de Barras', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAA7845),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(180, 60),
                  ),
                ),

                // Botão Salvar insumo
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty &&
                        _gtinController.text.isNotEmpty &&
                        _weightController.text.isNotEmpty &&
                        _quantityController.text.isNotEmpty &&
                        _selectedCategory.isNotEmpty) {
                      try {
                        final itemDTO = ItemDTO(
                          name: _nameController.text,
                          GTIN: _gtinController.text,
                          wheight: double.tryParse(_weightController.text) ?? 0.0,
                          quantity: int.tryParse(_quantityController.text) ?? 1,
                          category: _selectedCategory,
                        );

                        // Chama o método saveItem do repositório
                        await saveItem(itemDTO);

                        // Exibe mensagem de sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Insumo cadastrado com sucesso!')),
                        );

                        // Retorna à tela anterior
                        Navigator.pop(context);
                      } catch (e) {
                        // Exibe mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao salvar insumo: $e')),
                        );
                      }
                    } else {
                      // Exibe mensagem de validação
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Preencha todos os campos!')),
                      );
                    }
                  },
                  icon: Icon(Icons.save, color: Colors.black),
                  label: Text('Salvar', style: TextStyle(color: Colors.black)),
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
