import 'package:flutter/material.dart';

class PopUp extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PopUp({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text('Confirmar'),
        ),
      ],
    );
  }
}
