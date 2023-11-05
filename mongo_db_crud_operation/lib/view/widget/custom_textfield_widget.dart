import 'package:flutter/material.dart';

class CustomTextfieldWidget extends StatelessWidget {
  const CustomTextfieldWidget(
      {super.key, required this.controllerField, this.hintText});
  final TextEditingController controllerField;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controllerField,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          hintText: hintText.toString(),
        ),
      ),
    );
  }
}
