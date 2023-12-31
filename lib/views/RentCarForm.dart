import 'package:flutter/material.dart';
import '../helpers/ApiService.dart';

// Define a custom Form widget.
class RentCarForm extends StatefulWidget {
  RentCarForm({super.key, required this.id});

  final int id;

  @override
  RentCarFormState createState() {
    return RentCarFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class RentCarFormState extends State<RentCarForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return FutureBuilder<Map<String, dynamic>>(
        future: _apiService.fetchRentalsFor(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var rentals = snapshot.data!;
            print(rentals);
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DateRangePickerDialog(
                    currentDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.utc(2023, 31, 12),
                    fieldStartLabelText: "From",
                    fieldEndLabelText: "To",
                    helpText: "Rent car between: ",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
