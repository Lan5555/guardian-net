// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:guardian_net/helpers/helpers.dart';
import 'package:guardian_net/models/community_model.dart';
import 'package:guardian_net/modules/admin/service/admin_service.dart';

class AdminController extends ChangeNotifier {
  final AdminService _adminService = AdminService();
  List<CommunityModel> communities = [];
  List<dynamic> users = [];
  bool isLoading = true;
  int activeTab = 0; // 0: Communities, 1: Users, 2: Alerts
  final BuildContext context;
  AdminController({required this.context});

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final longController = TextEditingController();
  final latController = TextEditingController();
  bool isLocalStateLoading = false;

  Future<void> fetchUsers() async {
    isLoading = true;
    notifyListeners();
    final res = await _adminService.fetchAllUsers();
    if (res.success) {
      users = res.data;
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
}
