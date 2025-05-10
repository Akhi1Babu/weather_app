import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 38, 36, 36),
        body: Expanded(
          child: Column(
            children: [
              Image.asset(
                'images/cloud_intro.png',
                height: 200,
                width: 200,
              ),
              Container(
                child: const Text(
                  'Discover the Weather in your city',
                  style: TextStyle(
                    fontFamily: 'Poppins-bold',
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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