import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:weatherapp/models/weather_model.dart';

class WeatherService {
  final Dio dio;
  final String baseUrl = 'http://api.weatherapi.com/v1';
  final String apiKey = '3328b9de4e7d477c84f100002240807';

  WeatherService(this.dio);

  Future<WeatherModel?> getCurrentWeather({required String cityName}) async {
    try {
      log('Requesting weather data for: $cityName');
      Response response = await dio.get('$baseUrl/forecast.json?key=$apiKey&q=$cityName&days=1');

      if (response.data != null) {
        log('Data received: ${response.data}');
        WeatherModel weatherModel = WeatherModel.fromJson(response.data);
        return weatherModel;
      } else {
        log('No data received');
        return null;
      }
    } on DioException catch (e) {
      final String errMessage = e.response?.data['error']['message'] ?? 'oops there was an error bk';
      log('DioException: $errMessage');
      throw Exception(errMessage);
    } catch (e) {
      log('Exception: $e');
      throw Exception('oops there was an error');
    }
  }
}
