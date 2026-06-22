import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardian_net/models/alert_model.dart';
import 'package:guardian_net/modules/history/service/history_service.dart';

class HistoryController extends ChangeNotifier {
  final BuildContext context;
  HistoryController({required this.context});

  final _service = HistoryService();
  List<AlertModel> history = [];
  bool isLoading = false;

  Future<void> fetchHistory() async {
    isLoading = true;
    notifyListeners();

    final res = await _service.fetchHistory();
    if (res.success) {
      final List<dynamic> data = res.data;
      history = data.map((json) => AlertModel.fromJson(json)).toList();
      if (kDebugMode) {
        print(res.message);
      }
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print(res.message);
      }
    }
  }
}
