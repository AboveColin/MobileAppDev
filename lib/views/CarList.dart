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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  double get minExtent => 120; // Adjust these values as needed
  @override
  double get maxExtent => 120;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class _CarListState extends State<CarList> {
  late Future<List<dynamic>> carsFuture;
  final ApiService _apiService = ApiService();
  final StorageHelper _storageHelper = StorageHelper();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedBodyType = 'All';
  final List<String> _bodyTypes = [
    'All',
    'STATIONWAGON',
    'SEDAN',
    'HATCHBACK',
    'MINIVAN',
    'SUV',
    'COUPE',
    'TRUCK',
    'CONVERTIBLE'
  ];

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
      final brandModelMatch =
          car['brand'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              car['model'].toLowerCase().contains(_searchQuery.toLowerCase());
      final fuelMatch =
          _selectedFilter == 'All' || car['fuel'] == _selectedFilter;
      final bodyTypeMatch =
          _selectedBodyType == 'All' || car['body'] == _selectedBodyType;

      return brandModelMatch && fuelMatch && bodyTypeMatch;
    }).toList();
    return filteredCars;
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Car',
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          onChanged: (String? newValue) {
            setState(() {
              _selectedFilter = newValue!;
            });
          },
          items: <String>['All', 'GASOLINE', 'DIESEL', 'ELECTRIC', 'HYBRID']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.grey[700])),
            );
          }).toList(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(15),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildBodyTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBodyType,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          onChanged: (String? newValue) {
            setState(() {
              _selectedBodyType = newValue!;
              _refreshData(); // Refresh data to apply the new filter
            });
          },
          items: _bodyTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.grey[700])),
            );
          }).toList(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(15),
          elevation: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            title: Text('Available Cars'),
            floating: true,
            pinned: true,
            snap: true,
            expandedHeight: 10,
          ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Fuel'),
                          ),
                          _buildFilterDropdown(),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Body Type'),
                          ),
                          _buildBodyTypeDropdown(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // pinned: true,
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<dynamic>>(
              future: carsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  var cars = filterCars(snapshot.data!);
                  return ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      var car = cars[index];
                      return _buildCarCard(car);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(dynamic car) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarScreen(id: car["ID"]),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: car["image"] != null
                  ? Image.network(
                      car["image"],
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 100,
                      color: ThemeConfig.primaryColor,
                      child: const Icon(
                        Icons.directions_car,
                        size: 60,
                        color: ThemeConfig.primaryColor,
                      ),
                    ),
            ),
            // Details section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${car["brand"]} ${car["model"]}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'License Plate: ${car["licensePlate"]}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fuel: ${car["fuel"]}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: €${car["pricePerHour"]}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
