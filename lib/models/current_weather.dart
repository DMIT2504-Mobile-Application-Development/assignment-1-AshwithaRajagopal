class CurrentWeather {
  String _city;
  String _description;
  double _currentTemp;
  DateTime _currentTime;
  DateTime _sunrise;
  DateTime _sunset;

  // Getters
  String get city => _city;
  String get description => _description;
  double get currentTemp => _currentTemp;
  DateTime get currentTime => _currentTime;
  DateTime get sunrise => _sunrise;
  DateTime get sunset => _sunset;

  // Setters
  set city(String value) {
    if (value.isEmpty) throw Exception('City cannot be empty');
    _city = value;
  }

  set description(String value) {
    if (value.isEmpty) throw Exception('Description cannot be empty');
    _description = value;
  }

  set currentTemp(double value) {
    if (value < -100 || value > 100) throw Exception('Temperature must be between -100 and 100');
    _currentTemp = value;
  }

  set currentTime(DateTime value) {
    if (value.isAfter(DateTime.now())) throw Exception('Current time cannot be in the future');
    _currentTime = value;
  }

  set sunrise(DateTime value) {
    if (!_isSameDay(value, _currentTime)) {
      throw Exception('Sunrise must be on the same day as current time');
    }
    if (_sunset != null && value.isAfter(_sunset)) {
      throw Exception('Sunrise cannot be after sunset');
    }
    _sunrise = value;
  }

  set sunset(DateTime value) {
    if (!_isSameDay(value, _currentTime)) {
      throw Exception('Sunset must be on the same day as current time');
    }
    if (_sunrise != null && value.isBefore(_sunrise)) {
      throw Exception('Sunset cannot be before sunset');
    }
    _sunset = value;
  }

  // Helper
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Constructor
  CurrentWeather({
    required String city,
    required String description,
    required double currentTemp,
    required DateTime currentTime,
    required DateTime sunrise,
    required DateTime sunset,
  })  : _city = city,
        _description = description,
        _currentTemp = currentTemp,
        _currentTime = currentTime,
        _sunrise = sunrise,
        _sunset = sunset;

  // Factory constructor
  factory CurrentWeather.fromJson(dynamic data) {
    return CurrentWeather(
      city: data['name'],
      description: data['weather'][0]['description'],
      currentTemp: data['main']['temp'].toDouble(),
      currentTime: DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000, isUtc: true),
      sunrise: DateTime.fromMillisecondsSinceEpoch(data['sys']['sunrise'] * 1000, isUtc: true),
      sunset: DateTime.fromMillisecondsSinceEpoch(data['sys']['sunset'] * 1000, isUtc: true),
    );
  }


  @override
  String toString() {
    return 'City: $_city, Description: $_description, Current Temperature: $_currentTemp, '
        'Current Time: $_currentTime, Sunrise: $_sunrise, Sunset: $_sunset';
  }
}
