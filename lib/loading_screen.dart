import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

   void getLocation()async {
    await Geolocator.checkPermission();
   await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    }
  @override
  Widget build(BuildContext context) {
   
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 38, 36, 36),
        body: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/cloud_intro.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  'Discover the Weather in your city',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins-bold',
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),  
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  
                  "Get the latest weather updates and forecasts for your location.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 15,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  getLocation();
                },
                child: Container(
                  margin: EdgeInsets.all(30),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(16),
                    
                    
                  ),
                  child: Center(
                    child: Text("get started",
                      textAlign: TextAlign.center,
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
          ),
        ),
      
      ),
    );
  }
}