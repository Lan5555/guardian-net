import 'package:guardian_net/service/core_service.dart';

class AdminService extends CoreService {
  Future<NetResponse> createCommunity(dynamic payload) async {
    return send('/community/create', payload);
  }

  Future<NetResponse> updateCommunity(int id, dynamic payload) async {
    return send('/community/update/$id', payload);
  }

  Future<NetResponse> deleteCommunity(int id) async {
    return send('/community/delete/$id', null);
  }

  Future<NetResponse> fetchAllUsers() async {
    return get('/users/find-all');
  }
  Future<NetResponse> fetchAllCommunities() async {
    return get('/community/find-all');
  }
}
