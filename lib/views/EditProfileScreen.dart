import 'package:flutter/material.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyP =
      GlobalKey<FormState>(); // New GlobalKey for the password form
  final ApiService _apiService = ApiService();
  final StorageHelper _storageHelper = StorageHelper();
  String? email, firstName, lastName, birthDate, profilePicture;
  String? currentPassword, newPassword, confirmPassword;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() async {
    var userData = await _apiService.fetchCustomer();
    if (userData != null) {
      print(userData);
      setState(() {
        email = userData['email'] ?? '';
        firstName = userData['firstName'] ?? '';
        lastName = userData['lastName'] ?? '';
        birthDate = userData['birthDate'] ?? '';
        profilePicture = userData['profilePicture'] ?? '';
        _isLoading = false;
      });
    }
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool result = await _apiService.updateProfile({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate,
        'profile_picture': profilePicture,
      });

      if (result) {
        // Handle success
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated profile!')),
        );
        await _storageHelper.saveProfileData({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'birthDate': birthDate,
          'profilePicture': profilePicture,
        });
        Navigator.pop(context);
      } else {
        // Handle failure
        // show error to user using SnackBar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update profile')),
        );
      }
    }
  }

  Future<void> _selectBirthDate(BuildContext context, birthDate) async {
    // string to DateTime
    birthDate = DateTime.parse(birthDate);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != birthDate) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  void _changePassword() async {
    if (_formKeyP.currentState!.validate()) {
      _formKeyP.currentState!.save();
      bool result = await _apiService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      await _apiService.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);

      if (result) {
        // Handle success
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated password!')),
        );
        Navigator.pop(context);
      } else {
        // Handle failure
        // show error to user using SnackBar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Update Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: email,
                            decoration: InputDecoration(labelText: 'Email'),
                            onSaved: (value) => email = value ?? '',
                          ),
                          TextFormField(
                            initialValue: firstName,
                            decoration:
                                InputDecoration(labelText: 'First Name'),
                            onSaved: (value) => firstName = value ?? '',
                          ),
                          TextFormField(
                            initialValue: lastName,
                            decoration: InputDecoration(labelText: 'Last Name'),
                            onSaved: (value) => lastName = value ?? '',
                          ),
                          InkWell(
                            onTap: () => _selectBirthDate(context, birthDate),
                            child: IgnorePointer(
                              child: TextFormField(
                                initialValue: birthDate,
                                decoration:
                                    InputDecoration(labelText: 'Birth Date'),
                                onSaved: (value) => birthDate = value ?? '',
                              ),
                            ),
                          ),
                          TextFormField(
                            initialValue: profilePicture,
                            decoration: InputDecoration(
                                labelText: 'Profile Picture URL'),
                            onSaved: (value) => profilePicture = value ?? '',
                          ),
                          ElevatedButton(
                            onPressed: _updateProfile,
                            child: Text('Update Profile'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Password Change Form
                    Form(
                      key: _formKeyP,
                      child: Column(
                        children: [
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Current Password'),
                            obscureText: true,
                            onSaved: (value) => currentPassword = value,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter current password'
                                : null,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'New Password'),
                            obscureText: true,
                            onSaved: (value) => newPassword = value,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter new password'
                                : null,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Confirm New Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please confirm new password';
                              }
                              // if (value != newPassword) {
                              //   print(newPassword!.length);
                              //   return 'Passwords do not match';
                              // }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: _changePassword,
                            child: const Text('Change Password'),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
