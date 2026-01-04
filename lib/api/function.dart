import 'package:http/http.dart' as http;

Future<http.Response> fetchData(String url) async {
  final response = await http.get(Uri.parse(url));
  return response.body.isNotEmpty
      ? response
      : throw Exception('Failed to load data');
}
