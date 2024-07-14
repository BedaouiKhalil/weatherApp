import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubit/get_weather_cubit/get_weather_states.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'dart:developer';

class GetWeatherCubit extends Cubit<WeatherState> {
  GetWeatherCubit() : super(WeatherInitialState());

  late WeatherModel weatherModel;

  Future<void> getWeather({required String cityName}) async {
    try {
      log('Fetching weather for city: $cityName');
      WeatherModel? fetchedWeatherModel =
          await WeatherService(Dio()).getCurrentWeather(cityName: cityName);

      if (fetchedWeatherModel != null) {
        weatherModel = fetchedWeatherModel;
        log('Weather fetched successfully: ${weatherModel.cityName}');
        emit(WeatherLoadedState(weatherModel));
      } else {
        log('WeatherModel is null');
        emit(WeatherFailureState('error no data'));
      }
    } catch (e) {
      log('Error fetching weather kh: $e');
      emit(WeatherFailureState(e.toString()));
    }
  }
}
