import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Api {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive',
  };
  //authentication api ............................completed

  Future<Map<String, dynamic>> authenticate(
    String email,
    String password,
  ) async {
    final String url = 'https://design-pods.com/indiamart/public/login.php';

    final body = jsonEncode({"email": email, "password": password});

    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded;
      } else {
        throw HttpException(
          'Failed to authenticate: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}
