import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
// import '../..lib/pages/api.dart'; // Replace with actual file path
import '../../lib/pages/api.dart';
import 'dart:convert';

void main() {
  group('fetchWeatherData', () {
    late http.Client mockClient;

    setUp(() {
      mockClient = MockClient((http.Request request) async {
        final url =
            'https://api.openweathermap.org/data/2.5/weather?lat=40.7128&lon=-74.0060&appid=be5a05dee1eb79acf6457d04817d0300';
        if (request.url.toString() == url) {
          return http.Response(
              jsonEncode({
                "name": "New York",
                "weather": [
                  {"description": "overcast clouds", "icon": "04d"}
                ],
                "main": {
                  "temp": 285.02,
                  "feels_like": 284.14,
                  "temp_min": 282.84,
                  "temp_max": 286.45,
                  "pressure": 1004,
                  "humidity": 72
                },
                "wind": {"speed": 4.1},
              }),
              200);
        } else {
          return http.Response('Weather data not found', 404);
        }
      });
    });

    test('returns weather data for valid coordinates', () async {
      final result =
          await fetchWeatherData(40.7128, -74.0060, client: mockClient);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['city'], 'New York');
      expect(result['text'], 'overcast clouds');
      // Add more assertions as necessary
    });

    // More tests for other scenarios
  });
}
