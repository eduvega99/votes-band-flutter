import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';


class StatusScreen extends StatelessWidget {

  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    // socketService.socket.emit();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server status: ${socketService.serverStatus}')
          ],
        )
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          final message = {
            'nombre': 'Flutter',
            'mensaje': 'Hola desde Flutter'
          };
          socketService.socket.emit('emitir-mensaje', message);
        },
      ),
    );
  }
}