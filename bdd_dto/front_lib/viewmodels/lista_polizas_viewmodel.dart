// lib/viewmodels/lista_polizas_viewmodel.dart

import 'package:flutter/material.dart';
import '../services/poliza_service.dart';
import '../models/seguro_dto.dart';

class ListaPolizasViewModel extends ChangeNotifier {
  final PolizaService _polizaService = PolizaService();

  List<SeguroDto> _polizas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SeguroDto> get polizas => _polizas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ListaPolizasViewModel() {
    cargarPolizas(); // Carga las pólizas al inicializar el ViewModel
  }

  Future<void> cargarPolizas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Obtiene las pólizas del servicio
      List<SeguroDto> fetchedPolizas = await _polizaService.getTodasLasPolizas();

      // ¡NUEVO!: Invierte la lista para que la más reciente aparezca primero
      _polizas = fetchedPolizas.reversed.toList();

    } catch (e) {
      _errorMessage = 'Error al cargar pólizas: $e';
      print('Error en cargarPolizas: $_errorMessage'); // Para depuración
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarPoliza(int id) async {
    _isLoading = true; // Mostrar indicador mientras se elimina
    _errorMessage = null;
    notifyListeners();

    try {
      await _polizaService.eliminarPoliza(id);
      // Si la eliminación es exitosa, recarga la lista para reflejar el cambio
      await cargarPolizas();
      _errorMessage = null; // Limpiar cualquier error previo
    } catch (e) {
      _errorMessage = 'Error al eliminar póliza: $e';
      print('Error en eliminarPoliza: $_errorMessage'); // Para depuración
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}