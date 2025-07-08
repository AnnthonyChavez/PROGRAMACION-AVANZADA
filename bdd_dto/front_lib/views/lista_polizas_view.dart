import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart'; // Importar permission_handler

import '../viewmodels/lista_polizas_viewmodel.dart';
import '../models/seguro_dto.dart';
import '../services/poliza_service.dart';

class ListaPolizasView extends StatelessWidget {
  const ListaPolizasView({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos la instancia de ListaPolizasViewModel a través de Provider
    // Se obtiene aquí para que esté disponible para los botones en el AppBar
    final vm = Provider.of<ListaPolizasViewModel>(context);
    final PolizaService polizaService = PolizaService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Pólizas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Botón para recargar las pólizas
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar Pólizas',
            onPressed: () {
              print('--- Botón Recargar presionado ---'); // Debug print
              vm.cargarPolizas();
            },
          ),
          // Botón para exportar a Excel
          IconButton(
            icon: const Icon(Icons.download, color: Colors.green),
            tooltip: 'Exportar a Excel',
            onPressed: () async {
              print('--- Botón Exportar a Excel presionado ---'); // Debug print
              // La lógica de exportación se moverá aquí si este print aparece

              // Lógica de permisos (mantenerla por ahora, pero el primer print es clave)
              var status = await Permission.storage.status;
              print('Excel Export: Estado inicial del permiso de almacenamiento: $status');

              if (!status.isGranted) {
                print('Excel Export: Permiso no concedido, solicitando...');
                status = await Permission.storage.request();
                print('Excel Export: Estado del permiso después de la solicitud: $status');
              }

              if (status.isGranted) {
                print('Excel Export: Permiso de almacenamiento concedido. Intentando llamar al servicio...');
                try {
                  await polizaService.exportarPolizasExcelBackend();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pólizas exportadas a Excel con éxito.')),
                    );
                  }
                } catch (e) {
                  print('Excel Export ERROR: Excepción al exportar: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al exportar a Excel: $e')),
                    );
                  }
                }
              } else {
                print('Excel Export: Permiso de almacenamiento denegado. No se puede exportar.');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Permiso de almacenamiento denegado. No se puede exportar a Excel.')),
                  );
                }
              }
            },
          ),
          // Botón para exportar a PDF
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
            tooltip: 'Exportar a PDF',
            onPressed: () async {
              print('--- Botón Exportar a PDF presionado ---'); // Debug print
              // La lógica de exportación se moverá aquí si este print aparece

              // Lógica de permisos
              var status = await Permission.storage.status;
              print('PDF Export: Estado inicial del permiso de almacenamiento: $status');

              if (!status.isGranted) {
                print('PDF Export: Permiso no concedido, solicitando...');
                status = await Permission.storage.request();
                print('PDF Export: Estado del permiso después de la solicitud: $status');
              }

              if (status.isGranted) {
                print('PDF Export: Permiso de almacenamiento concedido. Intentando llamar al servicio...');
                try {
                  await polizaService.exportarPolizasPdfBackend();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pólizas exportadas a PDF con éxito.')),
                    );
                  }
                } catch (e) {
                  print('PDF Export ERROR: Excepción al exportar: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al exportar a PDF: $e')),
                    );
                  }
                }
              } else {
                print('PDF Export: Permiso de almacenamiento denegado. No se puede exportar.');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Permiso de almacenamiento denegado. No se puede exportar a PDF.')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Consumer<ListaPolizasViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  vm.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (vm.polizas.isEmpty) {
            return const Center(child: Text("No hay pólizas registradas.", style: TextStyle(fontSize: 18, color: Colors.grey)));
          }

          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.95),
                child: DataTable(
                  headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.teal.shade50),
                  dataRowColor: MaterialStateProperty.resolveWith((states) => Colors.grey.shade50),
                  columnSpacing: 20,
                  horizontalMargin: 10,
                  columns: const [
                    DataColumn(label: Expanded(child: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text('Apellido', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text('Modelo', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text('Accidentes', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text('Edad', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text('Costo', style: TextStyle(fontWeight: FontWeight.bold)))),
                    DataColumn(label: Expanded(child: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold)))),
                  ],
                  rows: vm.polizas.map((seguro) {
                    return DataRow(
                      cells: [
                        DataCell(Text(seguro.nombrePropietario ?? 'N/A')),
                        DataCell(Text(seguro.apellidoPropietario ?? 'N/A')),
                        DataCell(Text(seguro.modeloAutomovil ?? 'N/A')),
                        DataCell(Text(seguro.accidentesAutomovil?.toString() ?? 'N/A')),
                        DataCell(Text(seguro.edadPropietario?.toString() ?? 'N/A')),
                        DataCell(Text(seguro.costoTotal.toStringAsFixed(2))),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Eliminar Póliza',
                            onPressed: () async {
                              final bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Confirmar Eliminación'),
                                    content: Text('¿Estás seguro de que quieres eliminar la póliza de ID ${seguro.id ?? 'Desconocido'}?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () { Navigator.of(dialogContext).pop(false); },
                                      ),
                                      TextButton(
                                        child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                        onPressed: () { Navigator.of(dialogContext).pop(true); },
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirm == true && seguro.id != null) {
                                await vm.eliminarPoliza(seguro.id!);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(vm.errorMessage ?? 'Póliza eliminada con éxito.')),
                                  );
                                }
                              } else if (seguro.id == null) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No se puede eliminar: ID de póliza no disponible.')),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}