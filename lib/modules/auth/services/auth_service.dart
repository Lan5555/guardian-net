import 'package:guardian_net/service/core_service.dart';

class AuthService extends CoreService {
  Future<NetResponse> loginAdmin(dynamic payload) async {
    return await send('/auth/login-admin', payload);
  }

  Future<NetResponse> loginUser(dynamic payload) async {
    return await send('/auth/login-user', payload);
  }
  Future<NetResponse> registerUser(dynamic payload) async {
    return await send('/users/register', payload);
  }
  Future<NetResponse> fetchAllCommunities() async {
    return get('/community/find-all');
  }
}
