import 'package:guardian_net/service/core_service.dart';

class HomeScreenService extends CoreService {
  Future<NetResponse> sendAlert(dynamic data) async {
    return send('/community-alerts/create', data);
  }

  Future<NetResponse> findOneCommunity(int id) async {
    return get('/community/find-one/$id');
  }

  Future<NetResponse> comfirmAlert(int userId, int alertId) async {
    return get(
      '/community-alerts/comfirm-alert?userId=$userId&alertId=$alertId',
    );
  }

  Future<NetResponse> flagAsFalse(int alertId) async {
    return get('/community-alerts/flag-as-false?alertId=$alertId');
  }
}
