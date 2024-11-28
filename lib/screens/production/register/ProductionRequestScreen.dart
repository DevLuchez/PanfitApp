import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductionRequestScreen extends StatefulWidget {
  @override
  _ProductionRequestScreenState createState() => _ProductionRequestScreenState();
}

class _ProductionRequestScreenState extends State<ProductionRequestScreen> {
  List<dynamic> _products = [];
  String? _selectedProductId;
  TextEditingController _quantityController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8083/product'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _products = data['data'];
        });
      } else {
        _showErrorDialog('Failed to load products.');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  Future<void> _submitProductionRequest() async {
    if (_selectedProductId == null || _quantityController.text.isEmpty) {
      _showErrorDialog('Please select a product and enter the quantity.');
      return;
    }

    final requestBody = {
      "product": _selectedProductId,
      "quantity": int.tryParse(_quantityController.text) ?? 0,
    };

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8083/production'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      setState(() {
        _isSubmitting = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog('Production request submitted successfully.');
      } else {
        _showErrorDialog('Failed to submit production request.');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requisição de produção'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedProductId,
              items: _products.map((product) {
                return DropdownMenuItem<String>(
                  value: product['id'],
                  child: Text(product['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProductId = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Selecione o produto',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitProductionRequest,
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.brown)
                  : Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
