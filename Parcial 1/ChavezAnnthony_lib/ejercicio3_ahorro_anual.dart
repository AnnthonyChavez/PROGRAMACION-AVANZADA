import 'package:flutter/material.dart';

class Ejercicio3AhorroAnual extends StatefulWidget {
  @override
  State<Ejercicio3AhorroAnual> createState() => _Ejercicio3AhorroAnualState();
}

class _Ejercicio3AhorroAnualState extends State<Ejercicio3AhorroAnual> {
  final TextEditingController _sueldoController = TextEditingController();
  String _resultado = '';

  void calcularAhorroAnual() {
    double? sueldo = double.tryParse(_sueldoController.text);
    if (sueldo == null || sueldo < 0) {
      setState(() {
        _resultado = 'Ingrese un sueldo válido.';
      });
      return;
    }

    double ahorroPorSemana = sueldo * 0.15;
    double ahorroAnual = ahorroPorSemana * 48;

    setState(() {
      _resultado =
      'Ahorro semanal (15%): \$${ahorroPorSemana.toStringAsFixed(2)}\n'
          'Ahorro anual (48 semanas): \$${ahorroAnual.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 3 - Ahorro Anual')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Ingrese su sueldo semanal:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _sueldoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Sueldo'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularAhorroAnual,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Text(
              _resultado,
              style: TextStyle(fontSize: 18, color: Colors.green),
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