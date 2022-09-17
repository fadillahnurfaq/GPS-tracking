import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as locations;

class HomeController with ChangeNotifier {
  // static StreamController<Position> locationController =
  //     StreamController<Position>();
  // static Stream<Position> get locationStream => locationController.stream;
  static ValueNotifier<bool> isLoading = ValueNotifier(true);

  static ValueNotifier<Position?> locationControllerStream =
      ValueNotifier(null);
  static ValueNotifier<Position?> locationControllerCurrent =
      ValueNotifier(null);

  static Future<bool> checkPermision() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw ("DeniedPermissionError");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }

  static Future<void> getContiniousLocation() async {
    if (await checkPermision()) {
      Geolocator.getPositionStream(
              locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.high, distanceFilter: 100))
          .listen((Position position) {
        locationControllerStream.value = position;
      });
      locationControllerStream.notifyListeners();
    }
  }

  static Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    locationControllerCurrent.value = position;
    locationControllerCurrent.notifyListeners();
  }
}
