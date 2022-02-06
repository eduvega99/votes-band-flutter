import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';


class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 1),
    Band(id: '2', name: 'Breaking Benjamin', votes: 3),
    Band(id: '3', name: 'U2', votes: 5),
    Band(id: '4', name: 'Led Zeppelin', votes: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('BandNames', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),

      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: ( context, index ) => _bandTile(bands[index])
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon( Icons.add ),
        elevation: 1,
        onPressed: createDialog,
      ),

    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(band.id),

      onDismissed: ( direction ) {
        // TOD: Delete band
      },

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
        onTap: () => {
          print(band.name)
        },
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
      final newBand = Band(id: DateTime.now().toString(), name: name, votes: 0);
      bands.add(newBand);
      setState(() {});
    }

    Navigator.pop(context);
  }
}