import 'package:flutter/material.dart';

class ClinicPage extends StatelessWidget {
  const ClinicPage({super.key, required this.clinic});

  final Map<String, dynamic> clinic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: clinic['name']),
      body: Center(child: Text(clinic['name'])),
    );
  }
}
