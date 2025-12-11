import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/bidet_location.dart';

class BidetForm extends StatefulWidget {
  final Function(BidetLocation) onSubmit;
  const BidetForm({super.key, required this.onSubmit});

  @override
  State<BidetForm> createState() => _BidetFormState();
}

class _BidetFormState extends State<BidetForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  Uint8List? imageBytes;

  final ImagePicker picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final bidet = BidetLocation(
        name: _nameController.text,
        lat: double.parse(_latController.text),
        lng: double.parse(_lngController.text),
        imageBytes: imageBytes,
      );
      widget.onSubmit(bidet);
      Navigator.pop(context); // close form after submit
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Building / Place Name'),
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _latController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _lngController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Upload Image'),
            ),
            if (imageBytes != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.memory(
                  imageBytes!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit Bidet'),
            ),
          ],
        ),
      ),
    );
  }
}
