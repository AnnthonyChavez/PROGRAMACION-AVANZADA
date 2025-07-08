// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/poliza_view.dart';
import 'viewmodels/poliza_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Seguros',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (context) => PolizaViewModel(),
        child: PolizaView(),
      ),
    );
  }
}