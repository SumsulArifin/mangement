import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rest_api_app/Constants/url.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_app/Screens/Authentication/login.dart';
import 'package:rest_api_app/Utils/routers.dart';

import '../../Screens/TaskPage/home_page.dart';
import '../Database/db_provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  final requestBaseUrl = AppUrl.baseUrl;
  bool _isLoading = false;
  String _resMessage = '';

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  void registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$requestBaseUrl/api/register";

    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "role":role,
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        _isLoading = false;
        _resMessage = "Account created!";
        notifyListeners();
        if (context != null) {
          await PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
          clear(); // Clear message after navigation
        }
      } else {
        final res = json.decode(req.body) as Map<String, dynamic>?;

        if (res != null && res.containsKey('message')) {
          _resMessage = res['message'] as String;
        } else {
          // Log the response body when encountering an unknown error
          print("Unknown error occurred: ${req.body}");
          _resMessage = 'Unknown error occurred';
        }
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again";
      notifyListeners();

      print("Error: $e");
    }
  }

  void loginUser({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = "$requestBaseUrl/api/users/login";

    final body = {"email": email, "password": password};
    print(body);

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        print(res);
        _isLoading = false;
        _resMessage = "Login successful!";
        notifyListeners();

        // Access 'userId' directly from the response JSON
        final userId = res['userId'];

        // Check if userId is present and not null
        if (userId != null && context != null) {
          // Save userId using DatabaseProvider
          DatabaseProvider().saveUserId(userId.toString());

          // Navigate to the home page
          PageNavigator(ctx: context).nextPageOnly(page: const HomePage());
        } else {
          // Handle if userId or context is null
          _resMessage = "Error: User data incomplete";
        }
      } else {
        final res = json.decode(req.body);

        // Check for null before accessing 'message' property
        _resMessage = res['message'] ?? "Unknown error";

        print(res);
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = "Please try again";
      notifyListeners();

      print("Error: $e");
    }
  }

  void clear() {
    _resMessage = "";
    // _isLoading = false;
    notifyListeners();
  }
}
