import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupportTicketScreen extends StatefulWidget {
  @override
  _SupportTicketScreenState createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  String _issueDescription = '';

  Future<void> _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      // Stuur data naar de backend
      var response = await http.post(
        Uri.parse('https://jouwbackend/api/tickets'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'description': _issueDescription,
        }),
      );

      if (response.statusCode == 200) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket succesvol ingediend')),
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij het indienen van ticket')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Ticket'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
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
                child: Text('Dien Ticket In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
