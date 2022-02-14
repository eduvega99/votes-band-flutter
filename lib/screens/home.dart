import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/models/band.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  void _handleActiveBands( dynamic data ) {
    bands = ( data as List ).map( ( band ) => Band.fromMap(band) ).toList();
    setState(() { });
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    final isConnected = socketService.serverStatus == ServerStatus.online;

    return Scaffold(
      
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: isConnected ? const Icon(Icons.sensors, color: Colors.blue) : const Icon(Icons.sensors_off, color: Colors.red)
          )
        ],
      ),

      body: Column(
        children: [
          SizedBox(
            height: 275,
            child: PieChart(
              dataMap: { for (var band in bands) band.name : band.votes.toDouble() },
              chartValuesOptions: const ChartValuesOptions(
                decimalPlaces: 0,
                showChartValuesInPercentage: true
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: bands.length,
              itemBuilder: ( context, index ) => _bandTile(bands[index])
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add ),
        elevation: 1,
        onPressed: createDialog,
      ),

    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(band.id),
      onDismissed: ( _ ) => socketService.emit('delete-band', { 'id': band.id }),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white ),
      ),

      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text(band.votes.toString(), style: const TextStyle(fontSize: 20)),
        onTap: () => socketService.emit('vote-band', { 'id': band.id }),
      ),
    );
  }

  createDialog() {
    final textController = TextEditingController();

    if ( Platform.isAndroid ) {
      return _createMaterialDialog(textController);
    }
    return _createCupertinoDialog(textController);
  }

  _createCupertinoDialog(TextEditingController textController) {
    return showCupertinoDialog(
      context: context, 
      builder: ( _ ) {
        return CupertinoAlertDialog(
          title: const Text('New band name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Add'),
              onPressed: () => addNewBand(textController.text)
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Dismiss'),
              onPressed: () => Navigator.pop(context)
            )
          ],
        );
      }, 
    );
  }

  _createMaterialDialog(TextEditingController textController) {
    return showDialog(
      context: context, 
      builder: ( _ ) {
        return AlertDialog(
          title: const Text('New band name'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: const Text('Add'),
              textColor: Colors.blue,
              elevation: 5,
              onPressed: () => addNewBand(textController.text)
            )
          ]
        );
      }
    );
  }

  void addNewBand(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', { 'name': name });
    }
    Navigator.pop(context);
  }
}