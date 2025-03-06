import 'package:flutter/material.dart';

Map<String, dynamic> getArguments(BuildContext context) {
  final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  return arguments ?? {};
}
