import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/repositories/image_repository.dart';
import '../../../../core/services/location_service.dart';

// Events
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object?> get props => [];
}

class FetchWeatherEvent extends WeatherEvent {
  final bool forceRefresh;
  const FetchWeatherEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

// States
abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {
  final bool isRefreshing;
  final WeatherData? weather;
  final Position? position;

  const WeatherLoading({
    this.isRefreshing = false,
    this.weather,
    this.position,
  });

  @override
  List<Object?> get props => [isRefreshing, weather, position];
}

class WeatherLoaded extends WeatherState {
  final WeatherData weather;
  final Position position;
  final bool isImageLoading;

  const WeatherLoaded(
    this.weather,
    this.position, {
    this.isImageLoading = false,
  });

  @override
  List<Object?> get props => [weather, position, isImageLoading];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;
  final ImageRepository imageRepository;
  final LocationService locationService;

  WeatherBloc({
    required this.repository,
    required this.imageRepository,
    required this.locationService,
  }) : super(WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    WeatherData? previousWeather;
    Position? previousPosition;

    if (state is WeatherLoaded) {
      previousWeather = (state as WeatherLoaded).weather;
      previousPosition = (state as WeatherLoaded).position;
    } else if (state is WeatherLoading) {
      previousWeather = (state as WeatherLoading).weather;
      previousPosition = (state as WeatherLoading).position;
    }

    try {
      // 1. Get current position FIRST to detect if we moved
      final position = await locationService.getCurrentLocation();

      bool locationChanged = false;
      if (previousPosition != null) {
        // If moved more than 500 meters, consider it a location change
        final distance = Geolocator.distanceBetween(
          previousPosition.latitude,
          previousPosition.longitude,
          position.latitude,
          position.longitude,
        );
        if (distance > 500) {
          locationChanged = true;
        }
      }

      // 2. Emit Loading state
      // If location changed, clear the previous weather to show a fresh spinner
      // If it's the same location and a pull-to-refresh, show "isRefreshing" (partial load)
      emit(
        WeatherLoading(
          isRefreshing: !locationChanged && event.forceRefresh,
          weather: locationChanged ? null : previousWeather,
          position: position,
        ),
      );

      // 3. Fetch Weather Data (API or Cache)
      final response = await repository.getFullWeather(
        position.latitude,
        position.longitude,
        forceRefresh: event.forceRefresh,
      );

      if (response.isSuccess) {
        final weatherData = response.data!;

        // Eagerly emit the weather data (don't wait for the city image)
        // Use the old image if it's the same location and we had one
        final initialWeather = weatherData.copyWith(
          imageUrl: !locationChanged ? previousWeather?.imageUrl : null,
        );
        emit(WeatherLoaded(initialWeather, position, isImageLoading: true));

        // 4. Fetch Dynamic Image asynchronously
        final imageRes = await imageRepository.getCityImage(
          city: weatherData.cityName,
          state: weatherData.state,
          country: weatherData.country,
        );

        if (imageRes.isSuccess) {
          emit(
            WeatherLoaded(
              weatherData.copyWith(imageUrl: imageRes.data),
              position,
              isImageLoading: false,
            ),
          );
        } else {
          // If image fails, just emit the weather data (it will fallback to asset in UI)
          emit(WeatherLoaded(weatherData, position, isImageLoading: false));
        }
      } else {
        emit(WeatherError(response.error?.message ?? 'Unknown error'));
      }
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
