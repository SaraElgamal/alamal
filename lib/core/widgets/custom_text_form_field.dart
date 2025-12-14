import 'package:charity_app/core/widgets/text_form_filed_widget.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hint;
  final bool hasTextAbove;
  final TextInputAction? textInputAction;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.hint,
    this.hasTextAbove = false,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormFieldWidget(
        controller: controller,
        hasTextAbove: hasTextAbove,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        onChanged: onChanged,
        hint: hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        label: label,
        textInputAction: textInputAction,
      ),
    );
  }
}
