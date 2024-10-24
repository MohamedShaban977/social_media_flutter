import 'dart:async';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';

class LocationUtil {
  const LocationUtil();

  Future<void> getCurrentLocation({
    required Function(LatLng latlng) onLocationGranted,
    Function()? onLocationDenied,
    Function()? onLocationDeniedForever,
    Function()? onLocationServiceDisabled,
  }) async {
    if (Platform.isAndroid || (Platform.isIOS && await Geolocator.isLocationServiceEnabled())) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (onLocationDenied != null) {
          onLocationDenied();
        }
      } else if (permission == LocationPermission.deniedForever) {
        if (onLocationDeniedForever != null) {
          onLocationDeniedForever();
        }
      } else {
        if ((Platform.isAndroid && await Geolocator.isLocationServiceEnabled()) || Platform.isIOS) {
          var position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
          onLocationGranted(
            LatLng(
              position.latitude,
              position.longitude,
            ),
          );
        } else {
          logger.i(
            'Location service is disabled',
          );
          if (onLocationServiceDisabled != null) {
            await onLocationServiceDisabled();
          }
        }
      }
      logger.i(
        'Location permission is $permission',
      );
    } else {
      logger.i(
        'Location service is disabled',
      );
      if (onLocationServiceDisabled != null) {
        await onLocationServiceDisabled();
      }
    }
  }

  Future<StreamSubscription<ServiceStatus>?> openLocationSettings({
    required Function(LatLng latlng) onAndroidLocationServiceEnabled,
    required Function() onIOSLocationServiceEnabled,
    Function()? onLocationServiceDisabled,
  }) async {
    StreamSubscription<ServiceStatus>? locationServiceStatusStreamSubscription;
    var isOpened = await Geolocator.openLocationSettings();
    if (isOpened) {
      locationServiceStatusStreamSubscription = Geolocator.getServiceStatusStream().listen(
        (ServiceStatus status) async {
          if (status == ServiceStatus.enabled) {
            if (Platform.isAndroid) {
              var position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high,
              );
              var latLng = LatLng(
                position.latitude,
                position.longitude,
              );
              onAndroidLocationServiceEnabled(latLng);
            } else {
              onIOSLocationServiceEnabled();
            }
          } else {
            if (onLocationServiceDisabled != null) {
              onLocationServiceDisabled();
            }
          }
        },
      );
    }
    return locationServiceStatusStreamSubscription;
  }

  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  static Future<void> cancelLocationServiceListener({
    required StreamSubscription<ServiceStatus> locationServiceStatusStreamSubscription,
    Function(String error)? onError,
  }) async {
    await locationServiceStatusStreamSubscription.cancel().onError(
      (error, stackTrace) {
        logger.i(
          error.toString(),
        );
        if (onError != null) {
          onError(
            error.toString(),
          );
        }
      },
    );
  }

  Future<Placemark?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placeMarks[0];
      logger.i(place);
      return place;
    } catch (e) {
      logger.e('place mark $e ');
      return null;
    }
  }
}
