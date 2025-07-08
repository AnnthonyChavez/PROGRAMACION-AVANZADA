import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/poliza_viewmodel.dart';
import 'lista_polizas_view.dart'; // Importar la nueva vista de lista
import '../viewmodels/lista_polizas_viewmodel.dart'; // Importar el ViewModel de la lista

class PolizaView extends StatelessWidget {
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propietarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PolizaViewModel>(context);

    // Asegúrate de que los controladores se actualicen solo si hay un valor diferente
    // Esto evita que el cursor salte si el texto es el mismo
    if (_valorController.text != vm.valorSeguroAuto.toString()) {
      _valorController.text = vm.valorSeguroAuto.toString();
    }
    if (_accidentesController.text != vm.accidentes.toString()) {
      _accidentesController.text = vm.accidentes.toString();
    }
    if (_propietarioController.text != vm.propietario) {
      _propietarioController.text = vm.propietario;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Crear Póliza", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Crear"),
          // Cambiamos el icono de búsqueda por uno de tabla y su label
          BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: "Listar"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"), // Mantener o cambiar según necesites
        ],
        onTap: (index) {
          if (index == 1) { // El índice 1 corresponde al nuevo botón "Listar"
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (_) => ListaPolizasViewModel(), // Provee el ViewModel a la nueva ruta
                  child: ListaPolizasView(),
                ),
              ),
            );
          }
          // Puedes añadir lógica para otros índices si los necesitas
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput("Propietario", _propietarioController, (val) {
              vm.propietario = val;
              vm.notifyListeners();
            }),
            SizedBox(height: 12),
            _buildInput("Valor del ", _valorController, (val) {
              vm.valorSeguroAuto = double.tryParse(val) ?? 0;
              vm.notifyListeners();
            }, keyboard: TextInputType.number),
            SizedBox(height: 12),

            Text("Modelo de auto:", style: Theme.of(context).textTheme.titleMedium), // Cambiado subtitle1 a titleMedium
            for (var m in ['A','B','C'])
              _buildRadio("Modelo $m", m, vm.modeloAuto, (val) {
                vm.modeloAuto = val!;
                vm.notifyListeners();
              }),

            SizedBox(height: 12),
            Text("Edad propietario:", style: Theme.of(context).textTheme.titleMedium), // Cambiado subtitle1 a titleMedium
            for (var e in ['18-23', '23-55', '55-80', '80+'])
              _buildRadio(_textoEdad(e), e, vm.edadPropietario, (val) {
                vm.edadPropietario = val!;
                vm.notifyListeners();
              }),

            SizedBox(height: 12),
            _buildInput("Número de accidentes", _accidentesController, (val) {
              vm.accidentes = int.tryParse(val) ?? 0;
              vm.notifyListeners();
            }, keyboard: TextInputType.number),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white, // Color del texto del botón
                ),
                onPressed: () async {
                  await vm.calcularPoliza();
                  // Opcional: mostrar un SnackBar con el costo total
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Costo Total Calculado: ${vm.costoTotal.toStringAsFixed(2)}')),
                  );
                },
                child: Text("CREAR PÓLIZA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "Costo total: ${vm.costoTotal.toStringAsFixed(2)}", // Formatear a 2 decimales
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, Function(String) onChanged, {TextInputType? keyboard}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }

  Widget _buildRadio(String label, String value, String groupValue, Function(String?) onChanged) {
    return RadioListTile(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: Colors.teal,
    );
  }

  String _textoEdad(String rango) {
    switch (rango) {
      case '18-23': return 'Mayor o igual a 18 y menor a 23';
      case '23-55': return 'Mayor o igual a 23 y menor a 55';
      case '55-80': return 'Mayor o igual a 55 y menor a 80'; // Corregida la repetición
      default: return 'Mayor o igual a 80';
    }
  }
}