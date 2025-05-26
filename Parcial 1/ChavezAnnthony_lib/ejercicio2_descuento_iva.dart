import 'package:flutter/material.dart';

class Ejercicio2DescuentoIva extends StatefulWidget {
  @override
  _Ejercicio2DescuentoIvaState createState() => _Ejercicio2DescuentoIvaState();
}

class _Ejercicio2DescuentoIvaState extends State<Ejercicio2DescuentoIva> {
  final TextEditingController _precioController = TextEditingController();
  String _resultado = '';

  void calcularPrecioFinal() {
    double precio = double.tryParse(_precioController.text) ?? 0.0;
    double descuento = precio * 0.10;
    double precioConDescuento = precio - descuento;
    double iva = precioConDescuento * 0.12;
    double precioFinal = precioConDescuento + iva;

    setState(() {
      _resultado = 'Precio final: \$${precioFinal.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 2 - Descuento + IVA')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ingrese el precio'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularPrecioFinal,
              child: Text('Calcular'),
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