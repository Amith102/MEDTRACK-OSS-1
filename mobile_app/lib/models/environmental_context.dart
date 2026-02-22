class EnvironmentalContext {
  final String temperature;
  final String humidity;
  final int aqi;
  final String pollenLevel;

  EnvironmentalContext({
    required this.temperature,
    required this.humidity,
    required this.aqi,
    required this.pollenLevel,
  });

  factory EnvironmentalContext.fromJson(Map<String, dynamic> json) {
    return EnvironmentalContext(
      temperature: json['temperature'] as String? ?? 'Unknown',
      humidity: json['humidity'] as String? ?? 'Unknown',
      aqi: json['aqi'] as int? ?? 0,
      pollenLevel: json['pollenLevel'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'aqi': aqi,
      'pollenLevel': pollenLevel,
    };
  }
}
