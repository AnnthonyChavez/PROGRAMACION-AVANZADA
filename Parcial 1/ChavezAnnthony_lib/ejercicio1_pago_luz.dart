import 'package:flutter/material.dart';

class Ejercicio1PagoLuz extends StatefulWidget {
  @override
  State<Ejercicio1PagoLuz> createState() => _Ejercicio1PagoLuzState();
}

class _Ejercicio1PagoLuzState extends State<Ejercicio1PagoLuz> {
  final TextEditingController _kwController = TextEditingController();
  String _resultado = '';

  void calcularPago() {
    double costoKw = 0.15;
    double? kw = double.tryParse(_kwController.text);

    if (kw == null || kw < 0) {
      setState(() {
        _resultado = 'Ingrese un valor válido de kilowatts.';
      });
      return;
    }

    double pago = kw * costoKw;
    setState(() {
      _resultado = 'Total a pagar: \$${pago.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 1 - Pago de Luz')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Ingrese la cantidad de kilowatts consumidos:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _kwController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Kilowatts'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularPago,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Text(
              _resultado,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
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