import 'package:flutter/material.dart';

class Ejercicio6PromedioPonderado extends StatefulWidget {
  @override
  State<Ejercicio6PromedioPonderado> createState() => _Ejercicio6PromedioPonderadoState();
}

class _Ejercicio6PromedioPonderadoState extends State<Ejercicio6PromedioPonderado> {
  final TextEditingController nota1Controller = TextEditingController();
  final TextEditingController nota2Controller = TextEditingController();
  final TextEditingController nota3Controller = TextEditingController();
  String resultado = '';

  void calcularPromedio() {
    double? n1 = double.tryParse(nota1Controller.text);
    double? n2 = double.tryParse(nota2Controller.text);
    double? n3 = double.tryParse(nota3Controller.text);

    if (n1 == null || n2 == null || n3 == null) {
      setState(() {
        resultado = 'Por favor, ingrese todas las notas correctamente.';
      });
      return;
    }

    double promedio = (n1 * 0.25) + (n2 * 0.25) + (n3 * 0.5);

    setState(() {
      resultado = 'El promedio ponderado es: ${promedio.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 6 - Promedio Ponderado')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nota1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nota 1 (25%)'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nota2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nota 2 (25%)'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nota3Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nota 3 (50%)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularPromedio,
              child: Text('Calcular Promedio'),
            ),
            SizedBox(height: 20),
            Text(
              resultado,
              style: TextStyle(fontSize: 16, color: Colors.teal),
            ),
            Spacer(),
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