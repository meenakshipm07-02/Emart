import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:grocery_app/Datastore/shared_pref.dart';
import 'package:http/http.dart' as http;

class Main_Apis {
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive',
  };
  //creation of account...........................completed with exception checking
  Future<Map<String, dynamic>> createaccount(
    String name,
    String email,
    String password,
    String phone,
    String address,
  ) async {
    final String url = 'https://design-pods.com/indiamart/public/register.php';

    final body = jsonEncode({
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
    });

    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded;
      } else {
        throw HttpException(
          'Failed to create account: ${response.statusCode}',
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
      throw Exception(e.toString());
    }
  }
  //get catogories.................................completed with exception checking...double login issue fixed

  Future<Map<String, dynamic>> getCategories() async {
    final String url = 'https://design-pods.com/indiamart/public/category.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null) {
        throw Exception('Token not found. please log in again');
      }

      final Map<String, String> authHeaders = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(Uri.parse(url), headers: authHeaders)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['status'] == 'error') {
          final message = decoded['message'] ?? 'Unknown error';
          if (message.toString().toLowerCase().contains('invalid token')) {
            await SharedPrefs.clearAll();
            throw Exception('Session expired. Please log in again.');
          } else {
            throw Exception(message);
          }
        }

        return decoded;
      } else {
        throw HttpException('${response.statusCode}', uri: Uri.parse(url));
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      throw Exception("$e");
    }
  }

  //getproducts by category................completed with exception checking ...double login issue fixed

  Future<Map<String, dynamic>> getProductsByCategory(String categoryId) async {
    final String url =
        'https://design-pods.com/indiamart/public/get_products_bycategoryid.php?id=$categoryId';

    try {
      final token = await SharedPrefs.getToken();
      if (token == null) {
        throw Exception('Token not found. Please log in again.');
      }

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Connection': 'keep-alive',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;

        if (decoded['status'] == 'error') {
          final message = decoded['message'] ?? 'Unknown error';
          if (message.toString().toLowerCase().contains('invalid token')) {
            // Optional: clear token so user reauthenticates
            await SharedPrefs.clearAll();
            throw Exception('Session expired. Please log in again.');
          } else {
            throw Exception(message);
          }
        }

        return decoded;
      } else {
        throw HttpException(' ${response.statusCode}', uri: Uri.parse(url));
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      throw Exception("$e");
    }
  }

  //add to favourites.....completed..with exception checking

  Future<Map<String, dynamic>> addToFavorites(int productId) async {
    const String url =
        'https://design-pods.com/indiamart/public/add_to_favourite.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({'product_id': productId});

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw HttpException(
          'Failed to add favourites: ${response.statusCode}',
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
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      throw Exception("Error adding favourites: $errorText");
    }
  }

  //remove the item from favourites..........completed..with exception checking
  Future<Map<String, dynamic>> removeFromFavorites(int productId) async {
    const String url =
        'https://design-pods.com/indiamart/public/remove_favourite.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({'product_id': productId});

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw HttpException(
          'Failed to remove favourites: ${response.statusCode}',
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
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      throw Exception("Error removing favourites: $errorText");
    }
  }

  //view favourites.............completed..with exception checking
  Future<Map<String, dynamic>> getFavourites() async {
    final String url =
        'https://design-pods.com/indiamart/public/view_favourites.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null) {
        throw Exception('Token not found');
      }

      final Map<String, String> authHeaders = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(Uri.parse(url), headers: authHeaders)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        return decoded;
      } else {
        throw HttpException(
          'Failed to load favourites: ${response.statusCode}',
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
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      throw Exception("Error fetching favourites: $errorText");
    }
  }

  //item detailing page.....................completed.......not corrected

  Future<Map<String, dynamic>> getProductDetail(String productId) async {
    final String url =
        'https://design-pods.com/indiamart/public/product_details.php?id=$productId';

    try {
      final token = await SharedPrefs.getToken();
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Connection': 'keep-alive',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
          'Failed to load product detail: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      throw Exception("Error fetching product detail: $errorText");
    }
  }

  //add to cart....................completed.with exception checking
  Future<Map<String, dynamic>> addToCart(String productId, int quantity) async {
    const String url =
        'https://design-pods.com/indiamart/public/add_to_cart.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({
        'products': [
          {'product_id': productId, 'quantity': quantity},
        ],
      });

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw HttpException(
          'Failed to add to cart: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException catch (e) {
      throw Exception("Invalid response format: ${e.message}");
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      throw Exception("Error adding item to cart: $errorText");
    }
  }

  //view recent......................................... completed..with exception checking
  Future<Map<String, dynamic>> viewrecent_products() async {
    final String url =
        'https://design-pods.com/indiamart/public/get_recent_products.php';

    try {
      final token = await SharedPrefs.getToken();
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': '$token',
              'Content-Type': 'application/json',
              'Connection': 'keep-alive',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Failed to load products: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error fetching products: $e';
    }
  }

  //view cart ....................................completed...with exception checking
  Future<Map<String, dynamic>> viewcart() async {
    final String url = 'https://design-pods.com/indiamart/public/view_cart.php';

    try {
      final token = await SharedPrefs.getToken();
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': '$token',
              'Content-Type': 'application/json',
              'Connection': 'keep-alive',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Failed to load cart products: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error fetching cart products: $e';
    }
  }
  //cart product remove............................................completed.....with exception checking

  Future<Map<String, dynamic>> removeFromCart(int productId) async {
    const String url =
        'https://design-pods.com/indiamart/public/cart_remove.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({'product_id': productId});

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to remove item from cart: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error removing item from cart: $e';
    }
  }

  //update cart...........................completed

  Future<Map<String, dynamic>> updateCart(int productId, int quantity) async {
    const String url =
        'https://design-pods.com/indiamart/public/cart_update.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({'product_id': productId, 'quantity': quantity});

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to update cart: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error updating the cart: $e';
    }
  }

  //forgot pass otp send.....................completed

  Future<Map<String, dynamic>> forgotOtpFetch(String email) async {
    const String url =
        'https://design-pods.com/indiamart/public/forgot_password_request.php';

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({'username': email});

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw HttpException(
          'Failed to send OTP: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException catch (e) {
      throw Exception("Invalid response format: ${e.message}");
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      throw Exception("Error sending OTP: $errorText");
    }
  }
  //reseting password...............completed.............

  Future<Map<String, dynamic>> password_reset(
    String email,
    int Otp,
    String newpass,
  ) async {
    const String url =
        'https://design-pods.com/indiamart/public/forgot_password_verify.php';

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({
        'username': email,
        'otp': Otp,
        'new_password': newpass,
      });

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw HttpException(
          'Failed to proceed: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException catch (e) {
      throw Exception("Invalid response format: ${e.message}");
    } catch (e) {
      final errorText = e.toString().replaceAll('Exception: ', '').trim();
      throw Exception("Error in proceed: $errorText");
    }
  }

  //add address ...............completed...............

  Future<Map<String, dynamic>> add_address(
    String address,
    String pincode,
    String addresstype,
  ) async {
    const String url =
        'https://design-pods.com/indiamart/public/add_address.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({
        'address': address,
        'pincode': pincode,
        'address_type': addresstype,
      });

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to add address: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error adding address: $e';
    }
  }
  //view address................completed..............

  Future<Map<String, dynamic>> viewaddress() async {
    final String url =
        'https://design-pods.com/indiamart/public/get_addresses.php';

    try {
      final token = await SharedPrefs.getToken();
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': '$token',
              'Content-Type': 'application/json',
              'Connection': 'keep-alive',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Failed to load the address details: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server';
    } catch (e) {
      throw 'Error fetching address details: $e';
    }
  }
  //remove address................completed..............

  Future<Map<String, dynamic>> remove_address(int address_id) async {
    const String url =
        'https://design-pods.com/indiamart/public/delete_address.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({'address_id': address_id});

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to remove address: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error removing address: $e';
    }
  }
  //get profie data..........................completed

  Future<Map<String, dynamic>> getprofile() async {
    final String url =
        'https://design-pods.com/indiamart/public/view_profile.php';

    try {
      final token = await SharedPrefs.getToken();
      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Authorization': '$token',
              'Content-Type': 'application/json',
              'Connection': 'keep-alive',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw 'Failed to load the profile details: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server';
    } catch (e) {
      throw 'Error fetching profile details: $e';
    }
  }

  //completed

  Future<Map<String, dynamic>> getallproducts() async {
    final String url =
        'https://design-pods.com/indiamart/public/products_list.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null) {
        throw Exception('Token not found. please log in again');
      }

      final Map<String, String> authHeaders = {
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
        'Authorization': 'Bearer $token',
      };

      final response = await http
          .get(Uri.parse(url), headers: authHeaders)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['status'] == 'error') {
          final message = decoded['message'] ?? 'Unknown error';
          if (message.toString().toLowerCase().contains('invalid token')) {
            await SharedPrefs.clearAll();
            throw Exception('Session expired. Please log in again.');
          } else {
            throw Exception(message);
          }
        }

        return decoded;
      } else {
        throw HttpException('${response.statusCode}', uri: Uri.parse(url));
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      throw Exception("$e");
    }
  }
  // prorile editing.........................completed

  Future<Map<String, dynamic>> editProfile(
    int phonenum,
    String name,
    String email,
  ) async {
    const String url =
        'https://design-pods.com/indiamart/public/update_profile.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({
        'name': name,
        'email': email,
        'phone': phonenum,
      });

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to remove address: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error removing address: $e';
    }
  }
  // buynow orderid getting api .....completed....

  Future<Map<String, dynamic>> Buynow(String productid, int quantity) async {
    const String url =
        'https://design-pods.com/indiamart/public/place_single_product.php';
    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({'product_id': productid, 'quantity': quantity});

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to buy the product: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error buying the product: $e';
    }
  }

  //razorpay key getting api .....completed
  Future<Map<String, dynamic>> getRazorpayKey() async {
    const String url =
        'https://design-pods.com/indiamart/public/merchantkey.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to get Razorpay key: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error getting Razorpay key: $e';
    }
  }

  // placeorder api section......ongoing
  Future<Map<String, dynamic>> Placeorder(
    int orderid,
    num amount,
    String address,
    String paymentmethod,
  ) async {
    const String url = 'https://design-pods.com/indiamart/public/checkout.php';
    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final body = jsonEncode({
        'order_id': orderid,
        'amount': amount,
        'address': address,
        'payment_method': paymentmethod,
      });

      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to place order: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error placing the order: $e';
    }
  }

  // get coupons api ...ongoing

  Future<Map<String, dynamic>> getcouponcode() async {
    const String url =
        'https://design-pods.com/indiamart/public/get_user_coupons.php';

    try {
      final token = await SharedPrefs.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('User token not found. Please log in again.');
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      };

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw 'Invalid response format from server.';
        }
      } else {
        throw 'Failed to get coupon codes: ${response.statusCode}';
      }
    } on SocketException {
      throw 'No internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw 'Error getting coupon codes: $e';
    }
  }
}
