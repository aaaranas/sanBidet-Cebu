import 'package:flutter/material.dart';
import '../widgets/bidet_form.dart';

class SubmitBidetPage extends StatelessWidget {
  const SubmitBidetPage({super.key, required Null Function(dynamic bidet) onSubmit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit New Bidet')),
      body: BidetForm(
        onSubmit: (bidet) {
          Navigator.pop(context, bidet); // Return bidet to landing page
        },
      ),
    );
  }
}
