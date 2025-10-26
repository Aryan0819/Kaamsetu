import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  // Point to your backend server (change IP/port as needed)
  static const String _baseUrl = 'http://localhost:8000';

  Future<bool> _hasInternet() async {
    final status = await Connectivity().checkConnectivity();
    return status != ConnectivityResult.none;
  }

  Future<Map<String, String>> _getHeaders({bool auth = false}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  dynamic _processResponse(http.Response res) {
    final code = res.statusCode;
    final body = json.decode(res.body);
    if (code >= 200 && code < 300) {
      return body;
    } else {
      final msg = body['detail'] ?? body;
      throw Exception(msg);
    }
  }

  // LOGIN
  Future<Map<String, dynamic>> login(String username, String password) async {
    if (!await _hasInternet()) {
      throw Exception('No internet connection');
    }
    final res = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );
    return _processResponse(res);
  }

  // REGISTER
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String phone,
    required String role,
    String skills = '',
  }) async {
    if (!await _hasInternet()) {
      throw Exception('No internet connection');
    }
    final res = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: await _getHeaders(),
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role,
        'skills': skills,
      }),
    );
    return _processResponse(res);
  }

  // FETCH JOBS
  Future<List<dynamic>> fetchJobs() async {
    if (!await _hasInternet()) {
      throw Exception('No internet connection');
    }
    final res = await http.get(
      Uri.parse('$_baseUrl/jobs'),
      headers: await _getHeaders(),
    );
    return _processResponse(res);
  }

  // RECOMMEND JOBS
  Future<List<dynamic>> recommendJobs() async {
    if (!await _hasInternet()) {
      throw Exception('No internet connection');
    }
    final res = await http.get(
      Uri.parse('$_baseUrl/jobs/recommend'),
      headers: await _getHeaders(auth: true),
    );
    return _processResponse(res);
  }

  // CREATE JOB
  Future<Map<String, dynamic>> createJob({
    required String title,
    required String description,
    required String location,
    required String skillRequired,
    String? salary,
  }) async {
    if (!await _hasInternet()) {
      throw Exception('No internet connection');
    }
    final body = {
      'title': title,
      'description': description,
      'location': location,
      'skill_required': skillRequired,
      if (salary != null) 'salary': salary,
    };
    final res = await http.post(
      Uri.parse('$_baseUrl/jobs'),
      headers: await _getHeaders(auth: true),
      body: json.encode(body),
    );
    return _processResponse(res);
  }
}
