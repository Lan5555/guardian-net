import 'package:guardian_net/service/core_service.dart';

class OnboardingService extends CoreService {
  Future<NetResponse> pingServer() async {
   return await get('/auth/ping-server');
  }
}
