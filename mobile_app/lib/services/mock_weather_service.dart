import 'dart:math';
import '../models/environmental_context.dart';

class MockWeatherService {
  /// Simulates an API call to fetch current weather data
  Future<EnvironmentalContext> fetchCurrentConditions() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final random = Random();
    
    // Generate somewhat plausible random data based on Indian summer context
    final temp = 25 + random.nextInt(15); // 25°C to 40°C
    final humidity = 40 + random.nextInt(50); // 40% to 90%
    final aqi = 50 + random.nextInt(250); // 50 to 300 AQI
    
    final pollenLevels = ['Low', 'Moderate', 'High', 'Very High'];
    final pollen = pollenLevels[random.nextInt(pollenLevels.length)];

    return EnvironmentalContext(
      temperature: '${temp}°C',
      humidity: '${humidity}%',
      aqi: aqi,
      pollenLevel: pollen,
    );
  }
}
