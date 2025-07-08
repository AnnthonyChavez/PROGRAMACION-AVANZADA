import 'dart:convert'; // Para codificar/decodificar JSON
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP
import 'package:path_provider/path_provider.dart'; // Para obtener rutas de directorio
import 'package:open_filex/open_filex.dart'; // Para abrir los archivos generados
import 'dart:io'; // Para operaciones con archivos (File)

// No necesitamos las librerías de generación PDF/Excel aquí si el backend las genera
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:excel/excel.dart';

import '../models/poliza_model.dart'; // Tu modelo de Póliza (para crear)
import '../models/seguro_dto.dart'; // Tu DTO de Seguro (para recibir datos de backend)

class PolizaService {
  final String _baseUrl = "http://localhost:9090/bdd_dto/api/seguros";

  // --- MÉTODOS DE COMUNICACIÓN CON EL BACKEND ---

  /// Envía una nueva póliza al backend para ser creada.
  /// Retorna un Future<void> ya que no esperamos un valor de retorno específico
  /// para el frontend, solo la confirmación de la creación.
  Future<void> crearPoliza(Poliza poliza) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(poliza.toJson()), // Convierte el objeto Poliza a JSON
    );

    if (response.statusCode != 200) {
      // Si la respuesta no es 200 (OK), lanza una excepción con el error.
      throw Exception('Error al crear póliza: ${response.statusCode} - ${response.body}');
    }
    // Si la creación es exitosa (código 200), no necesitamos hacer nada más aquí.
    // El backend se encarga de guardar y calcular.
  }

  /// Obtiene todas las pólizas desde el backend.
  /// Retorna una lista de objetos SeguroDto.
  Future<List<SeguroDto>> getTodasLasPolizas() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON (que es una lista de objetos JSON)
      List<dynamic> body = json.decode(response.body);
      // Mapea cada objeto JSON a un SeguroDto
      return body.map((dynamic item) => SeguroDto.fromJson(item)).toList();
    } else {
      // Si la respuesta no es 200, lanza una excepción.
      throw Exception('Error al cargar pólizas: ${response.statusCode} - ${response.body}');
    }
  }

  /// Elimina una póliza por su ID en el backend.
  /// Retorna un Future<void>.
  Future<void> eliminarPoliza(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 204) { // 204 No Content es el código típico para DELETE exitoso
      throw Exception('Error al eliminar póliza: ${response.statusCode} - ${response.body}');
    }
  }

  // --- MÉTODOS DE EXPORTACIÓN (VIA BACKEND) ---

  /// Solicita al backend la exportación de pólizas a un archivo Excel.
  /// El archivo se descarga, guarda localmente y luego se abre.
  Future<void> exportarPolizasExcelBackend() async {
    print('Solicitando exportación a Excel al backend...');
    final url = Uri.parse('$_baseUrl/export/excel');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes; // Los bytes del archivo Excel
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/polizas.xlsx';
        final file = File(filePath);

        await file.writeAsBytes(bytes);
        print('Archivo Excel recibido y guardado en: $filePath');
        await OpenFilex.open(filePath);
        print('Archivo Excel abierto exitosamente.');
      } else {
        print('Error al solicitar Excel del backend: ${response.statusCode} - ${response.body}');
        throw Exception('Error al descargar archivo Excel: ${response.body}');
      }
    } catch (e) {
      print('Excepción al exportar Excel: $e');
      rethrow;
    }
  }

  /// Solicita al backend la exportación de pólizas a un archivo PDF.
  /// El archivo se descarga, guarda localmente y luego se abre.
  Future<void> exportarPolizasPdfBackend() async {
    print('Solicitando exportación a PDF al backend...');
    final url = Uri.parse('$_baseUrl/export/pdf');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes; // Los bytes del archivo PDF
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/polizas.pdf';
        final file = File(filePath);

        await file.writeAsBytes(bytes);
        print('Archivo PDF recibido y guardado en: $filePath');
        await OpenFilex.open(filePath);
        print('Archivo PDF abierto exitosamente.');
      } else {
        print('Error al solicitar PDF del backend: ${response.statusCode} - ${response.body}');
        throw Exception('Error al descargar archivo PDF: ${response.body}');
      }
    } catch (e) {
      print('Excepción al exportar PDF: $e');
      rethrow;
    }
  }
}
