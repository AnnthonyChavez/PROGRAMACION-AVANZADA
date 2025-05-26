import 'package:flutter/material.dart';

class Ejercicio7EdadMeses extends StatefulWidget {
  @override
  _Ejercicio7EdadMesesState createState() => _Ejercicio7EdadMesesState();
}

class _Ejercicio7EdadMesesState extends State<Ejercicio7EdadMeses> {
  final TextEditingController _edadController = TextEditingController();
  String _resultado = '';

  void calcularTiempo() {
    int edad = int.tryParse(_edadController.text) ?? 0;
    int meses = edad * 12;
    int semanas = edad * 52;
    int dias = edad * 365;

    setState(() {
      _resultado = 'Has vivido aproximadamente:\n'
          '$meses meses\n'
          '$semanas semanas\n'
          '$dias días';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 7 - Edad en tiempo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _edadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Edad en años'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularTiempo,
              child: Text('Calcular'),
            ),
            SizedBox(height: 16),
            Text(_resultado, style: TextStyle(fontSize: 18)),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text("Volver al menú"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}