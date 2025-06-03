import 'package:flutter/material.dart';

import '../../services/validator_service.dart';
import 'input_decoration.dart';

enum TextFieldType {
  text,
  url,
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    required this.label,
    this.multiline = false,
    this.required = true,
    this.type = TextFieldType.text,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool required;
  final bool multiline;
  final TextFieldType type;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      minLines: multiline ? 5 : null,
      maxLines: multiline ? null : 1,
      decoration: buildInputDecoration(
        colorScheme: colorScheme,
        label: label,
      ),
      validator: (String? value) {
        final isRequired = ValidatorService.isRequired(value);

        if (required && isRequired != null) {
          return isRequired;
        }

        if (type == TextFieldType.url) {
          final isUrl = ValidatorService.isUrl(value);

          if (isUrl != null) {
            return isUrl;
          }
        }

        return null;
      },
    );
  }
}
