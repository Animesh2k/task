import '../../../../core/network/network.dart';
import '../../../../core/env/env.dart';
import '../../../../core/services/cache_service.dart';

class ImageRepository {
  final ApiInterface _api;
  final LocalCacheService _cache;

  ImageRepository({ApiInterface? api, LocalCacheService? cache})
    : _api = api ?? DioNetwork(),
      _cache = cache ?? LocalCacheService();

  /// Fetches a city skyline image from cache or Unsplash with fallbacks
  Future<ApiResponse<String>> getCityImage({
    required String city,
    required String? state,
    required String? country,
  }) async {
    // 1. Check local cache first (24-hour TTL)
    final cachedImage = await _cache.getCachedCityImage(city);
    if (cachedImage != null && cachedImage.isNotEmpty) {
      return ApiResponse.success(cachedImage);
    }

    // 2. Cache miss or expired -> Fetch from Unsplash

    // Try most specific: {city}, {state}, {country} skyline
    String query = city;
    if (state != null) query += ', $state';
    if (country != null) query += ', $country';
    query += ' skyline landmark';

    var response = await _fetch(query);
    if (!response.isSuccess || response.data!.isEmpty) {
      // Try city + country
      if (country != null) {
        response = await _fetch('$city, $country skyline landmark');
      }
    }

    if (!response.isSuccess || response.data!.isEmpty) {
      // Try just city
      response = await _fetch('$city skyline landmark');
    }

    if (!response.isSuccess || response.data!.isEmpty) {
      // Final attempt: just city
      response = await _fetch(city);
    }

    // 3. Save to cache if successful
    if (response.isSuccess && response.data!.isNotEmpty) {
      await _cache.saveCityImage(city, response.data!);
    }

    return response;
  }

  Future<ApiResponse<String>> _fetch(String query) async {
    return _api.get<String>(
      endpoint: 'https://api.unsplash.com/search/photos',
      queryParams: {
        'query': query,
        'orientation': 'landscape',
        'per_page': 1,
        'client_id': Env.unsplashAccessKey,
      },
      converter: (json) {
        final results = json['results'] as List;
        if (results.isNotEmpty) {
          return results[0]['urls']['regular'] as String;
        }
        return '';
      },
    );
  }
}
