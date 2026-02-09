import 'package:equatable/equatable.dart';

/// Combined weather data for the demo
class WeatherData extends Equatable {
  final String locationKey;
  final String cityName;
  final CurrentWeather current;
  final List<DailyForecast> daily;
  final String? imageUrl;
  final String? state;
  final String? country;

  const WeatherData({
    required this.locationKey,
    required this.cityName,
    required this.current,
    required this.daily,
    this.imageUrl,
    this.state,
    this.country,
  });

  WeatherData copyWith({
    String? locationKey,
    String? cityName,
    CurrentWeather? current,
    List<DailyForecast>? daily,
    String? imageUrl,
    String? state,
    String? country,
  }) {
    return WeatherData(
      locationKey: locationKey ?? this.locationKey,
      cityName: cityName ?? this.cityName,
      current: current ?? this.current,
      daily: daily ?? this.daily,
      imageUrl: imageUrl ?? this.imageUrl,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationKey': locationKey,
      'cityName': cityName,
      'current': current.toJson(),
      'daily': daily.map((x) => x.toJson()).toList(),
      'imageUrl': imageUrl,
      'state': state,
      'country': country,
    };
  }

  factory WeatherData.fromMap(Map<String, dynamic> json) {
    return WeatherData(
      locationKey: json['locationKey'] as String,
      cityName: json['cityName'] as String,
      current: CurrentWeather.fromMap(json['current'] as Map<String, dynamic>),
      daily: (json['daily'] as List)
          .map((x) => DailyForecast.fromMap(x as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    locationKey,
    cityName,
    current,
    daily,
    imageUrl,
    state,
    country,
  ];
}

class CurrentWeather extends Equatable {
  final String weatherText;
  final int weatherIcon;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final bool isDayTime;

  const CurrentWeather({
    required this.weatherText,
    required this.weatherIcon,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.isDayTime,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      weatherText: json['WeatherText'] as String,
      weatherIcon: json['WeatherIcon'] as int,
      isDayTime: json['IsDayTime'] as bool,
      temp: (json['Temperature']['Metric']['Value'] as num).toDouble(),
      feelsLike: (json['RealFeelTemperature']['Metric']['Value'] as num)
          .toDouble(),
      humidity: (json['RelativeHumidity'] as num).toInt(),
      windSpeed: (json['Wind']['Speed']['Metric']['Value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weatherText': weatherText,
      'weatherIcon': weatherIcon,
      'temp': temp,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'isDayTime': isDayTime,
    };
  }

  factory CurrentWeather.fromMap(Map<String, dynamic> json) {
    return CurrentWeather(
      weatherText: json['weatherText'] as String,
      weatherIcon: json['weatherIcon'] as int,
      temp: (json['temp'] as num).toDouble(),
      feelsLike: (json['feelsLike'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      isDayTime: json['isDayTime'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    weatherText,
    weatherIcon,
    temp,
    feelsLike,
    humidity,
    windSpeed,
    isDayTime,
  ];
}

class DailyForecast extends Equatable {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String dayPhrase;
  final int dayIcon;

  const DailyForecast({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.dayPhrase,
    required this.dayIcon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.parse(json['Date'] as String),
      minTemp: (json['Temperature']['Minimum']['Value'] as num).toDouble(),
      maxTemp: (json['Temperature']['Maximum']['Value'] as num).toDouble(),
      dayPhrase: json['Day']['IconPhrase'] as String,
      dayIcon: json['Day']['Icon'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'minTemp': minTemp,
      'maxTemp': maxTemp,
      'dayPhrase': dayPhrase,
      'dayIcon': dayIcon,
    };
  }

  factory DailyForecast.fromMap(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.parse(json['date'] as String),
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      dayPhrase: json['dayPhrase'] as String,
      dayIcon: json['dayIcon'] as int,
    );
  }

  @override
  List<Object?> get props => [date, minTemp, maxTemp, dayPhrase, dayIcon];
}

/// Helper for Geoposition search response
class AccuLocation extends Equatable {
  final String key;
  final String localizedName;
  final String administrativeArea;
  final String country;

  const AccuLocation({
    required this.key,
    required this.localizedName,
    required this.administrativeArea,
    required this.country,
  });

  factory AccuLocation.fromJson(Map<String, dynamic> json) {
    return AccuLocation(
      key: json['Key'] as String,
      localizedName: json['LocalizedName'] as String,
      administrativeArea: json['AdministrativeArea']['LocalizedName'] as String,
      country: json['Country']['LocalizedName'] as String,
    );
  }

  @override
  List<Object?> get props => [key, localizedName, administrativeArea, country];
}
