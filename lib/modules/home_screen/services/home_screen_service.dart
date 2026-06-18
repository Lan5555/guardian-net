import 'package:guardian_net/service/core_service.dart';

class HomeScreenService extends CoreService {
  Future<NetResponse> sendAlert(dynamic data) async {
    return send('/community-alerts/create', data);
  }

  Future<NetResponse> findOneCommunity(int id) async {
    return get('/community/find-one/$id');
  }
}
