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

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));

  // Function to show date range picker and handle the result
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      // Other properties...
    );

    if (picked != null &&
        picked != DateTimeRange(start: _startDate, end: _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

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
                  Padding(padding: const EdgeInsets.all(80.0)),
                  ElevatedButton(
                    onPressed: () => _selectDateRange(context),
                    child: Text('Select Date Range'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                          // Send the picked date range to the rentCar method
                          var rented = _apiService.rentCar(widget.id,
                              _startDate.toString(), _endDate.toString());
                          if (await rented) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Car rented successfully')),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Error renting car')),
                            );
                          }
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
