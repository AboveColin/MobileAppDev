import 'package:flutter/material.dart';

class CarScreen extends StatelessWidget {
  const CarScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(id.toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Car $id'),
      ),
    );
  }
}