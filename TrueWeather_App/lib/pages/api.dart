import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final TextEditingController _searchController = TextEditingController();

class SearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SearchBar({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search City',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  icon: const Icon(Icons.search, color: Color(0xFF4A90E2)),
                ),
                style: const TextStyle(color: Color(0xFF464646)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF4A90E2)),
              onPressed: () {
                final searchText = searchController.text;
                onSearch(searchText);
                FocusScope.of(context).unfocus();
                searchController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdRoute extends StatefulWidget {
  const ThirdRoute({Key? key}) : super(key: key);

  @override
  _ThirdRouteState createState() => _ThirdRouteState();
}

class _ThirdRouteState extends State<ThirdRoute> {
  final TextEditingController _searchController = TextEditingController();
  String city = 'Kigali';
  String weatherIconUrl = 'https://openweathermap.org/img/wn/01d@2x.png';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserLocationFromFirestore();
  }

  Future<void> _getUserLocationFromFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        QuerySnapshot userLocationSnapshot = await FirebaseFirestore.instance
            .collection("location")
            .where("UserId", isEqualTo: currentUser.uid)
            .get();

        if (userLocationSnapshot.docs.isNotEmpty) {
          var docData = userLocationSnapshot.docs.first.data();
          String fetchedCity =
              (docData as Map<String, dynamic>)["location"] as String? ??
                  'Nairobi';
          setState(() {
            city = fetchedCity;
          });
        }
      }
    } catch (e) {
      print('Error fetching location from Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF87CEEB),
              const Color(0xFFB0E0E6),
              const Color(0xFFADD8E6),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 100,
              floating: false,
              pinned: false,
            ),
            SliverToBoxAdapter(
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: SearchBar(
                  searchController: _searchController,
                  onSearch: (searchText) {
                    setState(() {
                      city = searchText;
                    });
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchCityData(city),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No data available',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    final locationData = snapshot.data!;
                    final latitude = locationData["lat"];
                    final longitude = locationData["lon"];
                    final cityName = locationData["name"];

                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchWeatherData(latitude, longitude),
                      builder: (context, weatherSnapshot) {
                        if (weatherSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                          );
                        } else if (!weatherSnapshot.hasData ||
                            weatherSnapshot.data == null) {
                          return const Center(
                            child: Text(
                              'No weather data available',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          final weatherData = weatherSnapshot.data!;
                          final weatherDescription =
                              weatherData["text"] ?? 'Weather description N/A';
                          final weatherIcon = weatherData["Icon"] ?? '01d';
                          print(weatherIcon);
                          final temp = weatherData["temp"] ?? 0;
                          final celsiusTemp = (temp - 273.15).toInt();
                          weatherIconUrl =
                              'https://openweathermap.org/img/wn/$weatherIcon@4x.png';

                          return Container(
                            margin: const EdgeInsets.all(24),
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.room,
                                      size: 27.0,
                                      color: Color(0xFF4A90E2),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(
                                        cityName,
                                        style: const TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF464646),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.network(
                                  weatherIconUrl,
                                  width: 200.0,
                                  height: 100.0,
                                ),
                                const SizedBox(height: 20.0),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 100.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF464646),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '$celsiusTemp',
                                        style: const TextStyle(
                                          fontSize: 120.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF464646),
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '°C',
                                        style: TextStyle(
                                          fontSize: 50.0,
                                          color: Color(0xFF9E9E9E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4A90E2)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    weatherDescription,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4A90E2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF4A90E2),
          unselectedItemColor: const Color(0xFF9E9E9E),
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (_currentIndex == 0) {
                Navigator.pushNamed(context, '/home');
              } else if (_currentIndex == 1) {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login');
              }
            });
          },
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchCityData(String city,
    {http.Client? client}) async {
  client ??= http.Client();
  const apiKey = 'be5a05dee1eb79acf6457d04817d0300';
  print(apiKey);
  final response = await http.get(Uri.parse(
    'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=2&appid=$apiKey',
  ));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      final location = data[0];
      return {
        "name": location["name"],
        "lat": location["lat"],
        "lon": location["lon"],
        "country": location["country"],
        "state": location["state"],
      };
    }
  }
  throw Exception('Failed to load weather data');
}

Future<Map<String, dynamic>> fetchWeatherData(double latitude, double longitude,
    {http.Client? client}) async {
  client ??= http.Client();
  const apiKey = 'be5a05dee1eb79acf6457d04817d0300';
  final response = await http.get(Uri.parse(
    'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey',
  ));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      return {
        "city": data["name"],
        "text": data["weather"][0]["description"],
        "Icon": data["weather"][0]["icon"],
        "state": data["state"],
        "pressure": data["main"]["pressure"],
        "humidity": data["main"]["humidity"],
        "temp": data["main"]["temp"],
        "wind-speed": data["wind"]["speed"],
      };
    }
  }
  throw Exception('Failed to load weather data');
}
