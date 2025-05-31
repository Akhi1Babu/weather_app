import 'package:flutter/material.dart';
import 'package:weather_app/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var latitude;
  var longitude;
  late Location location;

  String? cityName;
  String? condition;
  double? temperature;
  bool isLoading = false;

  Future<void> getLocationAndWeather() async {
    location = Location();
    await location.getCurrentPosition();
    latitude = location.latitude;
    longitude = location.longitude;

    print('Latitude: $latitude');
    print('Longitude: $longitude');

    if (latitude != null && longitude != null) {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=4d364498874ed339c435a1b8c7490379&units=metric',
      );

      setState(() {
        isLoading = true;
      });

      try {
        final response = await http.get(url);
        print("Status Code: ${response.statusCode}");

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          setState(() {
            cityName = data["name"];
            condition = data["weather"][0]["main"];
            temperature = data["main"]["temp"];
            isLoading = false;
          });

          print('City: $cityName');
          print('Condition: $condition');
          print('Temperature: $temperature');
        } else {
          print('Failed to fetch data');
          setState(() => isLoading = false);
        }
      } catch (e) {
        print('Error: $e');
        setState(() => isLoading = false);
      }
    } else {
      print("Location not available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 38, 36, 36),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/cloud_intro.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 30),
                  if (cityName != null && condition != null && temperature != null)
                    Column(
                      children: [
                        Text(
                          '$cityName',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$condition | ${temperature!.toStringAsFixed(1)}°C',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Tap the button to fetch weather data for your location.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: getLocationAndWeather,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "Get started",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
