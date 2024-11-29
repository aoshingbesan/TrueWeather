import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import '../../lib/pages/api.dart';
import 'dart:convert';

void main() {
  group('fetchCityData', () {
    late http.Client mockClient;

    setUp(() {
      mockClient = MockClient((http.Request request) async {
        if (request.url.toString() ==
            'http://api.openweathermap.org/geo/1.0/direct?q=Nairobi&limit=2&appid=your_api_key') {
          return http.Response(
              jsonEncode([
                {
                  "name": "Nairobi",
                  "lat": -1.286389,
                  "lon": 36.817223,
                  "country": "Kenya",
                  "state": "Nairobi County"
                }
              ]),
              200);
        } else {
          return http.Response('City not found', 404);
        }
      });
    });

    test('returns city data for a valid city name', () async {
      final result = await fetchCityData('Nairobi', client: mockClient);
      expect(result, isA<Map<String, dynamic>>());
      expect(result['name'], 'Nairobi');
    });

    test('throws an exception for an invalid city name', () async {
      expect(fetchCityData('InvalidCity', client: mockClient), throwsException);
    });

    // More tests for other scenarios
  });
}
