import 'package:flutter/material.dart';

class CustomSearchTextfieldWidget extends StatelessWidget {
  CustomSearchTextfieldWidget({super.key, this.hintText, this.onChanged});

  final String? hintText;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          onChanged!(value);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          hintText: hintText.toString(),
        ),
      ),
    );
  }
}
