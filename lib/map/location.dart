import 'dart:async';

import 'package:closer/api/api_service.dart';
import 'package:closer/const.dart';
import 'package:closer/screens/signin.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

LocationData? currentLocation;

getCurrentLocation() async {
  Location location = Location();
  await location.getLocation().then(
    (location) {
      currentLocation = location;
    },
  );}
late Timer t = Timer(Duration(seconds: 100000), () { });
updateWokerLocationPackground() async {
  t.cancel();
  t = Timer.periodic(Duration(seconds: 25), (timer) async{
      await getCurrentLocation();
      try{
        APIService.userLatLangUpdate(currentLocation!.latitude, currentLocation!.longitude, userData!.content!.id);
        print("Native called background task: "); //simpleTask will be emitted here.
      }catch(e){
        print('object');
      }
    });
}

