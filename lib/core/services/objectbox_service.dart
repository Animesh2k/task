import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../features/weather/data/models/weather_cache_entity.dart';
import '../../../objectbox.g.dart'; // Generated file

class ObjectBoxService {
  late final Store store;
  late final Box<WeatherCache> weatherBox;

  ObjectBoxService._create(this.store) {
    weatherBox = Box<WeatherCache>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBoxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'objectbox'));
    return ObjectBoxService._create(store);
  }

  /// Saves weather data to the cache
  void saveWeather(
    String locationKey,
    String cityName,
    String jsonWeatherData,
  ) {
    final query = weatherBox
        .query(WeatherCache_.locationKey.equals(locationKey))
        .build();
    final existing = query.findFirst();
    query.close();

    final cache = WeatherCache(
      id: existing?.id ?? 0,
      locationKey: locationKey,
      cityName: cityName,
      jsonWeatherData: jsonWeatherData,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    weatherBox.put(cache);
  }

  /// Retrieves weather data from cache if it's not expired (1 hour TTL)
  WeatherCache? getWeather(
    String locationKey, {
    Duration ttl = const Duration(hours: 1),
  }) {
    final query = weatherBox
        .query(WeatherCache_.locationKey.equals(locationKey))
        .build();
    final cache = query.findFirst();
    query.close();

    if (cache == null) return null;

    final cachedTime = DateTime.fromMillisecondsSinceEpoch(cache.timestamp);
    final now = DateTime.now();

    if (now.difference(cachedTime) < ttl) {
      return cache;
    }

    return null;
  }

  /// Clears the cache for a specific location
  void clearCache(String locationKey) {
    final query = weatherBox
        .query(WeatherCache_.locationKey.equals(locationKey))
        .build();
    final existing = query.findFirst();
    query.close();

    if (existing != null) {
      weatherBox.remove(existing.id);
    }
  }
}
