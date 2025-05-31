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
  late Location location;
  String? cityName;
  String? condition;
  double? temperature;
  String weatherImage = 'https://cdn-icons-png.flaticon.com/512/1163/1163661.png'; // Default cloud icon
  bool isLoading = false;
  bool showWeatherResult = false; // Track whether to show results or initial screen

  Future<void> getLocationAndWeather() async {
    setState(() => isLoading = true);

    location = Location();
    await location.getCurrentPosition();

    if (location.latitude != null && location.longitude != null) {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=4d364498874ed339c435a1b8c7490379&units=metric',
      );

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          setState(() {
            cityName = data['name'];
            condition = data['weather'][0]['main'];
            temperature = data['main']['temp'];
            weatherImage = getWeatherImageUrl(condition!);
            showWeatherResult = true; // Show the result screen
          });
        } else {
          _showErrorDialog('Failed to fetch weather data. Please try again.');
        }
      } catch (e) {
        _showErrorDialog('Network error. Please check your connection.');
      }
    } else {
      _showErrorDialog('Location not available. Please enable location services.');
    }

    setState(() => isLoading = false);
  }

  String getWeatherImageUrl(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'https://cdn-icons-png.flaticon.com/512/869/869869.png'; // Sun
      case 'clouds':
        return 'https://cdn-icons-png.flaticon.com/512/414/414927.png'; // Clouds
      case 'rain':
        return 'https://cdn-icons-png.flaticon.com/512/3351/3351979.png'; // Rain
      case 'drizzle':
        return 'https://cdn-icons-png.flaticon.com/512/3076/3076135.png'; // Light rain
      case 'snow':
        return 'https://cdn-icons-png.flaticon.com/512/642/642102.png'; // Snow
      case 'thunderstorm':
        return 'https://cdn-icons-png.flaticon.com/512/1146/1146860.png'; // Thunder
      case 'mist':
      case 'fog':
        return 'https://cdn-icons-png.flaticon.com/512/4005/4005901.png'; // Fog
      default:
        return 'https://cdn-icons-png.flaticon.com/512/1163/1163661.png'; // Default cloud
    }
  }

  Color getWeatherBackgroundColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const Color(0xFF87CEEB); // Sky blue
      case 'clouds':
        return const Color(0xFF708090); // Slate gray
      case 'rain':
      case 'drizzle':
        return const Color(0xFF4682B4); // Steel blue
      case 'snow':
        return const Color(0xFFB0C4DE); // Light steel blue
      case 'thunderstorm':
        return const Color(0xFF2F4F4F); // Dark slate gray
      case 'mist':
      case 'fog':
        return const Color(0xFF696969); // Dim gray
      default:
        return const Color.fromARGB(255, 38, 36, 36);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _goBackToStart() {
    setState(() {
      showWeatherResult = false;
      cityName = null;
      condition = null;
      temperature = null;
      weatherImage = 'https://cdn-icons-png.flaticon.com/512/1163/1163661.png';
    });
  }

  Widget _buildInitialScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          weatherImage,
          height: 200,
          width: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              width: 200,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              width: 200,
              child: const Icon(
                Icons.cloud,
                size: 100,
                color: Colors.white,
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: const Text(
            'Discover the Weather in your Location',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins-bold',
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Get the latest weather updates and forecasts for your location.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              fontSize: 16,
              color: Colors.grey[300],
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        GestureDetector(
          onTap: isLoading ? null : getLocationAndWeather,
          child: Container(
            margin: const EdgeInsets.all(30),
            height: 50,
            decoration: BoxDecoration(
              color: isLoading ? Colors.grey : Colors.blue[600],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Get Started",
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildWeatherResultScreen() {
    final backgroundColor = getWeatherBackgroundColor(condition ?? '');
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Back button at the top
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: _goBackToStart,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Weather content
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Image.network(
                  weatherImage,
                  height: 150,
                  width: 150,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      width: 150,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: 150,
                      child: const Icon(
                        Icons.cloud,
                        size: 80,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  cityName ?? 'Unknown Location',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins-bold',
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${temperature?.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  condition ?? 'Unknown',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Refresh button
          GestureDetector(
            onTap: isLoading ? null : getLocationAndWeather,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Refresh Weather",
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: showWeatherResult 
            ? Colors.transparent 
            : const Color.fromARGB(255, 38, 36, 36),
        body: isLoading && !showWeatherResult
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      'Getting your weather...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ],
                ),
              )
            : showWeatherResult 
                ? _buildWeatherResultScreen()
                : _buildInitialScreen(),
      ),
    );
  }
}