import 'package:flutter/material.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import 'package:intl/intl.dart';
import 'package:mobileappdev/theme_config.dart';

class PastRentalsScreen extends StatefulWidget {
  @override
  _PastRentalsScreenState createState() => _PastRentalsScreenState();
}

class _PastRentalsScreenState extends State<PastRentalsScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _rentals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRentals();
  }

  Future<void> _fetchRentals() async {
    try {
      var rentals = await _apiService.fetchRentals();
      setState(() {
        _rentals = rentals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Rentals'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _rentals.length,
              itemBuilder: (context, index) {
                var rental = _rentals[index];
                return _buildRentalCard(rental);
              },
            ),
    );
  }

  Widget _buildRentalCard(dynamic rental) {
    var imageUrl = rental["image"] ?? 'https://via.placeholder.com/150';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: ThemeConfig.primaryColor,
                child: const Icon(
                  Icons.directions_car,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rental Code: ${rental["code"]}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'From: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(rental['fromDate']))} To: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(rental['toDate']))}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${rental["RentalState"]}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
