import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InputTime extends StatefulWidget {
  final String id;
  final String name;

  InputTime({required this.id, required this.name});

  @override
  _InputTimeState createState() => _InputTimeState();
}

class _InputTimeState extends State<InputTime> {
  bool isRunning = false;

  Future<void> _updateProductionStatus() async {
    setState(() {
      isRunning = true;
    });

    try {
      final url = Uri.parse("http://localhost:8083/production/${widget.id}");
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"status": "em_producao"}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context, "Produção iniciada para ${widget.name}");
        }
      } else {
        setState(() {
          isRunning = false;
        });
        _showErrorSnackbar("Falha ao atualizar o status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isRunning = false;
      });
      _showErrorSnackbar("Erro: $e");
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.white))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Iniciar Produção',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      body: Center( // Envolve o Column com Center para centralizar o conteúdo
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Garante que o conteúdo seja ajustado verticalmente
            children: [
              Text(
                '${widget.name}',
                style: TextStyle(fontSize: 20), // Remove o fontWeight.bold
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isRunning ? null : _updateProductionStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: isRunning
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                )
                    : Text(
                  'Iniciar Produção',
                  style: TextStyle(fontSize: 18, color: Colors.brown),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
