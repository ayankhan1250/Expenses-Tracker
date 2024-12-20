import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField {
  TextEditingController textController;
  TextInputType textInputController;
  String label;
  List<TextInputFormatter> inputFormat;

  Widget myTextField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: textController,
        keyboardType: textInputController,
        inputFormatters: inputFormat,
        decoration: InputDecoration(
            label: Text(label),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  MyTextField({
    required this.textController,
    this.textInputController = TextInputType.none,
    required this.label,
    required this.inputFormat,
  });
}
