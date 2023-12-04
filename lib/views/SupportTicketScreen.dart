// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:mobileappdev/helpers/ApiService.dart';

class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SupportTicketScreenState createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  String _issueDescription = '';
  final ApiService _apiService = ApiService();

  Future<void> _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await _apiService.submitSupportTicket(_issueDescription);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket succesvol ingediend')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fout bij het indienen van ticket')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Beschrijf je probleem',
                ),
                onSaved: (value) {
                  _issueDescription = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Voer een beschrijving in';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitTicket,
                child: const Text('Dien Ticket In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
