import 'package:flutter/material.dart';
import 'package:mobileappdev/helpers/ApiService.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final ApiService apiService;

  const ForgotPasswordScreen({super.key, required this.apiService});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  void _resetPassword() async {
    // Call API to send reset link
    await widget.apiService.sendResetPasswordLink(_emailController.text);
    // Show confirmation message or handle errors
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
