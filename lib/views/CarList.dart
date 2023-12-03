import 'package:flutter/material.dart';
import 'CarScreen.dart';
import '../helpers/ApiService.dart';
import '../helpers/StorageHelper.dart';
import 'package:mobileappdev/theme_config.dart';

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  late Future<List<dynamic>> carsFuture;
  final ApiService _apiService = ApiService();
  final StorageHelper _storageHelper = StorageHelper();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    carsFuture = fetchCarData();
  }

  Future<List<dynamic>> fetchCarData() async {
    try {
      var cars = await _apiService.fetchCars();
      await _storageHelper.saveCarData(cars);
      return cars;
    } catch (e) {
      // If API call fails, fetch the data from local storage
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Could not fetch data from API, loading from local storage')),
      );
      return await _storageHelper.getCarData();
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      carsFuture = fetchCarData();
    });
  }

  List<dynamic> filterCars(List<dynamic> cars) {
    List<dynamic> filteredCars = cars.where((car) {
      final searchMatch =
          car['brand'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car['model'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (_selectedFilter == 'All') {
        return searchMatch;
      } else {
        return searchMatch && car['fuel'] == _selectedFilter;
      }
    }).toList();
    return filteredCars;
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Zoek auto',
        suffixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButton<String>(
      value: _selectedFilter,
      onChanged: (String? newValue) {
        setState(() {
          _selectedFilter = newValue!;
        });
      },
      items: <String>['All', 'GASOLINE', 'DIESEL', 'ELECTRIC', 'HYBRID']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
        centerTitle: true,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSearchBar(),
                _buildFilterDropdown(),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var cars = filterCars(snapshot.data!);
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  var car = cars[index];
                  return _buildCarCard(car);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCarCard(dynamic car) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image.network(car["image"],
            width: 100, height: 100, fit: BoxFit.cover),
        title: Text(
          '${car["brand"]} ${car["model"]}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle:
            Text('License Plate: ${car["licensePlate"]}\nFuel: ${car["fuel"]}'),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: ThemeConfig.primaryColor),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarScreen(id: car["ID"]),
            ),
          );
        },
      ),
    );
  }
}
