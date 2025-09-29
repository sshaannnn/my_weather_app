import 'dart:convert';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(List position) async {
    double lat = position[0] ?? 0;
    double lon = position[1] ?? 0;
    String apiUrl = '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final res = await http.get(Uri.parse(apiUrl));
    print(apiUrl);

    if (res.statusCode == 200) {
      return Weather.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // convert the location into a list of placemark object
    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //   position.latitude,
    //   position.longitude,
    // );

    // print(position.latitude);
    // print(position.longitude);
    // extract the city name from the first placemark
    // String? city = placemarks[0]?.locality;

    return [position.latitude, position.longitude];
  }
}
