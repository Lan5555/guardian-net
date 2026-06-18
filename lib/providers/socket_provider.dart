import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:guardian_net/models/alert_model.dart';
import 'package:guardian_net/providers/alert_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketProvider extends ChangeNotifier {
  late io.Socket socket;

  void connect(int communityId, AlertProvider alertProvider) {
    socket = io.io(
      dotenv.env['SOCKET_URL'] ?? dotenv.env['BASE_URL'],
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      if (kDebugMode) {
        print('Connected');
      }

      socket.emit(
        'joinCommunity',
        communityId,
      );
    });

    socket.on('new_alert', (data) {
      if (kDebugMode) {
        print('New Alert: $data');
      }
      alertProvider.addAlert(AlertModel.fromJson(data));
    });

    socket.onDisconnect((_) {
      if (kDebugMode) {
        print('Disconnected');
      }
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}