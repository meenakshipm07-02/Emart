import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  String _location = "Fetching...";
  String get location => _location;

  Future<void> fetchLocation() async {
    _location = "Fetching...";
    notifyListeners();

    try {
      // Check permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _location = "Permission denied";
          notifyListeners();
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _location = "Permission permanently denied";
        notifyListeners();
        return;
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _location = "Please turn location";
        notifyListeners();
        return;
      }

      //  Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      //  Reverse geocode -> city + state
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _location = "${place.locality}, ${place.administrativeArea}";
      } else {
        _location = "Unknown location";
      }
    } catch (e) {
      _location = "Fetching failed";
    }

    notifyListeners();
  }
}
