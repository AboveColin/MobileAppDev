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

  void _toggleFavorite(dynamic car) async {
    print(car);
    bool success = car['is_favorite']
        ? await _apiService.removeFavoriteCar(car['ID'])
        : await _apiService.addFavoriteCar(car['ID']);

    // If successful, update the UI
    if (success) {
      setState(() {
        car['is_favorite'] = !car['is_favorite'];
      });
    }
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
    var themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Car',
          fillColor: themeData.colorScheme.surface,
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
    var themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
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
              child: Text(value,
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            );
          }).toList(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          dropdownColor: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildBodyTypeDropdown() {
    var themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
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
              child: Text(value,
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            );
          }).toList(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          dropdownColor: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          elevation: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
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
                color: themeData.colorScheme.surface,
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
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 100,
                        color: ThemeConfig.primaryColor,
                        child: const Icon(
                          Icons.directions_car,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
              ),

              // Details section with heart icon
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Car details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${car["brand"]} ${car["model"]}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.confirmation_number,
                                size: 14, color: Colors.grey),
                            Text(
                              'License Plate: ${car["licensePlate"]}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.local_gas_station,
                                size: 14, color: Colors.grey),
                            Text(
                              'Fuel: ${car["fuel"]}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.euro,
                                size: 14, color: Colors.grey),
                            Text(
                              'Price: €${car["pricePerHour"]}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    IconButton(
                      icon: Icon(
                        car['is_favorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: car['is_favorite'] ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        _toggleFavorite(car);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
