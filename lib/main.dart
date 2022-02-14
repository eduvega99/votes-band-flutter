import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:band_names/screens/home.dart';
import 'package:band_names/screens/status.dart';
import 'package:provider/provider.dart';



void main() => runApp(const AppState());

class AppState extends StatelessWidget {

  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home' :  ( _ ) => const HomeScreen(),
        'status': ( _ ) => const StatusScreen()
      },
    );
  }
}