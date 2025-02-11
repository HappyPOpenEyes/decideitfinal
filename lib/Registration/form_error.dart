import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormError extends StatelessWidget {
  const FormError({
    required Key key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({required String error}) {
    return Row(
      children: [
        const Icon(Icons.error),
        const SizedBox(
          width: 50,
        ),
        Text(error),
      ],
    );
  }
}