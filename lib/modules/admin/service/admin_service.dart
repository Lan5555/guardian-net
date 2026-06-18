import 'package:guardian_net/service/core_service.dart';

class AdminService extends CoreService {
  Future<NetResponse> createCommunity(dynamic payload) async {
    return send('/community/create', payload);
  }

  Future<NetResponse> updateCommunity(int id, dynamic payload) async {
    return update('/community/update-one/$id', payload);
  }

  Future<NetResponse> deleteCommunity(int id) async {
    return delete('/community/delete/$id');
  }

  Future<NetResponse> fetchAllUsers() async {
    return get('/users/find-all');
  }

  Future<NetResponse> fetchAllCommunities() async {
    return get('/community/find-all');
  }

  Future<NetResponse> deleteUSer(int id) async {
    return delete('/users/delete/$id');
  }

  Future<NetResponse> updateUserProfile(int id, dynamic payload) async {
    return update('/users/update/$id', payload);
  }

  Future<NetResponse> fetchAllAlerts() async {
    return get('/community-alerts/find-all');
  }

  Future<NetResponse> deleteAlert(int id) async {
    return delete('/community-alerts/delete/$id');
  }

  Future<NetResponse> updateAlert(int id, dynamic payload) async {
    return update('/community-alerts/update/$id', payload);
  }
}
