import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiKey = 'e92f0d38182a4e3abf3100935250406';

class WeatherApiService {
  final String baseUrl = "https://api.weatherapi.com/v1";

  Future<Map<String, dynamic>> getHourlyForecast(String location) async {
    final url =
        Uri.parse("$baseUrl/forecast.json?key=$apiKey&q=$location&days=7");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load hourly forecast");
    }

    final data = json.decode(response.body);
    if (data.containsKey('error')) {
      throw Exception(data['error']['message'] ?? "Invalid location");
    }
    return data;
  }

  Future<List<Map<String, dynamic>>> getSevenDayWeather(String location) async {
    final List<Map<String, dynamic>> pastWeather = [];
    final today = DateTime.now();
    for (int i = 1; i <= 7; i++) {
      final date = today.subtract(Duration(days: i));
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      final url = Uri.parse(
          "$baseUrl/history.json?key=$apiKey&q=$location&dt=$formattedDate");
      final response = await http.get(url);

      if (response.statusCode != 200) {
        final data = json.decode(response.body);

        if (data.containsKey('error')) {
          throw Exception(data['error']['message'] ?? "Invalid location");
        }
        if (data['forecast']?['forecastday'] != null) {
          pastWeather.add(data);
        }
      } else {
        debugPrint('Failed to load past weather data for $formattedDate');
      }
    }

    return pastWeather;
  }
}
