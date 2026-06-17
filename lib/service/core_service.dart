import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoreService {
  // ignore: non_constant_identifier_names
  final BASE_URL = dotenv.env['BASE_URL'];

  Future<NetResponse> send(String endpoint, dynamic payload) async {
    try {
      final res = await http.post(
        Uri.parse('$BASE_URL$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final response = jsonDecode(res.body);
        return NetResponse(
          success: response['success'] ?? true,
          message: response['message'] ?? 'Success',
          data: response['data']
        );
      } else {
        return NetResponse(success: false, message: res.body, data: null);
      }
    } catch (e) {
      return NetResponse(success: false, message: e.toString(), data: null);
    }
  }

  Future<NetResponse> get(String endpoint) async {
    try {
      final res = await http.get(
        Uri.parse('$BASE_URL$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        final response = jsonDecode(res.body);
        return NetResponse(
          success: response['success'] ?? true,
          message: response['message'] ?? 'Success',
          data: response['data'] ?? response,
        );
      } else {
        return NetResponse(success: false, message: res.body, data: null);
      }
    } catch (e) {
      return NetResponse(success: false, message: e.toString(), data: null);
    }
  }

  Future<NetResponse> update(String endpoint, dynamic payload) async {
    try {
      final res = await http.patch(
        Uri.parse('$BASE_URL$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final response = jsonDecode(res.body);
        return NetResponse(
          success: response['success'] ?? true,
          message: response['message'] ?? 'Success',
          data: response['data'] ?? response,
        );
      } else {
        return NetResponse(success: false, message: res.body, data: null);
      }
    } catch (e) {
      return NetResponse(success: false, message: e.toString(), data: null);
    }
  }

  Future<NetResponse> delete(String endpoint) async {
    try {
      final res = await http.delete(
        Uri.parse('$BASE_URL$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final response = jsonDecode(res.body);
        return NetResponse(
          success: response['success'] ?? true,
          message: response['message'] ?? 'Success',
          data: response['data'] ?? response,
        );
      } else {
        return NetResponse(success: false, message: res.body, data: null);
      }
    } catch (e) {
      return NetResponse(success: false, message: e.toString(), data: null);
    }
  }
}

class NetResponse {
  final bool success;
  final String message;
  final dynamic data;
  NetResponse({
    required this.success,
    required this.message,
    required this.data,
  });
}
