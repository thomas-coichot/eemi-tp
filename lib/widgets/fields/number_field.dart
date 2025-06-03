import 'package:flutter/material.dart';

import '../../services/validator_service.dart';
import 'input_decoration.dart';

class NumberField extends StatelessWidget {
  const NumberField({
    required this.controller,
    required this.label,
    this.required = true,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: buildInputDecoration(
        colorScheme: colorScheme,
        label: label,
      ),
      validator: (String? value) {
        final isRequired = ValidatorService.isRequired(value);

        if (required && isRequired != null) {
          return isRequired;
        }

        final regex = RegExp(r'^-?\d+([.,]\d+)?$');
        if (!regex.hasMatch(value!)) {
          return 'Entrez un nombre valide (ex: 12,5)';
        }

        return null;
      },
    );
  }
}
