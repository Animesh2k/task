import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../../core/network/network.dart';
import '../../../../core/env/env.dart';
import '../../../../core/services/objectbox_service.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final ApiInterface _api;
  final ObjectBoxService? _database;

  WeatherRepository({ApiInterface? api, ObjectBoxService? database})
    : _api = api ?? DioNetwork(),
      _database = database;

  /// Step 1: Get Location Key from coordinates
  Future<ApiResponse<AccuLocation>> getLocationKey(
    double lat,
    double lon,
  ) async {
    return _api.get<AccuLocation>(
      endpoint: '/locations/v1/cities/geoposition/search',
      queryParams: {'apikey': Env.accuWeatherApiKey, 'q': '$lat,$lon'},
      converter: (json) => AccuLocation.fromJson(json),
    );
  }

  /// Step 2: Get Current Conditions
  Future<ApiResponse<CurrentWeather>> getCurrentConditions(
    String locationKey,
  ) async {
    return _api.get<CurrentWeather>(
      endpoint: '/currentconditions/v1/$locationKey',
      queryParams: {'apikey': Env.accuWeatherApiKey, 'details': 'true'},
      converter: (json) {
        if (json is List && json.isNotEmpty) {
          return CurrentWeather.fromJson(json.first as Map<String, dynamic>);
        }
        return CurrentWeather.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  /// Step 3: Get 5-Day Forecast
  Future<ApiResponse<List<DailyForecast>>> getDailyForecast(
    String locationKey,
  ) async {
    return _api.get<List<DailyForecast>>(
      endpoint: '/forecasts/v1/daily/5day/$locationKey',
      queryParams: {'apikey': Env.accuWeatherApiKey, 'metric': 'true'},
      converter: (json) {
        final forecasts = json['DailyForecasts'] as List;
        return forecasts
            .map((e) => DailyForecast.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  /// Combined call for the Bloc with 1-hour TTL Caching
  Future<ApiResponse<WeatherData>> getFullWeather(
    double lat,
    double lon, {
    bool forceRefresh = false,
  }) async {
    try {
      // 1. Get Key (Always needed or could be cached too, but key depends on lat/lon)
      final locationRes = await getLocationKey(lat, lon);
      if (locationRes.isError) return ApiResponse.error(locationRes.error!);
      final location = locationRes.data!;

      // 2. Check Cache if not forcing refresh
      if (!forceRefresh && _database != null) {
        final cached = _database.getWeather(location.key);
        if (cached != null) {
          debugPrint(
            '📦 [CACHE] Fresh weather data found for ${location.localizedName} (Key: ${location.key})',
          );
          final data = WeatherData.fromMap(jsonDecode(cached.jsonWeatherData));
          return ApiResponse.success(data);
        }
      }

      debugPrint(
        '🌐 [API] Fetching fresh weather data for ${location.localizedName} (Key: ${location.key})',
      );

      // 3. Fetch from API
      final results = await Future.wait([
        getCurrentConditions(location.key),
        getDailyForecast(location.key),
      ]);

      final currentRes = results[0] as ApiResponse<CurrentWeather>;
      final forecastRes = results[1] as ApiResponse<List<DailyForecast>>;

      if (currentRes.isError) return ApiResponse.error(currentRes.error!);
      if (forecastRes.isError) return ApiResponse.error(forecastRes.error!);

      final weatherData = WeatherData(
        locationKey: location.key,
        cityName: location.localizedName,
        state: location.administrativeArea,
        country: location.country,
        current: currentRes.data!,
        daily: forecastRes.data!,
      );

      // 4. Update Cache
      if (_database != null) {
        _database.saveWeather(
          location.key,
          location.localizedName,
          jsonEncode(weatherData.toJson()),
        );
      }

      return ApiResponse.success(weatherData);
    } catch (e) {
      return ApiResponse.errorFromMessage(e.toString());
    }
  }
}
