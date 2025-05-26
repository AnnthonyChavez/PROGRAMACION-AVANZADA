import 'package:flutter/material.dart';

// Asegúrate de que estos archivos existen en la carpeta lib/
import 'ejercicio1_pago_luz.dart';
import 'ejercicio2_descuento_iva.dart';
import 'ejercicio3_ahorro_anual.dart';
import 'ejercicio4_cheque_viaticos.dart';
import 'ejercicio5_area_cuadrado.dart';
import 'ejercicio6_promedio_ponderado.dart';
import 'ejercicio7_vida_en_tiempo.dart'; // Verifica este archivo

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea Flutter',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MenuPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal - Tarea'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            'Selecciona un ejercicio:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ejercicio1PagoLuz()),
              );
            },
            child: const Text('Ejercicio 1: Pago luz y sombras'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ejercicio2DescuentoIva()),
              );
            },
            child: const Text('Ejercicio 2: Descuento + IVA'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ejercicio3AhorroAnual()),
              );
            },
            child: const Text('Ejercicio 3: Ahorro anual'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ejercicio4ChequeEmpleado()),
              );
            },
            child: const Text('Ejercicio 4: Cheque por viáticos'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ejercicio5AreaCuadrado()),
              );
            },
            child: const Text('Ejercicio 5: Área del cuadrado'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ejercicio6PromedioPonderado()),
              );
            },
            child: const Text('Ejercicio 6: Promedio ponderado'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ejercicio7EdadMeses()),
              );
            },
            child: const Text('Ejercicio 7: Edad en meses, semanas, días, horas'),
          ),
        ],
      ),
    );
  }
}