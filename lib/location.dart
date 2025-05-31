
import 'package:geolocator/geolocator.dart';
class Location {
  double? latitude;
  double? longitude;
  
  Future<void> getCurrentPosition() async {
     await Geolocator.checkPermission();
   await Geolocator.requestPermission();
   try{
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,);
      latitude=position.latitude;
      longitude=position.longitude;
      print('Latitude: $latitude');
      print('Longitude: $longitude');
    
  }
  catch (e) {
    print("have an error");
  }
  }


}