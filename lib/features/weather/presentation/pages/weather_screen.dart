import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/repositories/weather_repository.dart';
import '../../data/repositories/image_repository.dart';
import '../bloc/weather_bloc.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/objectbox_service.dart';
import '../../../../i18n/strings.g.dart';

class WeatherScreen extends StatelessWidget {
  final ObjectBoxService database;

  const WeatherScreen({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(
        repository: WeatherRepository(database: database),
        imageRepository: ImageRepository(),
        locationService: LocationService(),
      )..add(const FetchWeatherEvent()),
      child: const WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading && !state.isRefreshing) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is WeatherLoaded ||
              (state is WeatherLoading && state.weather != null)) {
            // Determine which weather data to show
            final weather = (state is WeatherLoaded)
                ? state.weather
                : (state as WeatherLoading).weather!;

            return Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: weather.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: weather.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            'assets/images/weather_bg.png',
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/weather_bg.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          'assets/images/weather_bg.png',
                          fit: BoxFit.cover,
                        ),
                ),
                // Overlay
                Positioned.fill(
                  child: Container(color: Colors.black.withValues(alpha: 0.3)),
                ),
                // Content
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<WeatherBloc>().add(
                        const FetchWeatherEvent(forceRefresh: true),
                      );
                      // Wait for the state to change from loading back to loaded
                      await context.read<WeatherBloc>().stream.firstWhere(
                        (s) => s is WeatherLoaded || s is WeatherError,
                      );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Location Name
                          Text(
                            t.weather.currentLocation,
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            weather.cityName.toUpperCase(),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 60),
                          // Condition Text & Icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getWeatherIcon(weather.current.weatherIcon),
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                weather.current.weatherText.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 4,
                                ),
                              ),
                            ],
                          ),
                          // Temperature
                          Text(
                            '${weather.current.temp.round()}°',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 120,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Stats Row
                          _buildGlassCard(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  Icons.water_drop_outlined,
                                  t.weather.humidity,
                                  '${weather.current.humidity}%',
                                ),
                                _buildStatItem(
                                  Icons.air,
                                  t.weather.wind,
                                  '${weather.current.windSpeed.round()} km/h',
                                ),
                                _buildStatItem(
                                  Icons.thermostat,
                                  t.weather.feelsLike,
                                  '${weather.current.feelsLike.round()}°',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Forecast Section
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              t.weather.fiveDayForecast,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildGlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SizedBox(
                              height: 120,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                itemCount: weather.daily.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 30),
                                itemBuilder: (context, index) {
                                  final day = weather.daily[index];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        index == 0
                                            ? t.weather.today
                                            : DateFormat(
                                                'E d',
                                              ).format(day.date),
                                        style: GoogleFonts.inter(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Icon(
                                        _getWeatherIcon(day.dayIcon),
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${day.maxTemp.round()}°',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<WeatherBloc>().add(
                      const FetchWeatherEvent(forceRefresh: true),
                    ),
                    child: Text(t.weather.tryAgain),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGlassCard({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  IconData _getWeatherIcon(int iconCode) {
    if (iconCode <= 5) {
      return Icons.wb_sunny_outlined;
    } else if (iconCode <= 11) {
      return Icons.wb_cloudy_outlined;
    } else if (iconCode <= 18) {
      return Icons.umbrella_outlined;
    } else if (iconCode <= 29) {
      return Icons.ac_unit;
    } else if (iconCode <= 32) {
      return Icons.air;
    } else if (iconCode <= 38) {
      return Icons.nights_stay_outlined;
    } else if (iconCode <= 44) {
      return Icons.thunderstorm_outlined;
    }
    return Icons.wb_cloudy_outlined;
  }
}
