import 'package:flutter/material.dart';
import 'package:mobileappdev/helpers/ApiService.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;

  const ResetPasswordScreen({super.key, required this.resetToken});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  String _newPassword = '';

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        bool result =
            await _apiService.resetPassword(widget.resetToken, _newPassword);
        if (result) {
          // Handle success
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset successful')));
          Navigator.pop(context); // Go back to the login screen or home
          Navigator.pop(context); // Go back to the login screen or home
        } else {
          // Handle failure
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset failed')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('An error occurred')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
                onSaved: (value) => _newPassword = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
