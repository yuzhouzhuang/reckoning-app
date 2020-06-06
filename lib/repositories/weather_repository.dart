import 'dart:async';

import 'package:flutterApp/models/models.dart';
import 'package:flutterApp/repositories/weather_api_client.dart';
import 'package:meta/meta.dart';


class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async {
    final int locationId = await weatherApiClient.getLocationId(city);
    return weatherApiClient.fetchWeather(locationId);
  }
}
