import 'package:assignment_01/models/current_weather.dart';
import 'package:assignment_01/services/weather_api.dart' as weather_api;

void main(List<String> arguments) async {
  final data = await weather_api.getWeatherForCity(city: 'Edmonton');
  final weather = CurrentWeather.fromJson(data);

  print(weather);
}
