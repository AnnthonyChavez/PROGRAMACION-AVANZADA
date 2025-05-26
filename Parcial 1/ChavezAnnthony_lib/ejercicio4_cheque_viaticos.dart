import 'package:flutter/material.dart';

class Ejercicio4ChequeEmpleado extends StatefulWidget {
  @override
  _Ejercicio4ChequeEmpleadoState createState() => _Ejercicio4ChequeEmpleadoState();
}

class _Ejercicio4ChequeEmpleadoState extends State<Ejercicio4ChequeEmpleado> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _sueldoController = TextEditingController();
  final TextEditingController _viaticosController = TextEditingController();
  String _resultado = '';

  void calcularTotal() {
    String nombre = _nombreController.text;
    double sueldo = double.tryParse(_sueldoController.text) ?? 0.0;
    double viaticos = double.tryParse(_viaticosController.text) ?? 0.0;
    double total = sueldo + viaticos;

    setState(() {
      _resultado = '$nombre debe recibir \$${total.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 4 - Cheque empleado')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del empleado'),
            ),
            TextField(
              controller: _sueldoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Sueldo'),
            ),
            TextField(
              controller: _viaticosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Viáticos'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularTotal,
              child: Text('Calcular Total'),
            ),
            SizedBox(height: 16),
            Text(_resultado, style: TextStyle(fontSize: 18)
            ),
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