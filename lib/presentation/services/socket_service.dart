import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import 'package:chat_app_provider/presentation/services/services.dart';
import 'package:chat_app_provider/config/global/environments.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  socket_io.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;

  socket_io.Socket get socket => _socket!;
  Function get emit => _socket!.emit;

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = socket_io.io(
      Environments.socketUrl,
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableForceNew()
          .setExtraHeaders({
            'x-token': token,
          })
          .build(),
    );

    _socket!.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket!.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket!.disconnect();
  }
}
