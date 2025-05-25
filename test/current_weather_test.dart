import 'package:test/test.dart';
import 'package:assignment_01/models/current_weather.dart';

void main() {
  // Subject under test
  CurrentWeather? sut;

  // Test data
  final city = 'Edmonton';
  final description = 'few clouds';
  final currentTemp = 10.0;
  final currentTime = DateTime.parse('2024-01-01 12:00:00');
  final sunrise = currentTime.subtract(Duration(hours: 4));
  final sunset = currentTime.add(Duration(hours: 4));

  final weatherData = {
    'coord': {'lon': -113.4687, 'lat': 53.5501},
    'weather': [
      {'id': 801, 'main': 'Clouds', 'description': description, 'icon': '02d'}
    ],
    'base': 'stations',
    'main': {
      'temp': currentTemp,
      'feels_like': 28.57,
      'temp_min': 27.65,
      'temp_max': 31.12,
      'pressure': 1004,
      'humidity': 32,
      'sea_level': 1004,
      'grnd_level': 928
    },
    'visibility': 10000,
    'wind': {'speed': 3.6, 'deg': 180},
    'clouds': {'all': 12},
    'dt': currentTime.millisecondsSinceEpoch / 1000,
    'sys': {
      'type': 2,
      'id': 2074442,
      'country': 'CA',
      'sunrise': sunrise.millisecondsSinceEpoch / 1000,
      'sunset': sunset.millisecondsSinceEpoch / 1000
    },
    'timezone': -21600,
    'id': 5946768,
    'name': city,
    'cod': 200
  };

  group('CurrentWeather Class', () {
    test('CurrentWeather named param generative constructor', () {
      sut = CurrentWeather(
          city: city,
          description: description,
          currentTemp: currentTemp,
          currentTime: currentTime,
          sunrise: sunrise,
          sunset: sunset);

      expect(sut!.city, city);
      expect(sut!.description, description);
      expect(sut!.currentTemp, currentTemp);
      expect(sut!.currentTime, currentTime);
      expect(sut!.sunrise, sunrise);
      expect(sut!.sunset, sunset);
    });

    test('CurrentWeather.fromOpenWeatherData factory constructor', () {
      sut = CurrentWeather.fromJson(weatherData);

      expect(sut!.city, city);
      expect(sut!.description, description);
      expect(sut!.currentTemp, currentTemp);
      expect(sut!.currentTime, currentTime);
      expect(sut!.sunrise, sunrise);
      expect(sut!.sunset, sunset);
    });

    group('CurrentWeather member setters', () {
      setUp(() {
        sut = CurrentWeather(
            city: city,
            description: description,
            currentTemp: currentTemp,
            currentTime: currentTime,
            sunrise: sunrise,
            sunset: sunset);
      });
      test('CurrentWeateher.city setter', () {
        expect(() => sut!.city = 'Calgary', returnsNormally);
        expect(sut!.city, 'Calgary');

        // Test that the city setter throws an exception when the city is empty.
        expect(
            () => sut!.city = '',
            throwsA(isA<Exception>().having((exception) => exception.toString(),
                'message', contains('City cannot be empty'))));
      });

      test('CurrentWeateher.description setter', () {
        expect(() => sut!.description = 'clear sky', returnsNormally);
        expect(sut!.description, 'clear sky');

        // Test that the description setter throws an exception when the description is empty.
        expect(
            () => sut!.description = '',
            throwsA(isA<Exception>().having((exception) => exception.toString(),
                'message', contains('Description cannot be empty'))));
      });

      test('CurrentWeather.currentTemp setter', () {
        expect(() => sut!.currentTemp = 0.0, returnsNormally);
        expect(sut!.currentTemp, 0.0);

        // Test that the currentTemp setter throws an exception when the temperature is less than -100.
        expect(
            () => sut!.currentTemp = -101.0,
            throwsA(isA<Exception>().having(
                (exception) => exception.toString(),
                'message',
                contains('Temperature must be between -100 and 100'))));

        // Test that the currentTemp setter throws an exception when the temperature is greater than 100.
        expect(
            () => sut!.currentTemp = 101.0,
            throwsA(isA<Exception>().having(
                (exception) => exception.toString(),
                'message',
                contains('Temperature must be between -100 and 100'))));
      });

      test('CurrentWeather.currentTime setter', () {
        final newTime = DateTime.parse('2024-01-02 12:00:00');

        expect(() => sut!.currentTime = newTime, returnsNormally);
        expect(sut!.currentTime, newTime);

        // Test that the currentTime setter throws an exception when the time is in the future.
        expect(
            () => sut!.currentTime = DateTime.now().add(Duration(days: 1)),
            throwsA(isA<Exception>().having((exception) => exception.toString(),
                'message', contains('Current time cannot be in the future'))));
      });

      test('CurrentWeather.sunrise setter', () {
        final newSunrise = sunset.subtract(Duration(hours: 2));

        expect(() => sut!.sunrise = newSunrise, returnsNormally);
        expect(sut!.sunrise, newSunrise);

        // Test that the sunrise setter throws an exception when the time is in the future.
        expect(
            () => sut!.sunrise = currentTime.add(Duration(days: 1)),
            throwsA(isA<Exception>().having(
                (exception) => exception.toString(),
                'message',
                contains('Sunrise must be on the same day as current time'))));

        // Test that the sunrise setter throws an exception when the sunrise is after the sunset.
        expect(
            () => sut!.sunrise = sunset.add(Duration(minutes: 1)),
            throwsA(isA<Exception>().having((exception) => exception.toString(),
                'message', contains('Sunrise cannot be after sunset'))));
      });

      test('CurrentWeather.sunset setter', () {
        final newSunset = sunrise.add(Duration(hours: 2));

        expect(() => sut!.sunset = newSunset, returnsNormally);
        expect(sut!.sunset, newSunset);

        // Test that the sunset setter throws an exception when the time is in the future.
        expect(
            () => sut!.sunset = currentTime.add(Duration(days: 1)),
            throwsA(isA<Exception>().having(
                (exception) => exception.toString(),
                'message',
                contains('Sunset must be on the same day as current time'))));

        // Test that the sunset setter throws an exception when the sunset is after the sunset.
        expect(
            () => sut!.sunset = sunrise.subtract(Duration(minutes: 1)),
            throwsA(isA<Exception>().having((exception) => exception.toString(),
                'message', contains('Sunset cannot be before sunrise'))));
      });
    });

    test('CurrentWeather.toString method', () {
      sut = CurrentWeather(
          city: city,
          description: description,
          currentTemp: currentTemp,
          currentTime: currentTime,
          sunrise: sunrise,
          sunset: sunset);

      final expected =
          'City: $city, Description: $description, Current Temperature: $currentTemp, Current Time: $currentTime, Sunrise: $sunrise, Sunset: $sunset';

      expect(sut.toString(), expected);
    });
  });
}
