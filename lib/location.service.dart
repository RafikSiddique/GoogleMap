import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? position;

  LocationSettings? locationSettings;

  ///return [Position] when permission is allowed or throws [Exception]

  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {



        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Fluttertoast.showToast(msg: "Location Permission is denied");
          throw Exception("Location Permission is denied");
        }
      }
      if (permission == LocationPermission.deniedForever) {
        
 


        Geolocator.openLocationSettings().then((value) async {
          if (value) {
            position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );
          }
        });
        throw Exception("Location Permission is deniedforever");
      }
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        debugPrint("LOCATION ==> ${position!.toJson()}");
      } else {
        throw Exception("Location Permission is denied");
      }

      return position;
    } catch (e)
     {
      rethrow;
    }
  }

  Future<String> getCurrentAddress(
      {required double latitude,
      required double longitude,
      String localeIdentifier = "en"}) async {
    try {
      String address;
      List<Placemark> placemark = await placemarkFromCoordinates(
        latitude,
        longitude,
        localeIdentifier: localeIdentifier,
      );

      if (placemark.isNotEmpty) {
        address =
            "${placemark[1].thoroughfare}${placemark[1].subThoroughfare},${placemark[1].subLocality} ${placemark[1].locality},${placemark[1].administrativeArea},${placemark[1].postalCode},${placemark[1].country}";
      } else {
        throw Exception('unable to get address');
      }
      debugPrint("ADRESS ==> $address");
      return address;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> openSettings() async {
    bool isOpened = await Geolocator.openLocationSettings();

    return isOpened;
  }
}
