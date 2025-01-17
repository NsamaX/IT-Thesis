import 'package:flutter/material.dart';

Map<String, dynamic> getArguments(BuildContext context) {
  final arguments = ModalRoute.of(context)?.settings.arguments;
  if (arguments is Map<String, dynamic>) {
    return arguments;
  }
  return {};
}
