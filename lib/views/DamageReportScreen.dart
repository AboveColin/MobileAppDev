// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class DamageReportScreen extends StatefulWidget {
  final int carID;

  const DamageReportScreen({super.key, required this.carID});

  @override
  _DamageReportScreenState createState() => _DamageReportScreenState();
}

class _DamageReportScreenState extends State<DamageReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    setState(() {
      _image = image;
    });
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate() && _image != null) {
      // Implement the logic to send data to the API
      ApiService apiService = ApiService();
      //convert image to blob string
      List<int> imageBytes = await _image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      bool result = await apiService.sendDamageReport(
        description: _descriptionController.text,
        image: base64Image,
        carID: widget.carID,
      );
      if (result) {
        // Handle success
        // show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Damage report submitted successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Handle failure
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Damage'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 10),
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(File(_image!.path)),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              ElevatedButton(
                onPressed: _submitReport,
                child: const Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
