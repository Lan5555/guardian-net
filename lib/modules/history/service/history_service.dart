import 'package:guardian_net/service/core_service.dart';

class HistoryService extends CoreService {
  Future<NetResponse> fetchHistory() async {
    return get('/community-alerts/find-all');
  }
}
