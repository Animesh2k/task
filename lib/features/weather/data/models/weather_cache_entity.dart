import 'package:objectbox/objectbox.dart';

@Entity()
class WeatherCache {
  @Id()
  int id = 0;

  @Index()
  @Unique()
  final String locationKey;

  final String cityName;
  final String jsonWeatherData;
  final int timestamp; // Milliseconds since epoch

  WeatherCache({
    this.id = 0,
    required this.locationKey,
    required this.cityName,
    required this.jsonWeatherData,
    required this.timestamp,
  });
}
