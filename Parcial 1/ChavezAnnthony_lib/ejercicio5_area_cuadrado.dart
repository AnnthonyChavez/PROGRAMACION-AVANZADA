import 'package:flutter/material.dart';

class Ejercicio5AreaCuadrado extends StatefulWidget {
  @override
  State<Ejercicio5AreaCuadrado> createState() => _Ejercicio5AreaCuadradoState();
}

class _Ejercicio5AreaCuadradoState extends State<Ejercicio5AreaCuadrado> {
  final TextEditingController _ladoController = TextEditingController();
  String _resultado = '';

  void calcularArea() {
    double? lado = double.tryParse(_ladoController.text);

    if (lado == null || lado <= 0) {
      setState(() {
        _resultado = 'Ingrese un valor válido para el lado.';
      });
      return;
    }

    double area = lado * lado;

    setState(() {
      _resultado = 'El área del cuadrado es: ${area.toStringAsFixed(2)} unidades cuadradas.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ejercicio 5 - Área del Cuadrado')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _ladoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Longitud del lado'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calcularArea,
              child: Text('Calcular área'),
            ),
            SizedBox(height: 20),
            Text(
              _resultado,
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