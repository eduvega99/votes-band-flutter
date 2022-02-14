import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { 
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {
  
  late Socket _socket;
  ServerStatus _serverStatus = ServerStatus.connecting;

  SocketService() {
    _initConfig();
  }

  Socket get socket => _socket;
  ServerStatus get serverStatus => _serverStatus;
  Function get emit => _socket.emit;

  void _initConfig() {
    
    _socket = io('http://flutter-votes-bands-server.herokuapp.com/',
      OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build()
    );

    _socket.onConnect((data) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((data) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', ( data ) {
    //   print('nuevo-mensaje: $data');
    // });
  }


}