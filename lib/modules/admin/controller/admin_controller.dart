// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_net/helpers/helpers.dart';
import 'package:guardian_net/models/alert_model.dart';
import 'package:guardian_net/models/community_model.dart';
import 'package:guardian_net/models/user_model.dart';
import 'package:guardian_net/modules/admin/service/admin_service.dart';
import 'package:guardian_net/service/core_service.dart';
import 'package:http/http.dart' as http;

class AdminController extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  List<CommunityModel> communities = [];
  List<UserModel> users = [];
  List<AlertModel> alerts = [];
  bool isLoading = true;
  int activeTab = 0;
  double longitute = 0.0;
  double latitute = 0.0;

  final BuildContext context;
  AdminController({required this.context});

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final longController = TextEditingController();
  final latController = TextEditingController();
  bool isLocalStateLoading = false;

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();
    final res = await _adminService.fetchAllUsers();
    if (res.success) {
      final List<dynamic> data = res.data;
      users = data.map((json) => UserModel.fromJson(json)).toList();
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      showToast(context, res.message, isError: true);
    }
  }

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    final res = await _adminService.fetchAllCommunities();
    if (res.success) {
      final List<dynamic> data = res.data;

      communities = data.map((json) => CommunityModel.fromJson(json)).toList();
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      showToast(context, "Failed to load communities", isError: true);
    }
  }

  Future<void> submitCommunity({int? id, StateSetter? setModalState}) async {
    if (nameController.text.isEmpty) return;

    isLocalStateLoading = true;
    notifyListeners();
    setModalState?.call(() {});

    final payload = {
      'name': nameController.text,
      'location': locationController.text,
      'longitude': longController.text,
      'latitude': latController.text,
    };

    final res = id == null
        ? await _adminService.createCommunity(payload)
        : await _adminService.updateCommunity(id, payload);

    isLocalStateLoading = false;
    notifyListeners();

    isLocalStateLoading = false;
    notifyListeners();
    setModalState?.call(() {});

    if (res.success) {
      Navigator.pop(context);
      await fetchData();
      showToast(context, res.message);
    } else {
      showToast(context, res.message, isError: true);
    }
  }

  Future<void> deleteCommunity(int id) async {
    final res = await _adminService.deleteCommunity(id);
    if (res.success) {
      await fetchData();
      showToast(context, "Community deleted");
    } else {
      showToast(context, res.message, isError: true);
    }
  }

  Future<void> deleteUser(int id) async {
    final res = await _adminService.deleteUSer(id);
    if (res.success) {
      await fetchUsers();
      showToast(context, res.message);
    } else {
      showToast(context, res.message, isError: true);
    }
  }

  Future<void> updateUser(
    int id,
    dynamic payload,
    BuildContext context,
    StateSetter? setModalState,
  ) async {
    isLocalStateLoading = true;
    setModalState?.call(() {});
    notifyListeners();
    final res = await _adminService.updateUserProfile(id, payload);
    if (res.success) {
      await fetchUsers();
      showToast(context, res.message);
      isLocalStateLoading = false;
      setModalState?.call(() {});
      notifyListeners();
      Navigator.pop(context);
    } else {
      showToast(context, res.message, isError: true);
      isLocalStateLoading = false;
      setModalState?.call(() {});
      notifyListeners();
    }
  }

  Future<NetResponse> fetchAlerts() async {
    final res = await _adminService.fetchAllAlerts();
    if (res.success) {
      final List<dynamic> data = res.data;
      alerts = data.map((json) => AlertModel.fromJson(json)).toList();
    }
    return res;
  }

  Future<NetResponse> deleteAlert(int id) async {
    final res = await _adminService.deleteAlert(id);
    if (res.success) {
      await fetchAlerts();
      notifyListeners();
      showToast(context, res.message);
    } else {
      showToast(context, res.message, isError: true);
    }
    return res;
  }

  Future<void> getLatLngFromOSM(String place, StateSetter setModalState) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$place&format=json&limit=1',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent': 'FlutterApp/1.0 (chugarimah005@gmail.com)',
      },
    );
    isLocalStateLoading = true;
    setModalState(() {});
    notifyListeners();

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        final lat = data[0]['lat'];
        final lon = data[0]['lon'];

        longitute = double.parse(lon.toString());
        latitute = double.parse(lat.toString());

        longController.text = lon.toString();
        latController.text = lat.toString();
        isLocalStateLoading = false;
        setModalState(() {});
        notifyListeners();
      } else {
        showToast(context, "No results found", isError: true);
        if (kDebugMode) {
          print("No results found");
        }
        isLocalStateLoading = false;
        setModalState(() {});
        notifyListeners();
      }
    } else {
      if (kDebugMode) {
        print("Request failed: ${response.statusCode}");
      }
    }
  }
}
