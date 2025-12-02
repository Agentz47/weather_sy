import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hint, border: const OutlineInputBorder()),
      onSubmitted: (_) => onSubmitted?.call(),
      onChanged: onChanged,
    );
  }
}
