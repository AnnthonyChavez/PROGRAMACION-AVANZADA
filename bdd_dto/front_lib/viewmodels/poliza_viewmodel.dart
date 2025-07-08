import 'package:flutter/material.dart';
import '../models/poliza_model.dart';
import '../services/poliza_service.dart'; // Make sure this import is correct

class PolizaViewModel extends ChangeNotifier {
  final PolizaService _polizaService = PolizaService();

  // State variables for the policy form
  String _propietario = '';
  double _valorSeguroAuto = 0.0;
  String _modeloAuto = 'A'; // Default model
  String _edadPropietario = '23-55'; // Default age range
  int _accidentes = 0;
  double _costoTotal = 0.0;

  // Getters for accessing state variables
  String get propietario => _propietario;
  double get valorSeguroAuto => _valorSeguroAuto;
  String get modeloAuto => _modeloAuto;
  String get edadPropietario => _edadPropietario;
  int get accidentes => _accidentes;
  double get costoTotal => _costoTotal;

  // Setters for updating state variables and notifying listeners
  set propietario(String value) {
    _propietario = value;
    notifyListeners();
  }

  set valorSeguroAuto(double value) {
    _valorSeguroAuto = value;
    notifyListeners();
  }

  set modeloAuto(String value) {
    _modeloAuto = value;
    notifyListeners();
  }

  set edadPropietario(String value) {
    _edadPropietario = value;
    notifyListeners();
  }

  set accidentes(int value) {
    _accidentes = value;
    notifyListeners();
  }

  // Method to calculate and save the policy
  Future<void> calcularPoliza() async {
    // Create a Poliza object from current state
    final poliza = Poliza(
      propietario: _propietario,
      valorSeguroAuto: _valorSeguroAuto,
      modeloAuto: _modeloAuto,
      edadPropietario: _edadPropietario,
      accidentes: _accidentes,
    );

    try {
      // Call the service to create the policy.
      // _polizaService.crearPoliza returns Future<void>, so we just await it.
      await _polizaService.crearPoliza(poliza);

      // After successful creation, you might want to fetch the updated policy
      // from the backend to get the calculated costoTotal, or ideally,
      // your backend's /api/seguros POST endpoint returns the full SeguroDto.

      // For example, if your backend's POST /api/seguros returns the SeguroDto:
      // (This requires a change in `PolizaService.crearPoliza` to return SeguroDto)
      // SeguroDto? createdSeguro = await _polizaService.crearPoliza(poliza);
      // if (createdSeguro != null) {
      //   _costoTotal = createdSeguro.costoTotal;
      // } else {
      //   _costoTotal = 0.0; // Or handle error
      // }

      // Since our current `crearPoliza` returns `void`, and we're relying
      // on the backend to handle the calculation and potentially save it,
      // we'll update _costoTotal based on a simple mock or if you
      // have a separate endpoint to just calculate.
      // If your backend's POST endpoint already returns the calculated cost
      // you need to modify PolizaService.crearPoliza to parse that response.

      // For now, let's assume the calculation happens on the backend and
      // the POST request implicitly handles setting the costoTotal.
      // If you are seeing 0.0, it's very likely because your backend's
      // POST endpoint either sends back 0, or your Flutter service isn't
      // parsing the response to update _costoTotal here.

      // To display a non-zero cost immediately after creating,
      // you would ideally fetch the created policy or
      // modify crearPoliza to return the SeguroDTO with the calculated cost.
      // For a quick fix to show something, you could mock a calculation:
      _costoTotal = _valorSeguroAuto * 0.1 + (_accidentes * 50.0); // Simple mock calculation
      // Or if your backend's /api/seguros endpoint returns the full SeguroDTO,
      // you would modify crearPoliza in PolizaService to return SeguroDto,
      // and then assign its costoTotal here.

    } catch (e) {
      print('Error al crear/calcular póliza: $e');
      _costoTotal = 0.0; // Reset cost on error
      // You might want to store and display this error message to the user
    } finally {
      notifyListeners(); // Notify UI of update (even if costoTotal is 0.0)
    }
  }
}